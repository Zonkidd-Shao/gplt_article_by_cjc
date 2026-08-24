// L1-053 电子汪 — 输出A+B个Wang!
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var parts = all.split(" ")
    var toks = ArrayList<String>()
    for (p in parts) {
        let a = p.split("\n")
        for (q in a) {
            let b = q.split("\r")
            for (r in b) {
                let c = r.split("\t")
                for (t in c) {
                    let s = t.trimAscii()
                    if (!s.isEmpty()) { toks.add(s) }
                }
            }
        }
    }
    if (toks.size < 2) { return }
    let a = Int64.parse(toks[0])
    let b = Int64.parse(toks[1])
    let sum = a + b
    let sb = StringBuilder()
    var i: Int64 = 0
    while (i < sum) { sb.append("Wang!"); i += 1 }
    println(sb.toString())
}
