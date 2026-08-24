// L1-069 胎压监测
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
    if (vals.size < 6) { return }
    let minP = vals[4]
    let th = vals[5]
    var mx: Int64 = vals[0]
    for (i in 1..4) { if (vals[i] > mx) { mx = vals[i] } }
    var warns = ArrayList<Int64>()
    for (i in 0..4) {
        let p = vals[i]
        if (p < minP || mx - p > th) { warns.add(i+1) }
    }
    if (warns.size == 0) {
        println("Normal")
    } else if (warns.size == 1) {
        println("Warning: please check #${warns[0]}!")
    } else {
        println("Warning: please check all the tires!")
    }
}
