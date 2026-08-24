// L1-063 吃鱼还是吃肉 - 身高体重评价
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let all = (getStdIn().readToEnd() ?? "")
    if (all.trimAscii().size == 0) { return }
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
    if (vals.size == 0) { return }
    let n = vals[0]
    var p: Int64 = 1
    for (_ in 0..n) {
        let gender = vals[p]
        let height = vals[p+1]
        let weight = vals[p+2]
        p += 3
        let stdH: Int64 = if (gender == 1) { 130 } else { 129 }
        let stdW: Int64 = if (gender == 1) { 27 } else { 25 }
        var hStr: String = if (height < stdH) { "duo chi yu!" } else if (height == stdH) { "wan mei!" } else { "ni li hai!" }
        var wStr: String = if (weight < stdW) { "duo chi rou!" } else if (weight == stdW) { "wan mei!" } else { "shao chi rou!" }
        println("${hStr} ${wStr}")
    }
}
