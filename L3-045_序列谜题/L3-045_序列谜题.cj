// L3-045 序列谜题 - 交换中心计数 (a∘b = b∘a)
import std.collection.*
import std.convert.*
import std.env.*

let MOD: Int64 = 998244353
func modPow(a: Int64, e: Int64): Int64 {
    var r: Int64 = 1
    var b = a % MOD
    var ee = e
    while (ee > 0) {
        if ((ee & 1) == 1) { r = r * b % MOD }
        b = b * b % MOD
        ee >>= 1
    }
    return r
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size > 0) { toks.add(p) } }
    var idx: Int64 = 0
    let T = Int64.parse(toks[idx]); idx++
    var wsbdwzbl: Int64 = T
    for (tc in 0..T) {
        let n = Int64.parse(toks[idx]); idx++
        let a = Array<Int64>(n + 1, repeat: 0)
        for (i in 1..n+1) {
            a[i] = Int64.parse(toks[idx]); idx++
            wsbdwzbl += a[i]
        }
        let ans = solveCase(n, a)
        println(ans.toString())
    }
}

func solveCase(n: Int64, a: Array<Int64>): Int64 {
    // build reverse adjacency
    let rev = Array<ArrayList<Int64>>(n + 1, repeat: ArrayList<Int64>())
    for (i in 0..n+1) { rev[i] = ArrayList<Int64>() }
    for (i in 1..n+1) {
        let to = a[i]
        if (to >= 1 && to <= n) { rev[to].add(i) }
    }
    // find cycles via Kahn (indeg pruning)
    let indeg = Array<Int64>(n + 1, repeat: 0)
    for (i in 1..n+1) { indeg[a[i]]++ }
    let q = ArrayList<Int64>()
    let isCycle = Array<Bool>(n + 1, repeat: true)
    for (i in 1..n+1) { if (indeg[i] == 0) { q.add(i) } }
    var qh: Int64 = 0
    while (qh < q.size) {
        let u = q[qh]; qh++
        isCycle[u] = false
        let v = a[u]
        indeg[v]--
        if (indeg[v] == 0) { q.add(v) }
    }
    // collect cycles
    let visited = Array<Bool>(n + 1, repeat: false)
    let cycles = ArrayList<ArrayList<Int64>>()
    let nodeCycleIdx = Array<Int64>(n + 1, repeat: -1)
    let nodePos = Array<Int64>(n + 1, repeat: -1)
    for (i in 1..n+1) {
        if (isCycle[i] && !visited[i]) {
            let cyc = ArrayList<Int64>()
            var cur = i
            while (!visited[cur]) {
                visited[cur] = true
                cyc.add(cur)
                cur = a[cur]
            }
            // cyc is in order of traversal, which follows a
            let cid: Int64 = cycles.size
            for (j in 0..cyc.size) {
                let node = cyc[j]
                nodeCycleIdx[node] = cid
                nodePos[node] = j
            }
            cycles.add(cyc)
        }
    }
    let C = cycles.size
    // For each cycle, collect tree nodes info: list of (depth, ancPos)
    let treeInfos = Array<ArrayList<Array<Int64>>>(C, repeat: ArrayList<Array<Int64>>())
    for (i in 0..C) { treeInfos[i] = ArrayList<Array<Int64>>() }
    // Also need mapping from node to its cycle ancestor for tree nodes? We can BFS per cycle
    for (cid in 0..C) {
        let cyc = cycles[cid]
        // for each node in cycle, do DFS for its tree
        for (pos in 0..cyc.size) {
            let root = cyc[pos]
            // stack of (node, depth)
            let stackNode = ArrayList<Int64>()
            let stackDepth = ArrayList<Int64>()
            for (child in rev[root]) {
                if (isCycle[child]) { continue }
                stackNode.add(child)
                stackDepth.add(1)
            }
            var sp: Int64 = 0
            while (sp < stackNode.size) {
                let node = stackNode[sp]
                let d = stackDepth[sp]
                sp++
                // record
                let info = Array<Int64>(2, repeat: 0)
                info[0] = d
                info[1] = pos // anc pos
                treeInfos[cid].add(info)
                for (child in rev[node]) {
                    stackNode.add(child)
                    stackDepth.add(d + 1)
                }
            }
        }
    }
    // If no cycles? Should not happen (functional graph always has at least one cycle)
    // Memo for cnt: HashMap key = v*100000 + d  (approx) use HashMap<String,Int64> or 2D map
    // Use HashMap<Int64, HashMap<Int64,Int64>> memo per v
    let memo = Array<HashMap<Int64,Int64>>(n + 1, repeat: HashMap<Int64,Int64>())
    for (i in 0..n+1) { memo[i] = HashMap<Int64,Int64>() }
    func getCnt(v: Int64, d: Int64): Int64 {
        if (d == 0) { return 1 }
        if (memo[v].contains(d)) { return memo[v][d] }
        var sum: Int64 = 0
        for (p in rev[v]) {
            sum = (sum + getCnt(p, d - 1)) % MOD
        }
        memo[v][d] = sum
        return sum
    }
    // helper to get kth successor within cycle
    func succ(v: Int64, k: Int64): Int64 {
        if (k == 0) { return v }
        let cid = nodeCycleIdx[v]
        if (cid == -1) { // v not cycle (should not happen for target v which is cycle)
            var cur = v
            for (i in 0..k) { cur = a[cur] }
            return cur
        }
        let cyc = cycles[cid]
        let L = cyc.size
        let pos = nodePos[v]
        let np = (pos + k) % L
        return cyc[np]
    }
    var totalAns: Int64 = 1
    for (cid in 0..C) {
        let cyc = cycles[cid]
        let L = cyc.size
        // eligible target nodes: all cycle nodes whose cycle length divides L
        let eligible = ArrayList<Int64>()
        for (cid2 in 0..C) {
            let cyc2 = cycles[cid2]
            let L2 = cyc2.size
            if (L % L2 == 0) {
                for (node in cyc2) { eligible.add(node) }
            }
        }
        var sum: Int64 = 0
        for (v in eligible) {
            var prod: Int64 = 1
            for (info in treeInfos[cid]) {
                let d = info[0]
                let anc = info[1]
                let targetAnc = succ(v, anc)
                let cnt = getCnt(targetAnc, d)
                prod = prod * cnt % MOD
                if (prod == 0) { break }
            }
            sum = (sum + prod) % MOD
        }
        totalAns = totalAns * sum % MOD
    }
    return totalAns
}
