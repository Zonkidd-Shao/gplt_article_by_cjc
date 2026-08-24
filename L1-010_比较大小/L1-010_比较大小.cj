// L1-010 比较大小
// approach: sort 3 numbers
import std.env.*
import std.collection.*
import std.convert.*

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
    var a = Int64.parse(tokens[0])
    var b = Int64.parse(tokens[1])
    var c = Int64.parse(tokens[2])
    if (a > b) { let t=a; a=b; b=t }
    if (a > c) { let t=a; a=c; c=t }
    if (b > c) { let t=b; b=c; c=t }
    println("${a}->${b}->${c}")
}
