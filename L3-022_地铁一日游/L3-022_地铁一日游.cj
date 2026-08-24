// L3-022 地铁一日游 - 通用解法 Floyd + 费用分组 + 传递闭包
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let rawLines = all.split("\n")
    var lines = ArrayList<String>()
    for (rl in rawLines) {
        // keep empty lines to preserve structure but trim for processing
        lines.add(rl)
    }
    var idx: Int64 = 0
    // skip leading empty
    while (idx < lines.size && lines[idx].trimAscii().isEmpty()) { idx++ }
    if (idx >= lines.size) { return }
    let firstParts = splitTokens(lines[idx])
    idx++
    if (firstParts.size < 3) { return }
    let N = Int64.parse(firstParts[0])
    let M = Int64.parse(firstParts[1])
    let K = Int64.parse(firstParts[2])

    let INF: Int64 = 4000000000000000000
    // dist matrix (N+1) x (N+1)
    var dist = Array<Array<Int64>>(N+1, {_ => Array<Int64>(N+1, repeat: INF)})
    for (i in 0..(N+1)) { dist[i][i] = 0 }
    var isTerminal = Array<Bool>(N+1, repeat: false)

    // read M lines
    for (_m in 0..M) {
        // skip empty lines
        while (idx < lines.size && lines[idx].trimAscii().isEmpty()) { idx++ }
        if (idx >= lines.size) { break }
        let tok = splitTokens(lines[idx])
        idx++
        if (tok.size == 0) { continue }
        // tok is sequence station distance station ...
        // need station numbers and distances
        // size must be odd
        if (tok.size % 2 == 0) {
            // fallback: maybe line empty, continue
            continue
        }
        let cntStation = (tok.size + 1) / 2
        if (cntStation == 0) { continue }
        let firstStation = Int64.parse(tok[0])
        let lastStation = Int64.parse(tok[tok.size - 1])
        isTerminal[firstStation] = true
        isTerminal[lastStation] = true
        for (k in 0..(cntStation-1)) {
            let u = Int64.parse(tok[2*k])
            let w = Int64.parse(tok[2*k+1])
            let v = Int64.parse(tok[2*k+2])
            if (w < dist[u][v]) {
                dist[u][v] = w
                dist[v][u] = w
            }
        }
    }

    // Floyd
    for (k in 1..(N+1)) {
        for (i in 1..(N+1)) {
            if (dist[i][k] == INF) { continue }
            for (j in 1..(N+1)) {
                if (dist[k][j] == INF) { continue }
                let nd = dist[i][k] + dist[k][j]
                if (nd < dist[i][j]) { dist[i][j] = nd }
            }
        }
    }

    // build next graph
    var nxt = Array<ArrayList<Int64>>(N+1, {_ => ArrayList<Int64>()})
    for (s in 1..(N+1)) {
        var fareKeys = ArrayList<Int64>()
        var fareVals = ArrayList<Int64>()
        func getMax(f: Int64): Int64 {
            for (i in 0..fareKeys.size) { if (fareKeys[i]==f) { return fareVals[i] } }
            return -1
        }
        func setMax(f: Int64, v: Int64): Unit {
            for (i in 0..fareKeys.size) { if (fareKeys[i]==f) { fareVals[i]=v; return } }
            fareKeys.add(f); fareVals.add(v)
        }
        for (v in 1..(N+1)) {
            if (v == s) { continue }
            let d = dist[s][v]
            if (d == INF) { continue }
            let fare = 2 + d / K
            let cur = getMax(fare)
            if (cur == -1) { setMax(fare, d) } else if (d > cur) { setMax(fare, d) }
        }
        for (v in 1..(N+1)) {
            if (v == s) { continue }
            let d = dist[s][v]
            if (d == INF) { continue }
            let fare = 2 + d / K
            let mx = getMax(fare)
            if (d == mx || isTerminal[v]) {
                nxt[s].add(v)
            }
        }
    }

    // skip empty to Q
    while (idx < lines.size && lines[idx].trimAscii().isEmpty()) { idx++ }
    if (idx >= lines.size) { return }
    let qTok = splitTokens(lines[idx])
    idx++
    if (qTok.size == 0) { return }
    let Q = Int64.parse(qTok[0])

    for (_q in 0..Q) {
        while (idx < lines.size && lines[idx].trimAscii().isEmpty()) { idx++ }
        if (idx >= lines.size) { break }
        let t = splitTokens(lines[idx])
        idx++
        if (t.size == 0) { continue }
        let start = Int64.parse(t[0])
        // BFS/DFS transitive closure
        var vis = Array<Bool>(N+1, repeat: false)
        var queue = ArrayList<Int64>()
        vis[start] = true
        queue.add(start)
        var qhead: Int64 = 0
        while (qhead < queue.size) {
            let u = queue[qhead]; qhead++
            for (v in nxt[u]) {
                if (!vis[v]) {
                    vis[v] = true
                    queue.add(v)
                }
            }
        }
        var sb = StringBuilder()
        var first = true
        for (i in 1..(N+1)) {
            if (vis[i]) {
                if (!first) { sb.append(" ") }
                sb.append(i.toString())
                first = false
            }
        }
        println(sb.toString())
    }
}

func splitTokens(s: String): Array<String> {
    let parts = s.split(" ")
    let res = ArrayList<String>()
    for (p in parts) {
        // split may produce entries with tabs; further split by tab
        let sub = p.split("\t")
        for (q in sub) {
            let t = q.trimAscii()
            if (t.size > 0) { res.add(t) }
        }
    }
    // also need to handle multiple spaces already trimmed, but split(" ") on "a  b" gives empty entries which trimmed size 0 filtered
    return res.toArray()
}
