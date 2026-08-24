// L1-079 天梯赛的善良 - 找最小/最大值及个数
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let cleaned = all.replace("\r", " ").replace("\n", " ").replace("\t", " ")
    var raw = cleaned.split(" ")
    var tokens = ArrayList<String>()
    for (p in raw) { if (p.trimAscii().size > 0) { tokens.add(p.trimAscii()) } }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    if (n == 0) { return }
    var vals = ArrayList<Int64>()
    var i: Int64 = 1
    while (i < Int64(tokens.size) && Int64(vals.size) < n) {
        vals.add(Int64.parse(tokens[i]))
        i++
    }
    if (vals.size == 0) { return }
    var mn = vals[0]
    var mx = vals[0]
    for (v in vals) {
        if (v < mn) { mn = v }
        if (v > mx) { mx = v }
    }
    var cntMin: Int64 = 0
    var cntMax: Int64 = 0
    for (v in vals) {
        if (v == mn) { cntMin++ }
        if (v == mx) { cntMax++ }
    }
    println("${mn} ${cntMin}")
    println("${mx} ${cntMax}")
}
