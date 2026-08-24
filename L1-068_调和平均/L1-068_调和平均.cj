// L1-068 调和平均 - 保留2位
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

func format2(x: Float64): String {
    let scaled = Int64(round(x * 100.0))
    let neg = scaled < 0
    let a: Int64 = if (neg) { -scaled } else { scaled }
    let intPart = a / 100
    let frac = a % 100
    let sign = if (neg) { "-" } else { "" }
    let fracStr = if (frac < 10) { "0${frac}" } else { "${frac}" }
    return "${sign}${intPart}.${fracStr}"
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
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var sum: Float64 = 0.0
    for (i in 1..n+1) {
        if (i >= Int64(tokens.size)) { break }
        let v = Float64.parse(tokens[i])
        sum += 1.0 / v
    }
    let hm = Float64(n) / sum
    println(format2(hm))
}
