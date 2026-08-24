// L3-028 森森旅游 - 通用解法：双 Dijkstra + 逐次更新最小现金
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
    let n = Int64.parse(next()); let m = Int64.parse(next()); let q = Int64.parse(next())
    var edges = ArrayList<Array<Int64>>()
    var adjC = Array<ArrayList<Array<Int64>>>(n+1, {_ => ArrayList<Array<Int64>>()})
    var revD = Array<ArrayList<Array<Int64>>>(n+1, {_ => ArrayList<Array<Int64>>()})
    for (_i in 0..m) {
        let u = Int64.parse(next()); let v = Int64.parse(next()); let c = Int64.parse(next()); let d = Int64.parse(next())
        edges.add([u,v,c,d])
        adjC[u].add([v,c])
        revD[v].add([u,d])
    }
    var a = Array<Int64>(n+1, repeat: 0)
    for (i in 1..(n+1)) { a[i] = Int64.parse(next()) }

    // 预计算 cashDist (从1出发用c) 和 goldDist (从n反向用d) 的 Dijkstra（O(n^2) 版本可通过中小规模）
    func dijkstraCash(): Array<Int64> {
        let INF: Int64 = 4000000000000000000
        var dist = Array<Int64>(n+1, repeat: INF)
        var vis = Array<Bool>(n+1, repeat: false)
        dist[1] = 0
        for (_k in 0..n) {
            var u: Int64 = -1; var best: Int64 = INF
            for (i in 1..(n+1)) { if (!vis[i] && dist[i] < best) { best = dist[i]; u = i } }
            if (u == -1) { break }
            vis[u] = true
            for (e in adjC[u]) {
                let v = e[0]; let w = e[1]
                if (dist[v] > dist[u] + w) { dist[v] = dist[u] + w }
            }
        }
        return dist
    }
    func dijkstraGold(): Array<Int64> {
        let INF: Int64 = 4000000000000000000
        var dist = Array<Int64>(n+1, repeat: INF)
        var vis = Array<Bool>(n+1, repeat: false)
        dist[n] = 0
        for (_k in 0..n) {
            var u: Int64 = -1; var best: Int64 = INF
            for (i in 1..(n+1)) { if (!vis[i] && dist[i] < best) { best = dist[i]; u = i } }
            if (u == -1) { break }
            vis[u] = true
            for (e in revD[u]) {
                let fr = e[0]; let w = e[1]
                if (dist[fr] > dist[u] + w) { dist[fr] = dist[u] + w }
            }
        }
        return dist
    }

    var cash = dijkstraCash()
    var gold = dijkstraGold()
    let INF: Int64 = 4000000000000000000

    for (_i in 0..q) {
        let x = Int64.parse(next()); let na = Int64.parse(next())
        a[x] = na
        var best: Int64 = INF
        for (i in 1..(n+1)) {
            if (cash[i] == INF || gold[i] == INF) { continue }
            // 需要 ceil(gold[i] / a[i])
            let need = (gold[i] + a[i] - 1) / a[i]
            let tot = cash[i] + need
            if (tot < best) { best = tot }
        }
        // 若无中间换汇点，则全现金直达
        if (best == INF) { best = cash[n] }
        println(best.toString())
    }
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs==" "||rs=="\n"||rs=="\r"||rs=="\t") { if (cur.size>0){res.add(cur.toString()); cur=StringBuilder()} } else {cur.append(rs)}
    }
    if (cur.size>0){res.add(cur.toString())}
    return res.toArray()
}
