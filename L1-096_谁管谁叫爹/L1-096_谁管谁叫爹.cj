// L1-096 谁管谁叫爹 - 按数字和倍数判定
import std.env.*
import std.collection.*
import std.convert.*

func digitSum(s: String): Int64 {
    var sum: Int64 = 0
    let arr = s.toRuneArray()
    for (r in arr) {
        sum += Int64.parse("${r}")
    }
    return sum
}

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
    while (i < n && idx + 1 < Int64(tokens.size)) {
        let aStr = tokens[idx]
        let bStr = tokens[idx+1]
        idx += 2
        i++
        let na = Int64.parse(aStr)
        let nb = Int64.parse(bStr)
        let sa = digitSum(aStr)
        let sb2 = digitSum(bStr)
        let aWin = (na % sb2 == 0)
        let bWin = (nb % sa == 0)
        if (aWin && !bWin) {
            println("A")
        } else if (!aWin && bWin) {
            println("B")
        } else {
            if (na > nb) {
                println("A")
            } else {
                println("B")
            }
        }
    }
}
