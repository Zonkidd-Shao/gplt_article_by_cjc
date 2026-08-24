// L2-003 月饼 - greedy
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
    if (tokens.size < 2) { return }
    let n = Int64.parse(tokens[0])
    let d = Float64.parse(tokens[1])
    var stocks = ArrayList<Float64>()
    var prices = ArrayList<Float64>()
    for (i in 0..n) {
        let idx = 2 + i
        if (idx < tokens.size) { stocks.add(Float64.parse(tokens[idx])) } else { stocks.add(0.0) }
    }
    for (i in 0..n) {
        let idx = 2 + n + i
        if (idx < tokens.size) { prices.add(Float64.parse(tokens[idx])) } else { prices.add(0.0) }
    }
    var units = ArrayList<Float64>()
    for (i in 0..n) {
        let st = stocks[i]
        let pr = prices[i]
        if (st == 0.0) { units.add(0.0) } else { units.add(pr / st) }
    }
    // sort indices by units descending
    var idxs = ArrayList<Int64>()
    for (i in 0..n) { idxs.add(i) }
    for (i in 0..n) {
        for (j in (i+1)..n) {
            if (units[idxs[i]] < units[idxs[j]]) {
                let tmp = idxs[i]
                idxs[i] = idxs[j]
                idxs[j] = tmp
            }
        }
    }
    var remaining = d
    var total: Float64 = 0.0
    for (k in 0..n) {
        if (remaining <= 0.0) { break }
        let id = idxs[k]
        let st = stocks[id]
        let pr = prices[id]
        if (st <= remaining) {
            total += pr
            remaining -= st
        } else {
            total += pr / st * remaining
            remaining = 0.0
        }
    }
    // format to 2 decimals
    // rounding: cents = Int64(total*100 + 0.5 + 1e-9)
    let scaled = total * 100.0
    // add small epsilon to handle floating error like 94.4999999
    let cents = Int64(scaled + 0.5 + 0.000001)
    let intPart = cents / 100
    let frac = cents % 100
    var fracStr = "${frac}"
    if (frac < 10) { fracStr = "0${frac}" }
    // handle negative? not needed (prices positive)
    println("${intPart}.${fracStr}")
}
