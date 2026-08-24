// L2-017 人以群分 - 排序后均分求差
import std.env.*
import std.collection.*
import std.convert.*
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
    let N = Int64.parse(next())
    let arr = ArrayList<Int64>()
    for (_ in 0..N) {
        arr.add(Int64.parse(next()))
    }
    sort(arr)
    let n1 = (N + 1) / 2
    let n2 = N / 2
    var sumOut: Int64 = 0
    var sumIn: Int64 = 0
    for (i in 0..n2) { sumIn += arr[i] }
    for (i in n2..N) { sumOut += arr[i] }
    let diff = sumOut - sumIn
    println("Outgoing #: ${n1}")
    println("Introverted #: ${n2}")
    println("Diff = ${diff}")
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
