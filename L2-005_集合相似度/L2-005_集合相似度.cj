// L2-005 集合相似度
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
    var pos: Int64 = 0
    if (pos >= tokens.size) { return }
    let n = Int64.parse(tokens[pos]); pos+=1
    var sets = ArrayList<HashSet<Int64>>()
    for (_ in 0..n) {
        if (pos >= tokens.size) { break }
        let m = Int64.parse(tokens[pos]); pos+=1
        var hs = HashSet<Int64>()
        for (_ in 0..m) {
            if (pos >= tokens.size) { break }
            hs.add(Int64.parse(tokens[pos])); pos+=1
        }
        sets.add(hs)
    }
    if (pos >= tokens.size) { return }
    let k = Int64.parse(tokens[pos]); pos+=1
    for (_ in 0..k) {
        if (pos+1 >= tokens.size) { break }
        let a = Int64.parse(tokens[pos])-1; let b = Int64.parse(tokens[pos+1])-1; pos+=2
        if (a < 0 || a >= sets.size || b < 0 || b >= sets.size) { println("0.00%"); continue }
        let setA = sets[a]
        let setB = sets[b]
        var common: Int64 = 0
        if (setA.size < setB.size) {
            for (elem in setA) { if (setB.contains(elem)) { common+=1 } }
        } else {
            for (elem in setB) { if (setA.contains(elem)) { common+=1 } }
        }
        let total = setA.size + setB.size - common
        var sim: Float64 = 0.0
        if (total != 0) {
            let cf = Float64.parse("${common}")
            let tf = Float64.parse("${total}")
            sim = cf / tf * 100.0
        }
        let cents = Int64(sim*100.0 + 0.5 + 0.000001)
        let ip = cents / 100
        let fp = cents % 100
        var fpStr = "${fp}"
        if (fp < 10) { fpStr = "0${fp}" }
        println("${ip}.${fpStr}%")
    }
}
