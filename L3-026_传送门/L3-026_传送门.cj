// L3-026 传送门 - 通用解法 动态维护置换的合成（朴素 O(q * (a log a + n))，满足样例与中小规模）
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
    if (toks.size < 2) { return }
    let n = Int64.parse(next())
    let q = Int64.parse(next())
    var swaps = ArrayList<Array<Int64>>() // store all swaps ever seen [y, x1, x2]
    var active = HashMap<String, Bool>()
    for (_i in 0..q) {
        if (p >= toks.size) { break }
        let op = next()
        if (p + 2 >= toks.size) { break }
        let x1 = Int64.parse(next())
        let x2 = Int64.parse(next())
        let y = Int64.parse(next())
        let key = "${x1},${x2},${y}"
        let rkey = "${x2},${x1},${y}"
        if (op == "+") {
            active[key] = true
            swaps.add([y, x1, x2])
        } else {
            // remove both directions
            if (active.contains(key)) { active.remove(key) }
            if (active.contains(rkey)) { active.remove(rkey) }
        }
        // collect active swaps
        var act = ArrayList<Array<Int64>>()
        for (s in swaps) {
            let kk = "${s[1]},${s[2]},${s[0]}"
            let kk2 = "${s[2]},${s[1]},${s[0]}"
            if (active.contains(kk) || active.contains(kk2)) {
                // avoid duplicate adding same logical swap multiple times if duplicate entries in swaps list
                // we will deduplicate later via map
            }
        }
        // deduplicate via map y->pair (since swaps list may have duplicates)
        var dedup = HashMap<String, Array<Int64>>()
        for (s in swaps) {
            let kk = "${s[1]},${s[2]},${s[0]}"
            let kk2 = "${s[2]},${s[1]},${s[0]}"
            if (active.contains(kk) || active.contains(kk2)) {
                let dk = "${s[0]},${s[1]},${s[2]}"
                // normalize key
                if (!dedup.contains(dk)) { dedup[dk] = s }
            }
        }
        // gather dedup values
        for (kv in dedup) {
            act.add(kv[1])
        }
        // sort by y ascending (simple insertion sort / bubble for small act; for larger use quick sort)
        quickSort(act, 0, act.size - 1)
        var perm = Array<Int64>(n+1, repeat: 0)
        for (i in 1..(n+1)) { perm[i] = i }
        for (s in act) {
            let a = s[1]; let b = s[2]
            let tmp = perm[a]; perm[a] = perm[b]; perm[b] = tmp
        }
        var sum: Int64 = 0
        for (i in 1..(n+1)) { sum = sum + i * perm[i] }
        println(sum.toString())
    }
}

func quickSort(arr: ArrayList<Array<Int64>>, l: Int64, r: Int64): Unit {
    if (l >= r) { return }
    var i = l; var j = r
    let piv = arr[(l+r)/2][0]
    while (i <= j) {
        while (arr[i][0] < piv) { i++ }
        while (arr[j][0] > piv) { j-- }
        if (i <= j) {
            let t = arr[i]; arr[i] = arr[j]; arr[j] = t
            i++; j--
        }
    }
    if (l < j) { quickSort(arr, l, j) }
    if (i < r) { quickSort(arr, i, r) }
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs==" "||rs=="\n"||rs=="\r"||rs=="\t") {
            if (cur.size>0) { res.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size>0) { res.add(cur.toString()) }
    return res.toArray()
}
