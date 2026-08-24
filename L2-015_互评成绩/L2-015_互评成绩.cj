 // L2-015 互评成绩 - 去掉最高最低求平均，取前M按非递减输出
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*
import std.sort.*

func format3(x: Float64): String {
    let neg = x < 0.0
    let ax = if (neg) { -x } else { x }
    let c = Int64(round(ax * 1000.0))
    let intPart = c / 1000
    let frac = c % 1000
    let fracStr = frac.toString().padStart(3, padding: '0')
    let s = "${intPart}.${fracStr}"
    return if (neg && c != 0) { "-${s}" } else { s }
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var idx: Int64 = 0
    func next(): String {
        let v = toks[idx]
        idx++
        return v
    }
    let N = Int64.parse(next())
    let K = Int64.parse(next())
    let M = Int64.parse(next())
    var avgs = ArrayList<Float64>()
    for (_ in 0..N) {
        var arr = ArrayList<Int64>()
        for (_2 in 0..K) {
            arr.add(Int64.parse(next()))
        }
        sort(arr)
        var sum: Int64 = 0
        for (i in 1..K-1) {
            if (i >= K-1) { break }
            // i goes 1..K-2 inclusive
            if (i <= K-2) {
                sum += arr[i]
            }
        }
        let avg = Float64(sum) / Float64(K - 2)
        avgs.add(avg)
    }
    sort(avgs)
    let total: Int64 = avgs.size
    let start: Int64 = total - M
    let sb = StringBuilder()
    for (i in start..total) {
        if (i > start) { sb.append(" ") }
        sb.append(format3(avgs[i]))
    }
    println(sb.toString())
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) {
                res.add(cur.toString())
                cur = StringBuilder()
            }
        } else {
            cur.append(rs)
        }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
