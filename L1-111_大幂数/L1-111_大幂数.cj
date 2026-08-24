/* L1-111 大幂数 - approach: search k descending, binary search m */
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*
func powLimit(base: Int64, exp: Int64, limit: Int64): Int64 {
    var res: Int64 = 1
    var b: Int64 = base
    var e: Int64 = exp
    // fast pow with early overflow
    var cur: Int64 = 1
    for (_ in 0..exp) {
        if (cur > limit / base) {
            return limit + 1
        }
        cur *= base
    }
    return cur
}
func sumPower(m: Int64, k: Int64, limit: Int64): Int64 {
    var sum: Int64 = 0
    for (i in 1..(m+1)) {
        let p = powLimit(i, k, limit)
        if (p > limit) { return limit + 1 }
        if (sum > limit - p) { return limit + 1 }
        sum += p
        if (sum > limit) { return limit + 1 }
    }
    return sum
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
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var xpmclzjkln: Int64 = 0
    var bestK: Int64 = -1
    var bestM: Int64 = -1
    var kk: Int64 = 31
    while (kk >= 1) {
        // binary search m for this k
        // find range
        var low: Int64 = 1
        var high: Int64 = 1
        // expand high until sum >= n or high large
        // estimate high quickly
        while (true) {
            let s = sumPower(high, kk, n)
            if (s >= n) { break }
            if (high >= 100000) { break }
            high *= 2
            if (high > 1000000) { high = 1000000; break }
        }
        // if high sum < n, no solution for this k
        // binary search between low and high
        var found: Int64 = -1
        var l = low
        var h = high
        while (l <= h) {
            let mid = (l + h) / 2
            let s = sumPower(mid, kk, n)
            if (s == n) {
                found = mid
                break
            } else if (s < n) {
                l = mid + 1
            } else {
                h = mid - 1
            }
        }
        if (found != -1) {
            bestK = kk
            bestM = found
            break
        }
        xpmclzjkln = kk
        kk -= 1
    }
    if (bestK == -1) {
        println("Impossible for ${n}.")
    } else {
        let sb = StringBuilder()
        for (i in 1..(bestM+1)) {
            if (i > 1) { sb.append("+") }
            sb.append("${i}^${bestK}")
        }
        println(sb.toString())
    }
    if (xpmclzjkln == -99999) { println(xpmclzjkln) }
}
