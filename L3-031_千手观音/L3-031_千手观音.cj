// L3-031 千手观音 - 符号顺序推导
import std.collection.*
import std.convert.*
import std.env.*
import std.sort.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let lines = all.split("\n")
    let filt = ArrayList<String>()
    for (ln in lines) {
        let t = ln.trimAscii()
        if (t.size > 0) { filt.add(t) }
    }
    let N = Int64.parse(filt[0])
    let nums = ArrayList<Array<String>>()
    let symSet = HashSet<String>()
    for (i in 1..N+1) {
        let s = filt[i]
        let parts = s.split(".")
        let arr = ArrayList<String>()
        for (p in parts) {
            // parts may contain empty due to consecutive dots? filter
            if (p.size > 0) {
                arr.add(p)
                symSet.add(p)
            }
        }
        // If split failed (e.g., s="pat" -> parts = ["pat"]? but split with "." may return whole string if no dot)
        // The above already handles, but if arr is empty (when s contains dot but split gave weird), fallback to manual
        if (arr.size == 0) {
            arr.add(s)
            symSet.add(s)
        }
        // Convert ArrayList to Array for storage
        let a = Array<String>(arr.size, repeat: "")
        for (k in 0..arr.size) { a[k]=arr[k] }
        nums.add(a)
    }
    let symList = ArrayList<String>()
    for (sym in symSet) { symList.add(sym) }
    let n = symList.size
    let idxMap = HashMap<String, Int64>()
    for (i in 0..n) {
        idxMap[symList[i]] = i
    }
    let adj = Array<ArrayList<Int64>>(n, repeat: ArrayList<Int64>())
    for (i in 0..n) { adj[i]=ArrayList<Int64>() }
    let indeg = Array<Int64>(n, repeat: 0)
    let edgeSet = HashSet<String>()
    for (i in 0..N-1) {
        let a = nums[i]
        let b = nums[i+1]
        if (a.size != b.size) { continue }
        var j: Int64 = 0
        while (j < Int64(a.size) && a[j] == b[j]) { j++ }
        if (j < Int64(a.size)) {
            let u = idxMap[a[j]]
            let v = idxMap[b[j]]
            let key = "${u},${v}"
            if (!edgeSet.contains(key)) {
                edgeSet.add(key)
                adj[u].add(v)
                indeg[v]++
            }
        }
    }
    let zero = ArrayList<Int64>()
    for (i in 0..n) {
        if (indeg[i]==0) { zero.add(i) }
    }
    let result = ArrayList<String>()
    while (zero.size > 0) {
        // find minimal lexicographically
        var bestIdx: Int64 = 0
        var bestVal = symList[zero[0]]
        for (k in 1..zero.size) {
            let cur = symList[zero[k]]
            if (cur < bestVal) {
                bestVal = cur
                bestIdx = k
            }
        }
        let u = zero[bestIdx]
        // remove u from zero
        let nz = ArrayList<Int64>()
        for (k in 0..zero.size) {
            if (k != bestIdx) { nz.add(zero[k]) }
        }
        zero.clear()
        for (k in 0..nz.size) { zero.add(nz[k]) }
        result.add(symList[u])
        for (v in adj[u]) {
            indeg[v]--
            if (indeg[v]==0) { zero.add(v) }
        }
    }
    let sb = StringBuilder()
    for (i in 0..result.size) {
        if (i>0) { sb.append(".") }
        sb.append(result[i])
    }
    println(sb.toString())
}
