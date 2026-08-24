// L2-026 小字辈 - BFS最深
import std.env.*
import std.collection.*
import std.convert.*
import std.sort.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var idx: Int64 = 0
    func next(): String { let v = toks[idx]; idx++; return v }
    let N = Int64.parse(next())
    let parent = Array<Int64>(N+1, repeat: 0)
    var root: Int64 = 1
    let children = Array<ArrayList<Int64>>(N+1, { _ => ArrayList<Int64>() })
    for (i in 1..N+1) {
        let p = Int64.parse(next())
        parent[i] = p
        if (p == -1) { root = Int64(i) } else { children[p].add(Int64(i)) }
    }
    let depth = Array<Int64>(N+1, repeat: 0)
    let q = ArrayList<Int64>()
    q.add(root)
    depth[root] = 1
    var head: Int64 = 0
    var maxD: Int64 = 1
    while (head < q.size) {
        let u = q[head]; head++
        for (v in children[u]) {
            depth[v] = depth[u] + 1
            if (depth[v] > maxD) { maxD = depth[v] }
            q.add(v)
        }
    }
    println("${maxD}")
    let res = ArrayList<Int64>()
    for (i in 1..N+1) { if (depth[i] == maxD) { res.add(Int64(i)) } }
    sort(res)
    let sb = StringBuilder()
    for (i in 0..res.size) {
        if (i > 0) { sb.append(" ") }
        sb.append("${res[i]}")
    }
    println(sb.toString())
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
