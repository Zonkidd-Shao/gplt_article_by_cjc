// L1-119 网络流量监测 - max min avg floor, 2*avg attacks
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
            if (inTok) { tokens.add(sb.toString()); sb=StringBuilder(); inTok=false }
        } else { sb.append(ch); inTok=true }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var vals = ArrayList<Int64>()
    for (i in 1..(n+1)) {
        if (i >= tokens.size) { break }
        vals.add(Int64.parse(tokens[i]))
    }
    if (vals.size == 0) { return }
    var mx = vals[0]
    var mn = vals[0]
    var sum: Int64 = 0
    for (v in vals) {
        if (v > mx) { mx = v }
        if (v < mn) { mn = v }
        sum += v
    }
    let avg = sum / n
    println("${mx} ${mn} ${avg}")
    let thr = avg * 2
    var attacks = ArrayList<Int64>()
    for (i in 0..vals.size) {
        if (vals[i] > thr) { attacks.add(i+1) }
    }
    if (attacks.size == 0) {
        println("Normal")
    } else {
        var out = StringBuilder()
        for (i in 0..attacks.size) {
            if (i != 0) { out.append(" ") }
            out.append(attacks[i])
        }
        println(out.toString())
    }
}
