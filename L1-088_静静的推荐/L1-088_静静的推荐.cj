// L1-088 静静的推荐 - PAT达标全部推荐，普通每分数最多K人
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
    if (tokens.size < 3) { return }
    let k = Int64.parse(tokens[1])
    let s = Int64.parse(tokens[2])
    let n = Int64.parse(tokens[0])
    var cntPat: Int64 = 0
    var ord = HashMap<Int64, Int64>()
    var idx: Int64 = 3
    var i: Int64 = 0
    while (i < n && idx + 1 < Int64(tokens.size)) {
        let g = Int64.parse(tokens[idx])
        let p = Int64.parse(tokens[idx+1])
        idx += 2
        i++
        if (g < 175) { continue }
        if (p >= s) {
            cntPat++
        } else {
            let cur: Int64 = ord.get(g) ?? 0
            ord[g] = cur + 1
        }
    }
    var ans = cntPat
    for ((_, c) in ord) {
        if (c < k) { ans += c } else { ans += k }
    }
    println(ans)
}
