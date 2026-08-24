// L1-093 猜帽子游戏 - 无猜错且至少一猜对则大奖
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
    var colors = Array<Int64>(n, repeat: 0)
    var idx: Int64 = 1
    for (i in 0..n) {
        if (idx < Int64(tokens.size)) {
            colors[i] = Int64.parse(tokens[idx])
            idx++
        }
    }
    if (idx >= Int64(tokens.size)) { return }
    let k = Int64.parse(tokens[idx])
    idx++
    for (_ in 0..k) {
        var hasWrong = false
        var hasCorrect = false
        for (j in 0..n) {
            if (idx >= Int64(tokens.size)) { break }
            let g = Int64.parse(tokens[idx])
            idx++
            if (g != 0) {
                if (g == colors[j]) { hasCorrect = true } else { hasWrong = true }
            }
        }
        if (!hasWrong && hasCorrect) {
            println("Da Jiang!!!")
        } else {
            println("Ai Ya")
        }
    }
}
