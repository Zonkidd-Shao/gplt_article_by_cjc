// L1-080 乘法口诀数列 - 按乘法口诀生成数列
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let cleaned = all.replace("\r", " ").replace("\n", " ").replace("\t", " ")
    var raw = cleaned.split(" ")
    var tokens = ArrayList<String>()
    for (p in raw) { if (p.trimAscii().size > 0) { tokens.add(p.trimAscii()) } }
    if (tokens.size < 3) { return }
    let a1 = Int64.parse(tokens[0])
    let a2 = Int64.parse(tokens[1])
    let n = Int64.parse(tokens[2])
    if (n == 0) { return }
    var seq = ArrayList<Int64>()
    seq.add(a1)
    if (n > 1) { seq.add(a2) }
    if (n == 1) {
        println("${a1}")
        return
    }
    var idx: Int64 = 0
    while (Int64(seq.size) < n) {
        let cur = seq[idx]
        let nxt = seq[idx + 1]
        let prod = cur * nxt
        if (prod < 10) {
            seq.add(prod)
        } else {
            seq.add(prod / 10)
            if (Int64(seq.size) < n) {
                seq.add(prod % 10)
            }
        }
        idx++
    }
    var out = StringBuilder()
    for (i in 0..seq.size) {
        if (i > 0) { out.append(" ") }
        out.append(seq[i])
    }
    println(out.toString())
}
