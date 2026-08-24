// L1-117 做什么都被骂怎么办 - find always scolded (only 0)
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
            if (inTok) { tokens.add(sb.toString()); sb = StringBuilder(); inTok = false }
        } else { sb.append(ch); inTok = true }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var idx: Int64 = 1
    let praised = HashSet<Int64>()
    let scolded = HashSet<Int64>()
    // also need set of all scolded ids
    for (i in 0..n) {
        if (idx + 1 >= tokens.size) { break }
        let id = Int64.parse(tokens[idx])
        let rec = Int64.parse(tokens[idx+1])
        if (rec == 0) { scolded.add(id) } else { praised.add(id) }
        idx += 2
    }
    var result = ArrayList<Int64>()
    for (id in scolded) {
        if (!praised.contains(id)) { result.add(id) }
    }
    if (result.size == 0) {
        println("NONE")
        return
    }
    result.sort()
    var out = StringBuilder()
    for (i in 0..result.size) {
        if (i != 0) { out.append(" ") }
        out.append(result[i])
    }
    println(out.toString())
}
