// L1-085 试试手气 - 每轮每骰选最大未出现点数
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
    if (tokens.size < 7) { return }
    var dice = Array<Int64>(6, repeat: 0)
    for (i in 0..6) { dice[i] = Int64.parse(tokens[i]) }
    let n = Int64.parse(tokens[6])
    var used = Array<Array<Bool>>(6, { _ => Array<Bool>(7, repeat: false) })
    for (i in 0..6) {
        let v = dice[i]
        used[i][v] = true
    }
    var round: Int64 = 0
    while (round < n) {
        for (i in 0..6) {
            var p: Int64 = 6
            while (p >= 1) {
                if (!used[i][p]) {
                    dice[i] = p
                    used[i][p] = true
                    break
                }
                p--
            }
        }
        round++
    }
    var out = StringBuilder()
    for (i in 0..6) {
        if (i > 0) { out.append(" ") }
        out.append(dice[i])
    }
    println(out.toString())
}
