// L1-071 前世档案 - y=0 n=1 二进制+1
import std.env.*
import std.collection.*
import std.convert.*

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
    let m = Int64.parse(tokens[1])
    for (i in 0..m) {
        let idx = 2 + i
        if (idx >= Int64(tokens.size)) { break }
        let s = tokens[idx]
        var val: Int64 = 0
        let sa = s.toRuneArray()
        for (j in 0..n) {
            if (j >= Int64(sa.size)) { break }
            let c = sa[j]
            let bit: Int64 = if (c == r'n') { 1 } else { 0 }
            val = val * 2 + bit
        }
        println(val + 1)
    }
}
