// L3-044 花砖物语 - 二分图最大匹配 (全拿模型)
import std.collection.*
import std.convert.*
import std.env.*

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
        let rs = Array<Int64>(n, repeat: 0)
        let bs = Array<Int64>(n, repeat: 0)
        for (i in 0..n) {
            rs[i] = Int64.parse(toks[idx]); idx++
            bs[i] = Int64.parse(toks[idx]); idx++
            wsbdwzbl += rs[i] + bs[i]
        }
        let ans = solveOne(n, rs, bs)
        println(ans.toString())
    }
}

func solveOne(n: Int64, rs: Array<Int64>, bs: Array<Int64>): Int64 {
    // build adjacency from red (1..n) to blues
    let adj = Array<ArrayList<Int64>>(n + 1, repeat: ArrayList<Int64>())
    for (i in 0..n+1) { adj[i] = ArrayList<Int64>() }
    for (i in 0..n) {
        let r = rs[i]
        let b = bs[i]
        if (r >= 1 && r <= n && b >= 1 && b <= n) {
            adj[r].add(b)
        }
    }
    // Hopcroft-Karp
    let pairU = Array<Int64>(n + 1, repeat: 0) // 0 = NIL
    let pairV = Array<Int64>(n + 1, repeat: 0)
    let dist = Array<Int64>(n + 1, repeat: 0)
    func bfs(): Bool {
        let q = ArrayList<Int64>()
        for (u in 1..n+1) {
            if (pairU[u] == 0) {
                dist[u] = 0
                q.add(u)
            } else {
                dist[u] = -1
            }
        }
        var found = false
        var qh: Int64 = 0
        while (qh < q.size) {
            let u = q[qh]; qh++
            for (v in adj[u]) {
                let pu = pairV[v]
                if (pu == 0) {
                    found = true
                } else if (dist[pu] == -1) {
                    dist[pu] = dist[u] + 1
                    q.add(pu)
                }
            }
        }
        return found
    }
    func dfs(u: Int64): Bool {
        for (v in adj[u]) {
            let pu = pairV[v]
            if (pu == 0 || (dist[pu] == dist[u] + 1 && dfs(pu))) {
                pairU[u] = v
                pairV[v] = u
                return true
            }
        }
        dist[u] = -1
        return false
    }
    var matching: Int64 = 0
    while (bfs()) {
        for (u in 1..n+1) {
            if (pairU[u] == 0) {
                if (dfs(u)) { matching++ }
            }
        }
    }
    return n + matching
}
