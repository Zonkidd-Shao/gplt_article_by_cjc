// L1-077 大笨钟的心情
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let all = (getStdIn().readToEnd() ?? "")
    var vals = ArrayList<Int64>()
    var cur = StringBuilder()
    var has = false
    var neg = false
    let ra = all.toRuneArray()
    for (i in 0..Int64(ra.size)) {
        let c = ra[i]
        if (c == r'-') { neg = true }
        else if (c >= r'0' && c <= r'9') { cur.append("${c}"); has = true }
        else {
            if (has) {
                var v = Int64.parse(cur.toString())
                if (neg) { v = -v }
                vals.add(v)
                cur = StringBuilder(); has = false; neg = false
            } else { neg = false }
        }
    }
    if (has) {
        var v = Int64.parse(cur.toString())
        if (neg) { v = -v }
        vals.add(v)
    }
    if (vals.size < 24) { return }
    var moods = Array<Int64>(24, repeat: 0)
    for (i in 0..24) { moods[i] = vals[i] }
    for (i in 24..Int64(vals.size)) {
        let t = vals[i]
        if (t < 0 || t >= 24) { break }
        let mv = moods[t]
        let ans = if (mv > 50) { "Yes" } else { "No" }
        println("${mv} ${ans}")
    }
}
