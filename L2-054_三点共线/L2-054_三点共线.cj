// L2-054 三点共线 - y in {0,1,2} 共线条件 x0+x2==2*x1
// Approach: dedup per y, presence arrays, for each x1 iterate over smaller side
import std.env.*
import std.collection.*
import std.convert.*
import std.sort.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    // whitespace tokenization using Rune
    let runes = all.toRuneArray()
    let tokens = ArrayList<String>()
    var sb = StringBuilder()
    let sp: Rune = ' '
    let nl: Rune = '\n'
    let tab: Rune = '\t'
    let cr: Rune = '\r'
    for (r in runes) {
        if (r == sp || r == nl || r == tab || r == cr) {
            let cur = sb.toString()
            if (cur.size > 0) { tokens.add(cur) }
            sb = StringBuilder()
        } else {
            sb.append(r)
        }
    }
    let last = sb.toString()
    if (last.size > 0) { tokens.add(last) }

    if (tokens.size == 0) { return }
    var idx: Int64 = 0
    let n = Int64.parse(tokens[idx]); idx++
    let OFFSET: Int64 = 1000000
    let SZ: Int64 = 2000001
    let present0 = Array<Bool>(SZ, repeat: false)
    let present1 = Array<Bool>(SZ, repeat: false)
    let present2 = Array<Bool>(SZ, repeat: false)
    for (i in 0..n) {
        if (idx + 1 >= tokens.size) { break }
        let x = Int64.parse(tokens[idx]); idx++
        let y = Int64.parse(tokens[idx]); idx++
        let p = x + OFFSET
        if (p < 0 || p >= SZ) { continue }
        if (y == 0) {
            present0[p] = true
        } else if (y == 1) {
            present1[p] = true
        } else if (y == 2) {
            present2[p] = true
        }
    }
    let list0 = ArrayList<Int64>()
    let list1 = ArrayList<Int64>()
    let list2 = ArrayList<Int64>()
    for (i in 0..SZ) {
        if (present0[i]) { list0.add(i - OFFSET) }
        if (present1[i]) { list1.add(i - OFFSET) }
        if (present2[i]) { list2.add(i - OFFSET) }
    }

    if (list0.size == 0 || list1.size == 0 || list2.size == 0) {
        println("-1")
        return
    }

    let results = ArrayList<String>()
    let keys = ArrayList<Int64>()
    let FACTOR: Int64 = 4000007 // > 2*OFFSET
    let use0Small = list0.size <= list2.size
    if (use0Small) {
        for (xi in 0..list1.size) {
            let x1 = list1[xi]
            let twox1 = x1 * 2
            for (xj in 0..list0.size) {
                let x0 = list0[xj]
                let x2 = twox1 - x0
                let p2 = x2 + OFFSET
                if (p2 < 0 || p2 >= SZ) { continue }
                if (present2[p2]) {
                    let sb2 = StringBuilder()
                    sb2.append("[")
                    sb2.append(x0.toString())
                    sb2.append(", 0] [")
                    sb2.append(x1.toString())
                    sb2.append(", 1] [")
                    sb2.append(x2.toString())
                    sb2.append(", 2]")
                    let str = sb2.toString()
                    results.add(str)
                    let key = (x1 + OFFSET) * FACTOR + (x0 + OFFSET)
                    keys.add(key)
                }
            }
        }
    } else {
        for (xi in 0..list1.size) {
            let x1 = list1[xi]
            let twox1 = x1 * 2
            for (xj in 0..list2.size) {
                let x2 = list2[xj]
                let x0 = twox1 - x2
                let p0 = x0 + OFFSET
                if (p0 < 0 || p0 >= SZ) { continue }
                if (present0[p0]) {
                    let sb2 = StringBuilder()
                    sb2.append("[")
                    sb2.append(x0.toString())
                    sb2.append(", 0] [")
                    sb2.append(x1.toString())
                    sb2.append(", 1] [")
                    sb2.append(x2.toString())
                    sb2.append(", 2]")
                    let str = sb2.toString()
                    results.add(str)
                    let key = (x1 + OFFSET) * FACTOR + (x0 + OFFSET)
                    keys.add(key)
                }
            }
        }
    }

    if (results.size == 0) {
        println("-1")
        return
    }
    // sort by key
    // create index array
    let idxs = ArrayList<Int64>()
    for (i in 0..results.size) { idxs.add(i) }
    // sort idxs by keys[idx]
    // Use bubble sort via std sort on parallel array of keys? Instead create array of keys and sort copy mapping
    // Create list of pairs (key, idx) and sort by key
    let pairKeys = ArrayList<Int64>()
    for (i in 0..keys.size) { pairKeys.add(keys[i]) }
    // We need to sort results by keys. Simplest: create ArrayList<Int64> sortedKeys = keys duplicate and sort, then map.
    // But duplicate keys may exist? If duplicates, need stable. Instead we can sort idxs using insertion sort manually O(n^2) but n up to 1e5 => too large.
    // Use technique: sort ArrayList<Int64> of keys with associated results via creating array of combined 64-bit? Instead we can sort idxs via using std sort on custom struct.
    // Create a helper array of Int64 keys and sort with indices using manual quicksort implementing comparator keys[a]<keys[b]
    // Implement quicksort for idxs
    func quickSort(l: Int64, r: Int64): Unit {
        if (l >= r) { return }
        var i = l
        var j = r
        let pivot = keys[idxs[(l+r)/2]]
        while (i <= j) {
            while (keys[idxs[i]] < pivot) { i++ }
            while (keys[idxs[j]] > pivot) { j-- }
            if (i <= j) {
                let tmp = idxs[i]
                idxs[i] = idxs[j]
                idxs[j] = tmp
                i++; j--
            }
        }
        if (l < j) { quickSort(l, j) }
        if (i < r) { quickSort(i, r) }
    }
    quickSort(0, idxs.size - 1)

    let sbOut = StringBuilder()
    for (k in 0..idxs.size) {
        let id = idxs[k]
        sbOut.append(results[id])
        sbOut.append("\n")
    }
    print(sbOut.toString())
}
