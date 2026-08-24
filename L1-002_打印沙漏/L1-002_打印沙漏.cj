// L1-002 打印沙漏
// approach: total=2*m*m-1 <=N, hourglass rows=2*m-1
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let trimmed = all.trimAscii()
    if (trimmed.isEmpty()) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) {
                tokens.add(cur.toString())
                cur = StringBuilder()
            }
        } else {
            cur.append(rs)
        }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    if (tokens.size < 2) { return }
    let n = Int64.parse(tokens[0])
    let sym = tokens[1]
    var m: Int64 = 0
    var k: Int64 = 1
    while (2*k*k - 1 <= n) {
        m = k
        k += 1
    }
    if (m == 0) {
        println(n)
        return
    }
    let used = 2*m*m - 1
    let remain = n - used
    let sb = StringBuilder()
    for (i in 0..m) {
        let stars = 2*(m - i) - 1
        if (stars < 1) { continue }
        let spaces = i
        for (_ in 0..spaces) { sb.append(" ") }
        for (_ in 0..stars) { sb.append(sym) }
        sb.append("\n")
    }
    for (i in 2..=m) {
        let stars = 2*i - 1
        let spaces = m - i
        for (_ in 0..spaces) { sb.append(" ") }
        for (_ in 0..stars) { sb.append(sym) }
        sb.append("\n")
    }
    sb.append("${remain}")
    println(sb.toString())
}
