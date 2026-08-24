// L1-067 洛希极限 - 固定2位
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
    if (tokens.size < 3) { return }
    let ratio = Float64.parse(tokens[0])
    let typ = Int64.parse(tokens[1])
    let dist = Float64.parse(tokens[2])
    let factor: Float64 = if (typ == 0) { 2.455 } else { 1.26 }
    let limit = ratio * factor
    let s = format2(limit)
    let mark = if (limit > dist) { "T_T" } else { "^_^" }
    println("${s} ${mark}")
}
