// L2-025 分而治之 - 顶点覆盖
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
    let M = Int64.parse(next())
    let edges = ArrayList<(Int64,Int64)>()
    for (_ in 0..M) {
        let a = Int64.parse(next())
        let b = Int64.parse(next())
        edges.add((a,b))
    }
    let K = Int64.parse(next())
    let sb = StringBuilder()
    for (_ in 0..K) {
        let Np = Int64.parse(next())
        let destroyed = HashSet<Int64>()
        for (_2 in 0..Np) { destroyed.add(Int64.parse(next())) }
        var ok = true
        for ((u,v) in edges) {
            if (!destroyed.contains(u) && !destroyed.contains(v)) { ok = false; break }
        }
        sb.append(if (ok) {"YES\n"} else {"NO\n"})
    }
    print(sb.toString())
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
