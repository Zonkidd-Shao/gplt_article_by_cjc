/* L1-103 整数的持续性 - approach: brute persistence for interval */
import std.env.*
import std.collection.*
import std.convert.*
func digitProduct(n: Int64): Int64 {
    if (n < 10) {
        return n
    }
    var product: Int64 = 1
    var num: Int64 = n
    while (num > 0) {
        let d: Int64 = num % 10
        if (d == 0) {
            return 0
        }
        product *= d
        num /= 10
    }
    return product
}
func persistence(n: Int64): Int64 {
    if (n < 10) {
        return 0
    }
    var cnt: Int64 = 0
    var cur: Int64 = n
    while (cur >= 10) {
        cur = digitProduct(cur)
        cnt += 1
    }
    return cnt
}
main() {
    let cin = getStdIn()
    var tokens = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        let parts = line.split(" ")
        for (p in parts) {
            let t = p.trimAscii()
            if (t.size != 0) { tokens.add(t) }
        }
    }
    if (tokens.size < 2) { return }
    let a = Int64.parse(tokens[0])
    let b = Int64.parse(tokens[1])
    var maxP: Int64 = -1
    var res = ArrayList<Int64>()
    var num = a
    while (num <= b) {
        let p = persistence(num)
        if (p > maxP) {
            maxP = p
            res.clear()
            res.add(num)
        } else if (p == maxP) {
            res.add(num)
        }
        num += 1
    }
    println(maxP)
    let sb = StringBuilder()
    for (i in 0..Int64(res.size)) {
        if (i > 0) { sb.append(" ") }
        sb.append(res[Int64(i)].toString())
    }
    println(sb.toString())
}
