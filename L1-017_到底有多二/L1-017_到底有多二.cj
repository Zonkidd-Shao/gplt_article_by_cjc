// L1-017 到底有多二
import std.convert.*
// approach: integer arithmetic to two decimals
import std.env.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let s = all.trimAscii()
    if (s.isEmpty()) { return }
    var cnt2: Int64 = 0
    for (r in s.toRuneArray()) {
        if (r.toString() == "2") { cnt2 += 1 }
    }
    let isNeg = s.startsWith("-")
    var len: Int64 = Int64(s.size)
    if (isNeg) { len -= 1 }
    let runes = s.toRuneArray()
    let lastStr = runes[Int64(runes.size)-1].toString()
    let lastDigit = Int64.parse(lastStr)
    let isEven = (lastDigit % 2 == 0)
    var numer: Int64 = 1
    var denom: Int64 = 1
    if (isNeg) { numer *= 3; denom *= 2 }
    if (isEven) { numer *= 2 }
    let totalNum = cnt2 * 10000 * numer
    let totalDen = len * denom
    var scaled = totalNum / totalDen
    let rem = totalNum % totalDen
    if (rem * 2 >= totalDen) { scaled += 1 }
    let intPart = scaled / 100
    let frac = scaled % 100
    let fracStr = if (frac < 10) { "0${frac}" } else { "${frac}" }
    println("${intPart}.${fracStr}%")
}
