// L1-092 进化论 - 判断 C 是 A*B 还是 A+B
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
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var idx: Int64 = 1
    var i: Int64 = 0
    while (i < n && idx + 2 < Int64(tokens.size)) {
        let a = Int64.parse(tokens[idx])
        let b = Int64.parse(tokens[idx+1])
        let c = Int64.parse(tokens[idx+2])
        idx += 3
        i++
        if (c == a * b) {
            println("Lv Yan")
        } else if (c == a + b) {
            println("Tu Dou")
        } else {
            println("zhe du shi sha ya!")
        }
    }
}
