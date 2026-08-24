// L1-062 幸运彩票 - 前3后3和
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let all = (getStdIn().readToEnd() ?? "")
    if (all.trimAscii().size == 0) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    let ra = all.toRuneArray()
    for (i in 0..Int64(ra.size)) {
        let c = ra[i]
        if (c != r' ' && c != r'\n' && c != r'\r' && c != r'\t') {
            cur.append("${c}")
        } else {
            if (cur.size > 0) { tokens.add(cur.toString()); cur = StringBuilder() }
        }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    for (k in 0..n) {
        let idx = 1 + k
        if (idx >= Int64(tokens.size)) { break }
        let t = tokens[idx]
        let a = t.toRuneArray()
        var sum1: Int64 = 0
        var sum2: Int64 = 0
        for (i in 0..3) { sum1 += Int64.parse("${a[i]}") }
        for (i in 3..6) { sum2 += Int64.parse("${a[i]}") }
        if (sum1 == sum2) {
            println("You are lucky!")
        } else {
            println("Wish you good luck.")
        }
    }
}
