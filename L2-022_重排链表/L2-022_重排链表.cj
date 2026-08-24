// L2-022 重排链表 - 双指针重排
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var idx: Int64 = 0
    func next(): String { let v = toks[idx]; idx++; return v }
    let head = next()
    let N = Int64.parse(next())
    let nextMap = HashMap<String, String>()
    let dataMap = HashMap<String, String>()
    for (_ in 0..N) {
        let addr = next()
        let data = next()
        let nxt = next()
        dataMap[addr] = data
        nextMap[addr] = nxt
    }
    let nextMap2 = HashMap<String,String>()
    let dataMap2 = HashMap<String,String>()
    for ((k,v) in nextMap) {
        let pk = pad(k)
        nextMap2[pk] = pad(v)
    }
    for ((k,v) in dataMap) { dataMap2[pad(k)] = v }
    var list = ArrayList<String>()
    var cur = pad(head)
    var cnt: Int64 = 0
    while (cur != "-1" && cnt <= N + 5) {
        if (!dataMap2.contains(cur)) { break }
        list.add(cur)
        let nxt = nextMap2.get(cur) ?? "-1"
        cur = nxt
        cnt++
        if (cur == "-1") { break }
    }
    if (list.size == 0) {
        var c2 = head
        var cnt2: Int64 = 0
        while (c2 != "-1" && cnt2 <= N + 5) {
            if (!dataMap.contains(c2)) { break }
            list.add(c2)
            let nxt = nextMap.get(c2) ?? "-1"
            c2 = nxt
            cnt2++
            if (c2 == "-1") { break }
        }
        for (i in 0..list.size) { list[i] = pad(list[i]) }
    }
    var res = ArrayList<String>()
    var left: Int64 = 0
    var right: Int64 = list.size - 1
    var takeRight = true
    while (left <= right) {
        if (takeRight) {
            res.add(list[right]); right--
        } else {
            res.add(list[left]); left++
        }
        takeRight = !takeRight
    }
    let sb = StringBuilder()
    for (i in 0..res.size) {
        let a = res[i]
        let d = dataMap2.get(a) ?? (dataMap.get(a) ?? "")
        let nxt = if (i + 1 < res.size) { res[i+1] } else { "-1" }
        sb.append("${a} ${d} ${nxt}\n")
    }
    print(sb.toString())
}

func pad(s: String): String {
    if (s == "-1") { return "-1" }
    var t = s
    while (t.size < 5) { t = "0" + t }
    return t
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
