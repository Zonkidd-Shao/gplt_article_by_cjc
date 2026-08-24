// L2-018 多项式A除以B - 多项式除法，1位小数
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*
import std.sort.*

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
    let nA = Int64.parse(next())
    let mapA = HashMap<Int64, Float64>()
    var maxA: Int64 = -1
    for (_ in 0..nA) {
        let e = Int64.parse(next())
        let c = Float64.parse(next())
        mapA[e] = c
        if (e > maxA) { maxA = e }
    }
    let nB = Int64.parse(next())
    let mapB = HashMap<Int64, Float64>()
    var maxB: Int64 = -1
    for (_ in 0..nB) {
        let e = Int64.parse(next())
        let c = Float64.parse(next())
        mapB[e] = c
        if (e > maxB) { maxB = e }
    }
    let coeffBmax = mapB.get(maxB) ?? 0.0
    let mapQ = HashMap<Int64, Float64>()
    let rem = HashMap<Int64, Float64>()
    for ((k,v) in mapA) { rem[k] = v }
    func currentMax(m: HashMap<Int64,Float64>): Int64 {
        var mx: Int64 = -1
        var found = false
        for ((k,v) in m) {
            if (abs(v) < 1e-9) { continue }
            if (!found || k > mx) { mx = k; found = true }
        }
        return if (found) { mx } else { -1 }
    }
    var curMax = currentMax(rem)
    while (curMax >= maxB && curMax != -1) {
        let coeffRem = rem.get(curMax) ?? 0.0
        if (abs(coeffRem) < 1e-9) {
            rem.remove(curMax)
            curMax = currentMax(rem)
            continue
        }
        let qCoeff = coeffRem / coeffBmax
        let qExp = curMax - maxB
        let prev = mapQ.get(qExp) ?? 0.0
        mapQ[qExp] = prev + qCoeff
        for ((eb, cb) in mapB) {
            let e = eb + qExp
            let cur = rem.get(e) ?? 0.0
            let nv = cur - qCoeff * cb
            if (abs(nv) < 1e-9) { rem.remove(e) } else { rem[e] = nv }
        }
        if (rem.contains(curMax)) {
            let v = rem.get(curMax) ?? 0.0
            if (abs(v) < 1e-9) { rem.remove(curMax) }
        }
        curMax = currentMax(rem)
    }
    printPoly(mapQ)
    printPoly(rem)
}

func printPoly(m: HashMap<Int64, Float64>): Unit {
    let list = ArrayList<(Int64, String)>()
    for ((e,c) in m) {
        let r = round1(c)
        if (r == 0) { continue }
        let s = format1FromRounded(r)
        list.add((e, s))
    }
    if (list.size == 0) {
        println("0 0 0.0")
        return
    }
    sort(list, by: { a,b => if (a[0] > b[0]) {Ordering.LT} else if (a[0] < b[0]) {Ordering.GT} else {Ordering.EQ} })
    let sb = StringBuilder()
    sb.append("${list.size}")
    for (i in 0..list.size) {
        sb.append(" ${list[i][0]} ${list[i][1]}")
    }
    println(sb.toString())
}

func round1(x: Float64): Int64 {
    let v = x * 10.0
    return if (v >= 0.0) { Int64(floor(v + 0.5)) } else { Int64(ceil(v - 0.5)) }
}

func format1FromRounded(r: Int64): String {
    if (r == 0) { return "0.0" }
    let neg = r < 0
    let ar = if (neg) { -r } else { r }
    let ip = ar / 10
    let fp = ar % 10
    let s = "${ip}.${fp}"
    return if (neg) { "-${s}" } else { s }
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { res.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
