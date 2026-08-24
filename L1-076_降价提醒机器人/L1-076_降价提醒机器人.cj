// L1-076 降价提醒机器人
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

func format1(x: Float64): String {
    let scaled = Int64(round(x * 10.0))
    let neg = scaled < 0
    let a: Int64 = if (neg) { -scaled } else { scaled }
    let intPart = a / 10
    let frac = a % 10
    let sign = if (neg) { "-" } else { "" }
    return "${sign}${intPart}.${frac}"
}

main() {
    let all = (getStdIn().readToEnd() ?? "")
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
    if (tokens.size < 2) { return }
    let n = Int64.parse(tokens[0])
    let m = Float64.parse(tokens[1])
    for (i in 0..n) {
        let idx = 2 + i
        if (idx >= Int64(tokens.size)) { break }
        let p = Float64.parse(tokens[idx])
        if (p < m) {
            println("On Sale! ${format1(p)}")
        }
    }
}
