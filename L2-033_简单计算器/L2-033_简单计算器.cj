// L2-033 简单计算器 - 双栈逆序
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
    let nums = ArrayList<Int64>()
    for (_ in 0..N) { nums.add(Int64.parse(next())) }
    let ops = ArrayList<String>()
    for (_ in 0..N-1) { ops.add(next()) }
    var ns = ArrayList<Int64>()
    var os = ArrayList<String>()
    for (x in nums) { ns.add(x) }
    for (o in ops) { os.add(o) }
    while (ns.size > 1 && os.size > 0) {
        let n1 = ns[ns.size-1]; ns.remove(at: ns.size-1)
        let n2 = ns[ns.size-1]; ns.remove(at: ns.size-1)
        let op = os[os.size-1]; os.remove(at: os.size-1)
        if (op == "/") {
            if (n1 == 0) {
                println("ERROR: ${n2}/0")
                return
            }
            ns.add(n2 / n1)
        } else if (op == "+") {
            ns.add(n2 + n1)
        } else if (op == "-") {
            ns.add(n2 - n1)
        } else if (op == "*") {
            ns.add(n2 * n1)
        }
    }
    if (ns.size > 0) { println("${ns[0]}") }
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
