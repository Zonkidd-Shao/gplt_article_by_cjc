// L1-023 输出GPLT - count G/P/L/T case-insensitive and interleave
import std.env.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var line = ""
    for (c in all.toRuneArray()) {
        if (c == r'\n' || c == r'\r') { break }
        line += c.toString()
    }
    var s = line
    if (s.size == 0) { s = all.trimAscii() }
    s = s.trimAscii()
    var cntG: Int64 = 0
    var cntP: Int64 = 0
    var cntL: Int64 = 0
    var cntT: Int64 = 0
    for (c in s.toRuneArray()) {
        if (c == r'g' || c == r'G') { cntG += 1 }
        else if (c == r'p' || c == r'P') { cntP += 1 }
        else if (c == r'l' || c == r'L') { cntL += 1 }
        else if (c == r't' || c == r'T') { cntT += 1 }
    }
    var sb = StringBuilder()
    while (cntG > 0 || cntP > 0 || cntL > 0 || cntT > 0) {
        if (cntG > 0) { sb.append("G"); cntG -= 1 }
        if (cntP > 0) { sb.append("P"); cntP -= 1 }
        if (cntL > 0) { sb.append("L"); cntL -= 1 }
        if (cntT > 0) { sb.append("T"); cntT -= 1 }
    }
    println(sb.toString())
}
