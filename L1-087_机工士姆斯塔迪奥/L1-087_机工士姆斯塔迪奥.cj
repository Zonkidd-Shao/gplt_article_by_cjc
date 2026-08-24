// L1-087 机工士姆斯塔迪奥 - 统计安全格子
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
    let n = Int64.parse(tokens[0])
    let m = Int64.parse(tokens[1])
    let q = Int64.parse(tokens[2])
    var rows = HashSet<Int64>()
    var cols = HashSet<Int64>()
    var idx: Int64 = 3
    var c: Int64 = 0
    while (c < q && idx + 1 < Int64(tokens.size)) {
        let t = Int64.parse(tokens[idx])
        let v = Int64.parse(tokens[idx+1])
        if (t == 0) { rows.add(v) } else { cols.add(v) }
        idx += 2
        c++
    }
    let safeRows = n - Int64(rows.size)
    let safeCols = m - Int64(cols.size)
    let ans = safeRows * safeCols
    println(ans)
}
