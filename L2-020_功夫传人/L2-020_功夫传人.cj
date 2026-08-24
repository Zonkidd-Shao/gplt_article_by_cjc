// L2-020 功夫传人 - 树BFS衰减
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
    let N = Int64.parse(next())
    let Z = Float64.parse(next())
    let r = Float64.parse(next())
    let decay = 1.0 - r / 100.0
    let children = Array<ArrayList<Int64>>(N, { _ => ArrayList<Int64>() })
    let isLeaf = Array<Bool>(N, repeat: false)
    let mult = Array<Float64>(N, repeat: 0.0)
    for (i in 0..N) {
        let Ki = Int64.parse(next())
        if (Ki == 0) {
            isLeaf[i] = true
            mult[i] = Float64.parse(next())
        } else {
            for (_ in 0..Ki) {
                let cid = Int64.parse(next())
                children[i].add(cid)
            }
        }
    }
    var total = 0.0
    let qNode = ArrayList<Int64>()
    let qPow = ArrayList<Float64>()
    qNode.add(0)
    qPow.add(Z)
    var head: Int64 = 0
    while (head < qNode.size) {
        let node = qNode[head]
        let pow = qPow[head]
        head++
        if (isLeaf[node]) {
            total += pow * mult[node]
        } else {
            for (c in children[node]) {
                qNode.add(c)
                qPow.add(pow * decay)
            }
        }
    }
    let ans = Int64(total)
    println("${ans}")
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
