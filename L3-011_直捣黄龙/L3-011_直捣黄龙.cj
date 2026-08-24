// L3-011 直捣黄龙 - Dijkstra with secondary criteria
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let N = Int64.parse(next())
    let K = Int64.parse(next())
    let startCity = next()
    let endCity = next()
    let cityIndex = HashMap<String, Int64>()
    let cityName = ArrayList<String>()
    let enemy = ArrayList<Int64>()
    cityIndex[startCity] = 0
    cityName.add(startCity)
    enemy.add(0)
    for (i in 1..N) {
        let name = next()
        let e = Int64.parse(next())
        cityIndex[name] = i
        cityName.add(name)
        enemy.add(e)
    }
    let n: Int64 = N
    let graph = Array<ArrayList<Array<Int64>>>(n, { _ => ArrayList<Array<Int64>>() })
    for (_ in 0..K) {
        let c1s = next()
        let c2s = next()
        let d = Int64.parse(next())
        let c1 = cityIndex[c1s]
        let c2 = cityIndex[c2s]
        let a = c1
        let b = c2
        graph[a].add([b, d])
        graph[b].add([a, d])
    }
    let INF: Int64 = 9000000000000000
    let dist = Array<Int64>(n, repeat: INF)
    let cnt = Array<Int64>(n, repeat: 0)
    let cityCnt = Array<Int64>(n, repeat: 0)
    let kills = Array<Int64>(n, repeat: 0)
    let parent = Array<Int64>(n, repeat: -1)
    let visited = Array<Bool>(n, repeat: false)
    dist[0] = 0
    cnt[0] = 1
    cityCnt[0] = 1
    for (_ in 0..n) {
        var u: Int64 = -1
        var best = INF
        for (i in 0..n) {
            if (!visited[i] && dist[i] < best) {
                best = dist[i]
                u = i
            }
        }
        if (u == -1) { break }
        visited[u] = true
        for (edge in graph[u]) {
            let v = edge[0]
            let w = edge[1]
            if (visited[v]) { continue }
            let nd = dist[u] + w
            if (nd < dist[v]) {
                dist[v] = nd
                cnt[v] = cnt[u]
                cityCnt[v] = cityCnt[u] + 1
                kills[v] = kills[u] + enemy[v]
                parent[v] = u
            } else if (nd == dist[v]) {
                cnt[v] = cnt[v] + cnt[u]
                let candC = cityCnt[u] + 1
                let candK = kills[u] + enemy[v]
                if (candC > cityCnt[v] || (candC == cityCnt[v] && candK > kills[v])) {
                    cityCnt[v] = candC
                    kills[v] = candK
                    parent[v] = u
                }
            }
        }
    }
    let endIdx = cityIndex[endCity]
    var rev = ArrayList<String>()
    var cur: Int64 = endIdx
    while (cur != -1) {
        rev.add(cityName[cur])
        cur = parent[cur]
    }
    let sb = StringBuilder()
    var i = rev.size - 1
    var first = true
    while (i >= 0) {
        if (!first) { sb.append("->") }
        sb.append(rev[i])
        first = false
        i--
    }
    println(sb.toString())
    println("${cnt[endIdx]} ${dist[endIdx]} ${kills[endIdx]}")
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
