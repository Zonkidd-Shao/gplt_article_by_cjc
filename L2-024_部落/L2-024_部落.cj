// L2-024 部落 - 并查集
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
    let MAX: Int64 = 10000
    let parent = Array<Int64>(MAX+1, { i => i })
    let exists = Array<Bool>(MAX+1, repeat: false)
    func find(x: Int64): Int64 {
        var r = x
        while (parent[r] != r) { r = parent[r] }
        var cur = x
        while (parent[cur] != r) {
            let nxt = parent[cur]
            parent[cur] = r
            cur = nxt
        }
        return r
    }
    func union(a: Int64, b: Int64): Unit {
        let ra = find(a)
        let rb = find(b)
        if (ra != rb) { parent[rb] = ra }
    }
    for (_ in 0..N) {
        let K = Int64.parse(next())
        var first: Int64 = -1
        for (j in 0..K) {
            let p = Int64.parse(next())
            exists[p] = true
            if (j == 0) { first = p } else { union(first, p) }
        }
    }
    var total: Int64 = 0
    let roots = HashSet<Int64>()
    for (i in 1..MAX+1) {
        if (exists[i]) {
            total += 1
            roots.add(find(Int64(i)))
        }
    }
    let sb = StringBuilder()
    sb.append("${total} ${roots.size}\n")
    let Q = Int64.parse(next())
    for (_ in 0..Q) {
        let a = Int64.parse(next())
        let b = Int64.parse(next())
        if (a == b) {
            sb.append("Y\n")
        } else {
            let fa = find(a)
            let fb = find(b)
            sb.append(if (fa == fb) {"Y\n"} else {"N\n"})
        }
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
