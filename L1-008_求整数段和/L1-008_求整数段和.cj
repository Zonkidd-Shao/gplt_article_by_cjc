// L1-008 求整数段和
// approach: print A..B each width 5 right aligned, 5 per line, sum
import std.env.*
import std.convert.*
import std.collection.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { tokens.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    let a = Int64.parse(tokens[0])
    let b = Int64.parse(tokens[1])
    var sum: Int64 = 0
    var lineCnt: Int64 = 0
    var sb = StringBuilder()
    var num = a
    while (num <= b) {
        sum += num
        let s = "${num}"
        let pad = 5 - Int64(s.size)
        for (_ in 0..pad) { sb.append(" ") }
        sb.append(s)
        lineCnt += 1
        if (lineCnt % 5 == 0) {
            sb.append("\n")
        }
        num += 1
    }
    if (lineCnt % 5 != 0) { sb.append("\n") }
    sb.append("Sum = ${sum}")
    println(sb.toString())
}
