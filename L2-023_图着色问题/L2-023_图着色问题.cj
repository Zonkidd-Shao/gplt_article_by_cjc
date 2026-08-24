// L2-023 图着色问题 - 检查邻接异色且颜色数<=K
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
    let V = Int64.parse(next())
    let E = Int64.parse(next())
    let K = Int64.parse(next())
    let edges = ArrayList<(Int64,Int64)>()
    for (_ in 0..E) {
        let a = Int64.parse(next())
        let b = Int64.parse(next())
        edges.add((a,b))
    }
    let N = Int64.parse(next())
    let sb = StringBuilder()
    for (_ in 0..N) {
        let colors = Array<Int64>(V + 1, repeat: 0)
        let set = HashSet<Int64>()
        for (i in 1..V+1) {
            let c = Int64.parse(next())
            colors[i] = c
            set.add(c)
        }
        var ok = true
        if (set.size > K) { ok = false } else {
            for ((u,v) in edges) {
                if (colors[u] == colors[v]) { ok = false; break }
            }
        }
        sb.append(if (ok) {"Yes\n"} else {"No\n"})
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
