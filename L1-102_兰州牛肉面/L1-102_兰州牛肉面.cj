/* L1-102 兰州牛肉面 - approach: count per type and total cents */
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    var allLines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        allLines.add(line)
    }
    if (allLines.size == 0) { return }
    let n = Int64.parse(allLines[0].trimAscii())
    var priceStrs = ArrayList<String>()
    var idx: Int64 = 1
    // collect price tokens until we have n
    while (priceStrs.size < n && idx < Int64(allLines.size)) {
        let parts = allLines[Int64(idx)].split(" ")
        for (p in parts) {
            let t = p.trimAscii()
            if (t.size != 0) {
                priceStrs.add(t)
            }
        }
        idx += 1
    }
    var priceCents = Array<Int64>(Int64(n), repeat: 0)
    for (i in 0..n) {
        let s = priceStrs[Int64(i)]
        // parse price like "4.00"
        var cents: Int64 = 0
        let dotParts = s.split(".")
        if (dotParts.size == 1) {
            cents = Int64.parse(dotParts[0]) * 100
        } else {
            let intPart = Int64.parse(dotParts[0])
            var frac = dotParts[1]
            // pad or trim to 2 digits
            if (frac.size == 0) {
                frac = "00"
            } else if (frac.size == 1) {
                frac = frac + "0"
            } else if (frac.size > 2) {
                frac = frac[0..2]
            }
            let fracVal = Int64.parse(frac)
            cents = intPart * 100 + fracVal
        }
        priceCents[Int64(i)] = cents
    }
    var counts = Array<Int64>(Int64(n), repeat: 0)
    // remaining lines from idx onward are records
    while (idx < Int64(allLines.size)) {
        let line = allLines[Int64(idx)]
        idx += 1
        if (line.trimAscii().size == 0) { continue }
        let parts = line.split(" ")
        var nums = ArrayList<String>()
        for (p in parts) {
            let t = p.trimAscii()
            if (t.size != 0) { nums.add(t) }
        }
        if (nums.size < 2) { continue }
        let t = Int64.parse(nums[0])
        let b = Int64.parse(nums[1])
        if (t == 0) { break }
        if (t >= 1 && t <= n) {
            counts[Int64(t - 1)] += b
        }
    }
    let sb = StringBuilder()
    var totalCents: Int64 = 0
    for (i in 0..n) {
        println(counts[Int64(i)])
        totalCents += priceCents[Int64(i)] * counts[Int64(i)]
    }
    let dollars = totalCents / 100
    let cents = totalCents % 100
    let centsStr = cents.toString().padStart(2, padding: '0')
    println("${dollars}.${centsStr}")
}
