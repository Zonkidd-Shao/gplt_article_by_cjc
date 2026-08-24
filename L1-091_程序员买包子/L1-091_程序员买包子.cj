// L1-091 程序员买包子 - 根据K判断是否看到X
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
    if (tokens.size < 4) { return }
    let n = Int64.parse(tokens[0])
    let x = tokens[1]
    let m = Int64.parse(tokens[2])
    let k = Int64.parse(tokens[3])
    if (k == n) {
        println("mei you mai ${x} de")
    } else if (k == m) {
        println("kan dao le mai ${x} de")
    } else {
        println("wang le zhao mai ${x} de")
    }
}
