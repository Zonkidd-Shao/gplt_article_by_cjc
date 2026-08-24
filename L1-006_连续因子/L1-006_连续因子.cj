// L1-006 连续因子
// approach: brute force longest consecutive product dividing N
import std.env.*
import std.convert.*
import std.math.*
import std.collection.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let t = all.trimAscii()
    if (t.isEmpty()) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { tokens.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var bestLen: Int64 = 0
    var bestStart: Int64 = 0
    let sq = Int64(sqrt(Float64(n))) + 1
    var start: Int64 = 2
    while (start <= sq) {
        var prod: Int64 = 1
        var end = start
        while (true) {
            if (prod > n / end) { break }
            prod *= end
            if (n % prod != 0) { break }
            let len = end - start + 1
            if (len > bestLen) {
                bestLen = len
                bestStart = start
            }
            end += 1
            if (end > n) { break }
            if (prod > n) { break }
        }
        start += 1
    }
    if (bestLen == 0) {
        println(1)
        println(n)
    } else {
        println(bestLen)
        var sb = StringBuilder()
        for (k in 0..bestLen) {
            if (k > 0) { sb.append("*") }
            sb.append("${bestStart + k}")
        }
        println(sb.toString())
    }
}
