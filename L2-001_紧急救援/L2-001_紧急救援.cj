// L2-001 紧急救援 - Dijkstra with counting
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let sp: Rune = ' '
    let nl: Rune = '\n'
    let cr: Rune = '\r'
    let tab: Rune = '\t'
    var tokens = ArrayList<String>()
    var sb = StringBuilder()
    var inTok = false
    for (ch in all.toRuneArray()) {
        let isSpace = (ch == sp) || (ch == nl) || (ch == cr) || (ch == tab)
        if (isSpace) {
            if (inTok) { tokens.add(sb.toString()); sb=StringBuilder(); inTok=false }
        } else { sb.append(ch); inTok=true }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size < 4) { return }
    let n = Int64.parse(tokens[0])
    let m = Int64.parse(tokens[1])
    let src = Int64.parse(tokens[2])
    let dst = Int64.parse(tokens[3])
    var teams = ArrayList<Int64>()
    for (i in 0..n) {
        let idx = 4 + i
        if (idx < tokens.size) { teams.add(Int64.parse(tokens[idx])) } else { teams.add(0) }
    }
    var adj = ArrayList<ArrayList<Int64>>()
    for (_ in 0..n) { adj.add(ArrayList<Int64>()) }
    var pos: Int64 = 4 + n
    for (_ in 0..m) {
        if (pos + 2 >= tokens.size) { break }
        let u = Int64.parse(tokens[pos])
        let v = Int64.parse(tokens[pos+1])
        let w = Int64.parse(tokens[pos+2])
        pos += 3
        // adj stores pairs: neighbor, weight interleaved? We'll store as two separate adds but need to know structure
        // Use two entries per neighbor: first neighbor, second weight
        adj[u].add(v)
        adj[u].add(w)
        adj[v].add(u)
        adj[v].add(w)
    }
    let INF: Int64 = 1000000000
    var dist = ArrayList<Int64>()
    var cnt = ArrayList<Int64>()
    var maxTeams = ArrayList<Int64>()
    var prev = ArrayList<Int64>()
    var visited = ArrayList<Bool>()
    for (i in 0..n) {
        dist.add(INF)
        cnt.add(0)
        maxTeams.add(0)
        prev.add(-1)
        visited.add(false)
    }
    dist[src] = 0
    cnt[src] = 1
    maxTeams[src] = teams[src]
    for (_ in 0..n) {
        var u: Int64 = -1
        var minD: Int64 = INF
        for (i in 0..n) {
            if (!visited[i] && dist[i] < minD) { minD = dist[i]; u = i }
        }
        if (u == -1) { break }
        visited[u] = true
        let du = dist[u]
        // iterate neighbors
        var j: Int64 = 0
        while (j < adj[u].size) {
            let v = adj[u][j]
            let w = adj[u][j+1]
            j += 2
            if (visited[v]) { continue }
            let nd = du + w
            if (dist[v] > nd) {
                dist[v] = nd
                cnt[v] = cnt[u]
                maxTeams[v] = maxTeams[u] + teams[v]
                prev[v] = u
            } else if (dist[v] == nd) {
                cnt[v] += cnt[u]
                let cand = maxTeams[u] + teams[v]
                if (cand > maxTeams[v]) {
                    maxTeams[v] = cand
                    prev[v] = u
                }
            }
        }
    }
    println("${cnt[dst]} ${maxTeams[dst]}")
    // reconstruct path
    var path = ArrayList<Int64>()
    var cur = dst
    while (cur != -1) {
        path.add(cur)
        cur = prev[cur]
    }
    // path is reverse
    var out = StringBuilder()
    var idx2 = path.size - 1
    while (idx2 >= 0) {
        if (idx2 != path.size - 1) { out.append(" ") }
        out.append(path[idx2])
        idx2 -= 1
    }
    println(out.toString())
}
