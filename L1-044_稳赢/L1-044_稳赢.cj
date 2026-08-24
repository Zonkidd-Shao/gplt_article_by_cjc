// L1-044 稳赢 — 每隔K次平局否则赢招
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var rawLines = all.split("\n")
    var lines = ArrayList<String>()
    for (l in rawLines) {
        let t = l.trimAscii()
        // handle \r
        let nr = t.split("\r")
        var merged = ""
        var first = true
        for (x in nr) {
            if (first) { merged = x; first = false } else { merged = merged + x }
        }
        let tt = merged.trimAscii()
        if (!tt.isEmpty()) { lines.add(tt) }
    }
    if (lines.size == 0) { return }
    let k = Int64.parse(lines[0])
    var cnt: Int64 = 0
    let sb = StringBuilder()
    var i: Int64 = 1
    while (i < lines.size) {
        let op = lines[i]
        if (op == "End") { break }
        cnt += 1
        if (cnt % (k + 1) == 0) {
            sb.append("${op}\n")
        } else {
            if (op == "ChuiZi") { sb.append("Bu\n") }
            else if (op == "JianDao") { sb.append("ChuiZi\n") }
            else if (op == "Bu") { sb.append("JianDao\n") }
            else { sb.append("${op}\n") }
        }
        i += 1
    }
    print(sb.toString())
}
