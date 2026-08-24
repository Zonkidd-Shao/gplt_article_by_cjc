// L1-018 大笨钟
// approach: hh:mm, count Dangs after 12:00
import std.env.*
import std.convert.*
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
    let token = tokens[0]
    var slashIdx: Int64 = -1
    let ra = token.toRuneArray()
    for (k in 0..Int64(ra.size)) {
        if (ra[k].toString() == ":") { slashIdx = k; break }
    }
    var hh: Int64 = 0
    var mm: Int64 = 0
    if (slashIdx >= 0) {
        let hStr = token[0..slashIdx]
        let mStr = token[(slashIdx+1)..Int64(token.size)]
        hh = Int64.parse(hStr)
        mm = Int64.parse(mStr)
    }
    if (hh < 12 || (hh == 12 && mm == 0)) {
        println("Only ${token}.  Too early to Dang.")
    } else {
        var cnt = hh - 12
        if (mm > 0) { cnt += 1 }
        var sb = StringBuilder()
        for (_ in 0..cnt) { sb.append("Dang") }
        println(sb.toString())
    }
}
