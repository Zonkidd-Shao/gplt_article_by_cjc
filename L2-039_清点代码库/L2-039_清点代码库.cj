// L2-039 清点代码库 - 统计功能重复
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var toks = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s==" "||s=="\n"||s=="\r"||s=="\t") {
            if (cur.toString().size>0) { toks.add(cur.toString()); cur=StringBuilder() }
        } else { cur.append(s) }
    }
    if (cur.toString().size>0) { toks.add(cur.toString()) }
    var p: Int64 = 0
    let N = Int64.parse(toks[p]); p+=1
    let M = Int64.parse(toks[p]); p+=1
    var freq = HashMap<String, Int64>()
    var seqMap = HashMap<String, ArrayList<Int64>>()
    for (i in 0..N) {
        var seq = ArrayList<Int64>()
        var keySb = StringBuilder()
        for (j in 0..M) {
            let v = Int64.parse(toks[p]); p+=1
            seq.add(v)
            if (j>0) { keySb.append(",") }
            keySb.append("${v}")
        }
        let key = keySb.toString()
        if (freq.contains(key)) {
            freq[key] = freq[key] + 1
        } else {
            freq[key] = 1
            seqMap[key] = seq
        }
    }
    var keys = ArrayList<String>()
    for ((k,v) in freq) { keys.add(k) }
    // sort by count desc then sequence lexicographically asc
    for (i in 0..keys.size) {
        for (j in i+1..keys.size) {
            let ka = keys[i]; let kb = keys[j]
            let ca = freq[ka]; let cb = freq[kb]
            var needSwap = false
            if (ca != cb) {
                if (ca < cb) { needSwap = true }
            } else {
                let sa = seqMap[ka]; let sb = seqMap[kb]
                var cmp: Int64 = 0
                for (k in 0..M) {
                    if (sa[k] < sb[k]) { cmp = -1; break }
                    if (sa[k] > sb[k]) { cmp = 1; break }
                }
                if (cmp > 0) { needSwap = true }
            }
            if (needSwap) {
                let tmp = keys[i]; keys[i]=keys[j]; keys[j]=tmp
            }
        }
    }
    println("${keys.size}")
    for (k in keys) {
        let cnt = freq[k]
        let seq = seqMap[k]
        var sb = StringBuilder()
        sb.append("${cnt}")
        for (x in seq) { sb.append(" ${x}") }
        println(sb.toString())
    }
}
