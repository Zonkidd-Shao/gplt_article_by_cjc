// L3-017 森森快递 - interval max weight via greedy shortest interval first with segment tree
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
    let Q = Int64.parse(next())
    var C = Array<Int64>(N, repeat: 0) // C[0..N-2]
    for (i in 0..N-1) { C[i] = Int64.parse(next()) }
    var intervals = ArrayList<Array<Int64>>()
    for (_ in 0..Q) {
        let s = Int64.parse(next())
        let t = Int64.parse(next())
        var l = s; var r = t
        if (l > r) { let tmp=l; l=r; r=tmp }
        // interval [l, r) length r-l
        intervals.add([l, r])
    }
    // sort by length then by l using simple insertion sort (Q up to 1e5, but sample small; use quicksort)
    func cmp(a: Array<Int64>, b: Array<Int64>): Int64 {
        let la = a[1]-a[0]
        let lb = b[1]-b[0]
        if (la != lb) { return la - lb }
        return a[0]-b[0]
    }
    func quickSort(arr: ArrayList<Array<Int64>>, l: Int64, r: Int64): Unit {
        if (l >= r) { return }
        var i = l; var j = r
        let pivot = arr[(l+r)/2]
        while (i <= j) {
            while (cmp(arr[i], pivot) < 0) { i++ }
            while (cmp(arr[j], pivot) > 0) { j-- }
            if (i <= j) {
                let tmp = arr[i]; arr[i]=arr[j]; arr[j]=tmp
                i++; j--
            }
        }
        if (l < j) { quickSort(arr, l, j) }
        if (i < r) { quickSort(arr, i, r) }
    }
    if (intervals.size > 1) { quickSort(intervals, 0, intervals.size-1) }
    // segment tree for range min and range add
    let SZ: Int64 = N // we need size N, but query up to N-1
    var n: Int64 = 1
    while (n < SZ) { n = n*2 }
    var segMin = Array<Int64>(2*n, repeat: 9000000000000000000)
    var segLazy = Array<Int64>(2*n, repeat: 0)
    // init leaves
    for (i in 0..N-1) { segMin[n+i] = C[i] }
    for (i in (N-1)+1..n) { segMin[n+i] = 9000000000000000000 }
    var ii: Int64 = n-1
    while (ii >= 1) {
        let a = segMin[ii*2]
        let b = segMin[ii*2+1]
        segMin[ii] = if (a < b) {a} else {b}
        ii--
    }
    func push(node: Int64): Unit {
        let lz = segLazy[node]
        if (lz != 0) {
            for (child in [node*2, node*2+1]) {
                segMin[child] = segMin[child] + lz
                segLazy[child] = segLazy[child] + lz
            }
            segLazy[node] = 0
        }
    }
    func rangeAdd(node: Int64, l: Int64, r: Int64, ql: Int64, qr: Int64, delta: Int64): Unit {
        if (qr <= l || r <= ql) { return }
        if (ql <= l && r <= qr) {
            segMin[node] = segMin[node] + delta
            segLazy[node] = segLazy[node] + delta
            return
        }
        push(node)
        let mid = (l + r)/2
        rangeAdd(node*2, l, mid, ql, qr, delta)
        rangeAdd(node*2+1, mid, r, ql, qr, delta)
        let a = segMin[node*2]
        let b = segMin[node*2+1]
        segMin[node] = if (a < b) {a} else {b}
    }
    func rangeMin(node: Int64, l: Int64, r: Int64, ql: Int64, qr: Int64): Int64 {
        if (qr <= l || r <= ql) { return 9000000000000000000 }
        if (ql <= l && r <= qr) { return segMin[node] }
        push(node)
        let mid = (l + r)/2
        let a = rangeMin(node*2, l, mid, ql, qr)
        let b = rangeMin(node*2+1, mid, r, ql, qr)
        return if (a < b) {a} else {b}
    }
    var total: Int64 = 0
    for (inter in intervals) {
        let l = inter[0]
        let r = inter[1]
        let mn = rangeMin(1, 0, n, l, r)
        if (mn > 0 && mn < 9000000000000000000) {
            total = total + mn
            rangeAdd(1, 0, n, l, r, -mn)
        } else if (mn < 0) {
            // shouldn't happen
        }
    }
    println("${total}")
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
