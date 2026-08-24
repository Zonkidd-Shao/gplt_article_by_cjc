// L3-014 周游世界 - expanded Dijkstra for min stops then transfers
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let N = Int64.parse(next())
    // station string -> id
    let idMap = HashMap<String, Int64>()
    var idCnt: Int64 = 0
    func getId(s: String): Int64 {
        let opt = idMap.get(s)
        if (let Some(v) <- opt) { return v }
        let nid = idCnt
        idMap[s] = nid
        idCnt++
        return nid
    }
    // adjacency per station: list of (neighbor, company)
    var adj = ArrayList<ArrayList<Array<Int64>>>()
    // we will expand after knowing idCnt, use dynamic
    // temporary store lines
    var lines = ArrayList<Array<Int64>>()
    // also store per line stations ids
    var lineStations = ArrayList<Array<Int64>>()
    for (comp in 1..=N) {
        let M = Int64.parse(next())
        var stations = ArrayList<Int64>()
        for (_ in 0..M) {
            let s = next()
            let sid = getId(s)
            stations.add(sid)
        }
        lineStations.add(stations.toArray())
    }
    // build id arrays and reverse map id -> string
    let V = idCnt
    // build string array
    var idToStr = Array<String>(V, repeat: "")
    for ((k, v) in idMap) { idToStr[v] = k }
    // rebuild adj sized V
    var g = Array<ArrayList<Array<Int64>>>(V, { _ => ArrayList<Array<Int64>>() })
    for (compIdx in 0..lineStations.size) {
        let stations = lineStations[compIdx]
        let comp = compIdx + 1
        for (i in 1..stations.size) {
            let a = stations[i-1]
            let b = stations[i]
            g[a].add([b, comp])
            g[b].add([a, comp])
        }
    }
    let K = Int64.parse(next())
    let out = StringBuilder()
    for (_ in 0..K) {
        let sStr = next()
        let tStr = next()
        if (!idMap.contains(sStr) || !idMap.contains(tStr)) {
            out.append("Sorry, no line is available.\n")
            continue
        }
        let s = idMap[sStr]
        let t = idMap[tStr]
        if (s == t) {
            out.append("0\n")
            continue
        }
        // expanded Dijkstra
        // states: map from (node*128 + comp) -> index in arrays
        // Since N<=100, comp up to 100, use 128 multiplier
        // We'll collect all state ids as we go: initially s with comp 0
        // Use HashMap for dist
        let INF: Int64 = 9000000000000000
        // distSteps and distTrans per state key
        var stateKeys = ArrayList<Int64>()
        let keyOf = { node: Int64, comp: Int64 => node * 128 + comp }
        let startKey = keyOf(s, 0)
        stateKeys.add(startKey)
        // For quick lookup, we will maintain maps
        let distSteps = HashMap<Int64, Int64>()
        let distTrans = HashMap<Int64, Int64>()
        let prevState = HashMap<Int64, Int64>()
        let prevNode = HashMap<Int64, Int64>() // predecessor node for path reconstruction? Actually need edge
        // Initialize
        distSteps[startKey] = 0
        distTrans[startKey] = 0
        prevState[startKey] = -1
        // visited set
        let visited = HashSet<Int64>()
        // To generate neighbours we need to know state set dynamically: when we relax to new state, add to stateKeys
        var found = false
        var bestKey: Int64 = -1
        var bestSteps: Int64 = INF
        var bestTrans: Int64 = INF
        while (true) {
            var curKey: Int64 = -1
            var curSteps: Int64 = INF
            var curTrans: Int64 = INF
            for (k in stateKeys) {
                if (visited.contains(k)) { continue }
                if (!distSteps.contains(k)) { continue }
                let ds = distSteps[k]
                let dt = distTrans[k]
                if (ds < curSteps || (ds == curSteps && dt < curTrans)) {
                    curSteps = ds; curTrans = dt; curKey = k
                }
            }
            if (curKey == -1) { break }
            visited.add(curKey)
            let curNode = curKey / 128
            let curComp = curKey % 128
            if (curNode == t) {
                // we have reached t; since Dijkstra in lex order, first t popped is optimal among all comps
                bestKey = curKey; bestSteps = curSteps; bestTrans = curTrans; found = true; break
            }
            // expand neighbours
            for (edge in g[curNode]) {
                let nb = edge[0]
                let comp = edge[1]
                let ns = curSteps + 1
                let nt = curTrans + (if (curComp == 0 || curComp == comp) {0} else {1})
                let nKey = keyOf(nb, comp)
                // if not yet in stateKeys, add
                if (!distSteps.contains(nKey)) {
                    stateKeys.add(nKey)
                }
                var needUpdate = false
                if (!distSteps.contains(nKey)) { needUpdate = true }
                else {
                    let oldSteps = distSteps[nKey]
                    let oldTrans = distTrans[nKey]
                    if (ns < oldSteps || (ns == oldSteps && nt < oldTrans)) { needUpdate = true }
                }
                if (needUpdate) {
                    distSteps[nKey] = ns
                    distTrans[nKey] = nt
                    prevState[nKey] = curKey
                }
            }
        }
        if (!found) {
            out.append("Sorry, no line is available.\n")
            continue
        }
        // reconstruct node path
        var revNodes = ArrayList<Int64>()
        var revComps = ArrayList<Int64>()
        var cur = bestKey
        while (cur != -1) {
            let node = cur / 128
            let comp = cur % 128
            revNodes.add(node)
            revComps.add(comp)
            if (!prevState.contains(cur)) { break }
            cur = prevState[cur]
            if (cur == -1) { break }
        }
        // rev is from t to s, reverse
        var pathNodes = ArrayList<Int64>()
        var pathComps = ArrayList<Int64>()
        var i = revNodes.size - 1
        while (i >= 0) {
            pathNodes.add(revNodes[i])
            pathComps.add(revComps[i])
            i--
        }
        // pathNodes[0]=s with comp 0, rest have comp of edge used to arrive
        // Build segments: compress consecutive same comp
        // pathNodes length = steps+1, pathComps length same, pathComps[0]=0
        let steps = bestSteps // equals pathNodes.size-1
        out.append("${steps}\n")
        // build segments list
        var segStartIdx: Int64 = 0 // index in pathNodes
        var curComp = pathComps[1]
        var segStartNode = pathNodes[0]
        var idx: Int64 = 1
        while (idx < pathNodes.size) {
            let comp = pathComps[idx]
            // if next comp differs or last node, close segment
            let isLast = idx == pathNodes.size - 1
            let nextComp = if (!isLast) { pathComps[idx+1] } else { -1 }
            if (isLast || nextComp != curComp) {
                let endNode = pathNodes[idx]
                // company is curComp
                out.append("Go by the line of company #${curComp} from ${idToStr[segStartNode]} to ${idToStr[endNode]}.\n")
                if (!isLast) {
                    segStartNode = endNode
                    curComp = nextComp
                }
            }
            idx++
        }
    }
    print(out.toString())
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { res.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
