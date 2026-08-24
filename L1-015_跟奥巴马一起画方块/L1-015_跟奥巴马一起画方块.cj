// L1-015 跟奥巴马一起画方块
// approach: rows = round(N/2) = (N+1)/2
import std.env.*
import std.convert.*
import std.collection.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { tokens.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    let n = Int64.parse(tokens[0])
    let ch = tokens[1]
    let c = ch[0..1]
    let rows = (n + 1) / 2
    var line = StringBuilder()
    for (_ in 0..n) { line.append(c) }
    let ls = line.toString()
    for (_ in 0..rows) { println(ls) }
}
