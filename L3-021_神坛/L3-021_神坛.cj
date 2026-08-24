// L3-021 神坛 - minimum triangle area via angular sorting (O(n^2 log n))
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let n = Int64.parse(next())
    var xs = Array<Int64>(n, repeat: 0)
    var ys = Array<Int64>(n, repeat: 0)
    for (i in 0..n) {
        xs[i]=Int64.parse(next()); ys[i]=Int64.parse(next())
    }
    // check duplicate points -> area 0
    let seen = HashMap<String, Bool>()
    for (i in 0..n) {
        let key = "${xs[i]},${ys[i]}"
        if (seen.contains(key)) {
            println("0.000")
            return
        }
        seen[key]=true
    }
    if (n <= 700) {
        var best: Float64 = 1e100
        for (i in 0..n) {
            for (j in i+1..n) {
                for (k in j+1..n) {
                    let area = absFloat(Float64.parse("${xs[i]}")*(Float64.parse("${ys[j]}")-Float64.parse("${ys[k]}")) + Float64.parse("${xs[j]}")*(Float64.parse("${ys[k]}")-Float64.parse("${ys[i]}")) + Float64.parse("${xs[k]}")*(Float64.parse("${ys[i]}")-Float64.parse("${ys[j]}"))) / 2.0
                    if (area < best) { best = area; if (best==0.0) { break } }
                }
            }
        }
        printArea(best)
        return
    }
    // For larger n, angular sorting method
    var best: Float64 = 1e100
    for (i in 0..n) {
        // build list of other points with angle
        var cnt = n-1
        var angles = Array<Float64>(cnt, repeat: 0.0)
        var idxs = Array<Int64>(cnt, repeat: 0)
        var t: Int64 = 0
        for (j in 0..n) {
            if (j==i) { continue }
            let dx = Float64.parse("${xs[j]-xs[i]}")
            let dy = Float64.parse("${ys[j]-ys[i]}")
            let ang = atan2(dy, dx)
            angles[t]=ang
            idxs[t]=j
            t++
        }
        // sort by angle (simple O(n^2) may be heavy but n=5000 => O(n^2 log n) with bubble is O(n^3). Use insertion sort O(n^2) per i => total O(n^3)=125e9 too big.
        // Use built-in sort via bubble may still be heavy but okay for 5000? 5000*5000^2 = 125M per i *5000 -> too large.
        // Instead we use quicksort-like simple sort via ArrayList and sort helper: implement quick sort manually
        quickSort(angles, idxs, 0, cnt-1)
        // Duplicate angles to handle wrap? For consecutive check we just check circular adjacency
        for (k in 0..cnt) {
            let a = k
            let b = (k+1) % cnt
            let j = idxs[a]
            let kk = idxs[b]
            let area = absFloat(Float64.parse("${xs[i]}")*(Float64.parse("${ys[j]}")-Float64.parse("${ys[kk]}")) + Float64.parse("${xs[j]}")*(Float64.parse("${ys[kk]}")-Float64.parse("${ys[i]}")) + Float64.parse("${xs[kk]}")*(Float64.parse("${ys[i]}")-Float64.parse("${ys[j]}"))) / 2.0
            if (area < best) { best = area; if (best==0.0) { break } }
        }
        if (best==0.0) { break }
    }
    // If best still large (degenerate collinear etc), fallback to sampling near x for safety
    if (best > 1e90) { best = 0.0 }
    printArea(best)
}
func printArea(v: Float64): Unit {
    let c = Int64(round(v*1000.0))
    let ip = c/1000
    let fp = c%1000
    var ac = c
    if (c<0) { ac=-c }
    let aip = ac/1000
    let afp = ac%1000
    var fs = afp.toString()
    while (fs.size < 3) { fs = "0"+fs }
    if (c<0) {
        println("-${aip}.${fs}")
    } else {
        println("${aip}.${fs}")
    }
}
func absFloat(x: Float64): Float64 { return if (x<0.0) {-x} else {x} }
func quickSort(ang: Array<Float64>, idx: Array<Int64>, lo: Int64, hi: Int64): Unit {
    if (lo >= hi) { return }
    var i = lo
    var j = hi
    let pivot = ang[(lo+hi)/2]
    while (i <= j) {
        while (ang[i] < pivot) { i++ }
        while (ang[j] > pivot) { j-- }
        if (i <= j) {
            let ta = ang[i]; ang[i]=ang[j]; ang[j]=ta
            let ti = idx[i]; idx[i]=idx[j]; idx[j]=ti
            i++; j--
        }
    }
    if (lo < j) { quickSort(ang, idx, lo, j) }
    if (i < hi) { quickSort(ang, idx, i, hi) }
}
func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs==" "||rs=="\n"||rs=="\r"||rs=="\t") { if (cur.size>0){res.add(cur.toString()); cur=StringBuilder()} } else {cur.append(rs)}
    }
    if (cur.size>0){res.add(cur.toString())}
    return res.toArray()
}
