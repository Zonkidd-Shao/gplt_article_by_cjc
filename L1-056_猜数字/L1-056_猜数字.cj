// L1-056 猜数字 — 平均数一半的赢家
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var parts = all.split(" ")
    var toks = ArrayList<String>()
    for (p in parts) {
        let a = p.split("\n")
        for (q in a) {
            let b = q.split("\r")
            for (r in b) {
                let c = r.split("\t")
                for (t in c) {
                    let s = t.trimAscii()
                    if (!s.isEmpty()) { toks.add(s) }
                }
            }
        }
    }
    let n = Int64.parse(toks[0])
    var names = Array<String>(n, repeat: "")
    var nums = Array<Int64>(n, repeat: 0)
    var idx: Int64 = 1
    var sum: Int64 = 0
    var i: Int64 = 0
    while (i < n) {
        names[i] = toks[idx]
        nums[i] = Int64.parse(toks[idx+1])
        sum += nums[i]
        idx += 2
        i += 1
    }
    let target = sum / n / 2
    var best: Int64 = 0
    var bestDiff: Int64 = 999999
    i = 0
    while (i < n) {
        var diff = nums[i] - target
        if (diff < 0) { diff = -diff }
        if (diff < bestDiff) { bestDiff = diff; best = i }
        i += 1
    }
    println("${target} ${names[best]}")
}
