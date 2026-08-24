// L1-060 心理阴影面积 - 50*(x-y)
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
        if (c == r'-') {
            // handle negative sign if next is digit
            // peek next?
            neg = true
        } else if (c >= r'0' && c <= r'9') {
            cur.append("${c}")
            has = true
        } else {
            if (has) {
                var v = Int64.parse(cur.toString())
                if (neg) { v = -v }
                vals.add(v)
                cur = StringBuilder()
                has = false
                neg = false
            } else {
                neg = false
            }
        }
    }
    if (has) {
        var v = Int64.parse(cur.toString())
        if (neg) { v = -v }
        vals.add(v)
    }
    if (vals.size < 2) { return }
    let x = vals[0]
    let y = vals[1]
    let ans = 50 * (x - y)
    println(ans)
}
