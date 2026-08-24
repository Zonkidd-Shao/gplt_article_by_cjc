// L1-009 N个数求和
// approach: fraction sum with gcd reduction
import std.env.*
import std.collection.*
import std.convert.*

func gcd(a: Int64, b: Int64): Int64 {
    var x: Int64 = if (a < 0) { -a } else { a }
    var y: Int64 = if (b < 0) { -b } else { b }
    while (y != 0) {
        let t = y
        y = x % y
        x = t
    }
    return x
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { tokens.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    let n = Int64.parse(tokens[0])
    var num: Int64 = 0
    var den: Int64 = 1
    for (i in 0..n) {
        let frac = tokens[1+i]
        var slashIdx: Int64 = -1
        let ra = frac.toRuneArray()
        for (k in 0..Int64(ra.size)) {
            if (ra[k].toString() == "/") { slashIdx = k; break }
        }
        var aStr = ""
        var bStr = ""
        if (slashIdx >= 0) {
            aStr = frac[0..slashIdx]
            bStr = frac[(slashIdx+1)..Int64(frac.size)]
        }
        let a = Int64.parse(aStr)
        let b = Int64.parse(bStr)
        let g = gcd(den, b)
        let lcm = den / g * b
        let newNum = num * (b / g) + a * (den / g)
        num = newNum
        den = lcm
        if (num != 0) {
            let gg = gcd(num, den)
            num /= gg
            den /= gg
        } else {
            den = 1
        }
        if (den < 0) { den = -den; num = -num }
    }
    if (num == 0) {
        println(0)
        return
    }
    let intPart = num / den
    let rem = num % den
    var absRem: Int64 = if (rem < 0) { -rem } else { rem }
    if (intPart != 0 && absRem != 0) {
        println("${intPart} ${absRem}/${den}")
    } else if (intPart != 0) {
        println(intPart)
    } else {
        if (num < 0) {
            println("-${absRem}/${den}")
        } else {
            println("${absRem}/${den}")
        }
    }
}
