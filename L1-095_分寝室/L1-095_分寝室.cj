// L1-095 分寝室 - 枚举女生寝室数求差最小
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
    if (tokens.size < 3) { return }
    let n0 = Int64.parse(tokens[0])
    let n1 = Int64.parse(tokens[1])
    let n = Int64.parse(tokens[2])
    var bestF: Int64 = -1
    var bestM: Int64 = -1
    var minDiff: Int64 = 1000000000
    var f: Int64 = 1
    while (f < n) {
        let m = n - f
        if (n0 % f == 0 && n1 % m == 0) {
            let pf = n0 / f
            let pm = n1 / m
            if (pf >= 2 && pm >= 2) {
                var diff = pf - pm
                if (diff < 0) { diff = -diff }
                if (diff < minDiff) {
                    minDiff = diff
                    bestF = f
                    bestM = m
                }
            }
        }
        f++
    }
    if (bestF == -1) {
        println("No Solution")
    } else {
        println("${bestF} ${bestM}")
    }
}
