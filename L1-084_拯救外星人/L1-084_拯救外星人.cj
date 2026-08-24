// L1-084 拯救外星人 - 计算 (A+B)!
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
    if (tokens.size < 2) { return }
    let a = Int64.parse(tokens[0])
    let b = Int64.parse(tokens[1])
    let s = a + b
    var res: Int64 = 1
    var i: Int64 = 2
    while (i <= s) {
        res = res * i
        i++
    }
    println(res)
}
