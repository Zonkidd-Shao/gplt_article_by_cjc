// L1-025 正整数A+B - validate A and B by first space split
import std.env.*
import std.convert.*
func isValid(s: String): Bool {
    if (s.size == 0) { return false }
    for (c in s.toRuneArray()) {
        if (c < r'0' || c > r'9') { return false }
    }
    let v = Int64.parse(s)
    if (v < 1 || v > 1000) { return false }
    return true
}
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var line = ""
    for (c in all.toRuneArray()) {
        if (c == r'\n' || c == r'\r') { break }
        line += c.toString()
    }
    let runes = line.toRuneArray()
    var pos: Int64 = -1
    var i: Int64 = 0
    while (i < runes.size) {
        if (runes[i] == r' ') { pos = i; break }
        i += 1
    }
    var aStr = ""
    var bStr = ""
    if (pos == -1) {
        aStr = line
        bStr = ""
    } else {
        var j: Int64 = 0
        while (j < pos) { aStr += runes[j].toString(); j += 1 }
        j = pos + 1
        while (j < runes.size) { bStr += runes[j].toString(); j += 1 }
    }
    let aOk = isValid(aStr)
    let bOk = isValid(bStr)
    var outA: String = "?"
    var outB: String = "?"
    var outSum: String = "?"
    if (aOk) { outA = aStr }
    if (bOk) { outB = bStr }
    if (aOk && bOk) {
        let av = Int64.parse(aStr)
        let bv = Int64.parse(bStr)
        outSum = "${av + bv}"
    }
    println("${outA} + ${outB} = ${outSum}")
}
