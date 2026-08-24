// L1-116 普及赛排名 - count <1700
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let sp: Rune = ' '
    let nl: Rune = '\n'
    let cr: Rune = '\r'
    let tab: Rune = '\t'
    var tokens = ArrayList<String>()
    var sb = StringBuilder()
    var inTok = false
    for (ch in all.toRuneArray()) {
        let isSpace = (ch == sp) || (ch == nl) || (ch == cr) || (ch == tab)
        if (isSpace) {
            if (inTok) {
                tokens.add(sb.toString())
                sb = StringBuilder()
                inTok = false
            }
        } else {
            sb.append(ch)
            inTok = true
        }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var cnt: Int64 = 0
    var idx: Int64 = 1
    while (idx <= n && idx < tokens.size) {
        let v = Int64.parse(tokens[idx])
        if (v < 1700) { cnt += 1 }
        idx += 1
    }
    println(cnt)
}
