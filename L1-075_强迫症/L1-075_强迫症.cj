// L1-075 强迫症
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
    if (tokens.size == 0) { return }
    let s = tokens[0].trimAscii()
    if (s.size == 4) {
        let a = s.toRuneArray()
        var y2sb = StringBuilder()
        y2sb.append("${a[0]}${a[1]}")
        var mmsb = StringBuilder()
        mmsb.append("${a[2]}${a[3]}")
        let y2 = y2sb.toString()
        let mm = mmsb.toString()
        let yv = Int64.parse(y2)
        let prefix = if (yv < 22) { "20" } else { "19" }
        println("${prefix}${y2}-${mm}")
    } else if (s.size == 6) {
        let a = s.toRuneArray()
        var ysb = StringBuilder()
        ysb.append("${a[0]}${a[1]}${a[2]}${a[3]}")
        var mmsb = StringBuilder()
        mmsb.append("${a[4]}${a[5]}")
        println("${ysb.toString()}-${mmsb.toString()}")
    } else {
        let a = s.toRuneArray()
        let n = Int64(a.size)
        var ysb = StringBuilder()
        for (i in 0..n-2) { ysb.append("${a[i]}") }
        var msb = StringBuilder()
        msb.append("${a[n-2]}${a[n-1]}")
        let yearPart = ysb.toString()
        let mm = msb.toString()
        if (yearPart.size == 2) {
            let yv = Int64.parse(yearPart)
            let prefix = if (yv < 22) { "20" } else { "19" }
            println("${prefix}${yearPart}-${mm}")
        } else {
            println("${yearPart}-${mm}")
        }
    }
}
