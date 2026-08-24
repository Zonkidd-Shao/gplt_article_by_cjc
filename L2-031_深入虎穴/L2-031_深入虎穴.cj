// L2-031 深入虎穴 - 最深门
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var idx: Int64 = 0
    func next(): String { let v = toks[idx]; idx++; return v }
    let N = Int64.parse(next())
    let children = Array<ArrayList<Int64>>(N+1, { _ => ArrayList<Int64>() })
    let indeg = Array<Int64>(N+1, repeat: 0)
    for (i in 1..N+1) {
        let K = Int64.parse(next())
        for (_ in 0..K) {
            let d = Int64.parse(next())
            children[i].add(d)
            indeg[d] += 1
        }
    }
    var root: Int64 = 1
    for (i in 1..N+1) { if (indeg[i] == 0) { root = Int64(i); break } }
    let depth = Array<Int64>(N+1, repeat: 0)
    let q = ArrayList<Int64>()
    q.add(root)
    depth[root] = 1
    var head: Int64 = 0
    while (head < q.size) {
        let u = q[head]; head++
        for (v in children[u]) {
            depth[v] = depth[u] + 1
            q.add(v)
        }
    }
    var best = root
    var md = depth[root]
    for (i in 1..N+1) {
        if (depth[i] > md) { md = depth[i]; best = Int64(i) }
    }
    println("${best}")
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
