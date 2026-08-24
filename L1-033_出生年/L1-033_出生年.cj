// L1-033 出生年 - find year with n distinct digits, 4-digit zero padded
import std.env.*
import std.convert.*
func distinctCount(y: Int64): Int64 {
    var seen = Array<Bool>(10, repeat: false)
    var v = y
    var digits = Array<Int64>(4, repeat: 0)
    digits[3] = v % 10; v /= 10
    digits[2] = v % 10; v /= 10
    digits[1] = v % 10; v /= 10
    digits[0] = v % 10
    var k: Int64 = 0
    while (k < 4) { seen[digits[k]] = true; k += 1 }
    var cnt: Int64 = 0
    var d: Int64 = 0
    while (d < 10) { if (seen[d]) { cnt += 1 }; d += 1 }
    return cnt
}
func pad4(y: Int64): String {
    var s = "${y}"
    while (s.size < 4) { s = "0" + s }
    return s
}
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var norm = ""
    for (c in all.toRuneArray()) {
        if (c == r'\n' || c == r'\r' || c == r'\t') { norm += " " } else { norm += c.toString() }
    }
    let parts = norm.split(" ")
    var toks = Array<String>(0, repeat: "")
    for (p in parts) {
        if (p.trimAscii().size > 0) {
            var tmp = Array<String>(toks.size + 1, repeat: "")
            var i: Int64 = 0
            while (i < toks.size) { tmp[i] = toks[i]; i += 1 }
            tmp[toks.size] = p.trimAscii()
            toks = tmp
        }
    }
    if (toks.size < 2) { return }
    let y = Int64.parse(toks[0])
    let n = Int64.parse(toks[1])
    var curY = y
    while (true) {
        if (distinctCount(curY) == n) { break }
        curY += 1
    }
    let age = curY - y
    println("${age} ${pad4(curY)}")
}
