// L3-012 水果忍者 - stabbing vertical segments, find integer line
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let N = Int64.parse(next())
    var xs = ArrayList<Int64>()
    var lows = ArrayList<Int64>()
    var highs = ArrayList<Int64>()
    for (_ in 0..N) {
        let x = Int64.parse(next())
        let y1 = Int64.parse(next())
        let y2 = Int64.parse(next())
        var lo = y2; var hi = y1
        if (lo > hi) { let t=lo; lo=hi; hi=t }
        xs.add(x); lows.add(lo); highs.add(hi)
    }
    let mp = HashMap<Int64, Array<Int64>>()
    for (i in 0..N) {
        let x = xs[i]
        let lo = lows[i]
        let hi = highs[i]
        let opt = mp.get(x)
        if (let Some(arr) <- opt) {
            if (lo > arr[0]) { arr[0]=lo }
            if (hi < arr[1]) { arr[1]=hi }
        } else {
            let arr = Array<Int64>(2, repeat: 0)
            arr[0]=lo; arr[1]=hi
            mp[x]=arr
        }
    }
    var ux = ArrayList<Int64>()
    var ulo = ArrayList<Int64>()
    var uhi = ArrayList<Int64>()
    for ((k, v) in mp) {
        ux.add(k); ulo.add(v[0]); uhi.add(v[1])
    }
    let M = ux.size
    if (M == 1) {
        let x0 = ux[0]
        let y0 = ulo[0]
        println("${x0} ${y0} ${x0+1} ${y0}")
        return
    }
    var bestLow: Float64 = -1e100
    var bestHigh: Float64 = 1e100
    var bestLowP: Int64 = -1
    var bestLowQ: Int64 = -1
    var bestHighP: Int64 = -1
    var bestHighQ: Int64 = -1
    for (i in 0..M) {
        for (j in i+1..M) {
            let xi = ux[i]
            let xj = ux[j]
            let dx = xj - xi
            var small = i; var large = j
            var dxPos: Int64 = dx
            if (dx < 0) {
                small = j; large = i; dxPos = -dx
            }
            let upNum = uhi[large] - ulo[small]
            let up: Float64 = Float64.parse("${upNum}") / Float64.parse("${dxPos}")
            if (up < bestHigh) {
                bestHigh = up
                bestHighP = small
                bestHighQ = large
            }
            let lowNum = ulo[large] - uhi[small]
            let low: Float64 = Float64.parse("${lowNum}") / Float64.parse("${dxPos}")
            if (low > bestLow) {
                bestLow = low
                bestLowP = small
                bestLowQ = large
            }
        }
    }
    var pIdx: Int64 = -1
    var qIdx: Int64 = -1
    if (bestHigh < 1e90) {
        pIdx = bestHighP
        qIdx = bestHighQ
        let x1 = ux[pIdx]
        let y1 = ulo[pIdx]
        let x2 = ux[qIdx]
        let y2 = uhi[qIdx]
        println("${x1} ${y1} ${x2} ${y2}")
    } else {
        pIdx = bestLowP
        qIdx = bestLowQ
        let x1 = ux[pIdx]
        let y1 = uhi[pIdx]
        let x2 = ux[qIdx]
        let y2 = ulo[qIdx]
        println("${x1} ${y1} ${x2} ${y2}")
    }
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
