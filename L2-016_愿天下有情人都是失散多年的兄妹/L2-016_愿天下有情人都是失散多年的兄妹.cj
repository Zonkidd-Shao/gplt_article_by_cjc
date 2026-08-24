// L2-016 愿天下有情人都是失散多年的兄妹 - 五代以内距离<=4判定
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
    let gender = HashMap<String, String>()
    let father = HashMap<String, String>()
    let mother = HashMap<String, String>()
    for (_ in 0..N) {
        let id = next()
        let g = next()
        let f = next()
        let m = next()
        gender[id] = g
        father[id] = f
        mother[id] = m
    }
    let K = Int64.parse(next())
    let sb = StringBuilder()
    for (_ in 0..K) {
        let a = next()
        let b = next()
        let ga = gender.get(a) ?? ""
        let gb = gender.get(b) ?? ""
        if (!ga.isEmpty() && ga == gb) {
            sb.append("Never Mind\n")
            continue
        }
        let ancA = HashMap<String, Int64>()
        let ancB = HashMap<String, Int64>()
        collect(a, 0, father, mother, ancA)
        collect(b, 0, father, mother, ancB)
        var forbid = false
        for ((k, da) in ancA) {
            let opt = ancB.get(k)
            if (let Some(v) <- opt) {
                if (da <= 4 && v <= 4) {
                    forbid = true
                    break
                }
            }
        }
        if (forbid) {
            sb.append("No\n")
        } else {
            sb.append("Yes\n")
        }
    }
    print(sb.toString())
}

func collect(id: String, d: Int64, father: HashMap<String,String>, mother: HashMap<String,String>, res: HashMap<String,Int64>): Unit {
    if (id == "-1") { return }
    if (d > 4) { return }
    let old = res.get(id)
    if (let Some(v) <- old) {
        if (v <= d) { return }
    }
    res[id] = d
    let f = father.get(id) ?? "-1"
    let m = mother.get(id) ?? "-1"
    if (f != "-1") {
        let hasF = father.contains(f) || mother.contains(f)
        if (hasF) {
            collect(f, d + 1, father, mother, res)
        } else {
            let od = res.get(f)
            if (let Some(_) <- od) {
            } else {
                if (d + 1 <= 4) { res[f] = d + 1 }
            }
        }
    }
    if (m != "-1") {
        let hasM = father.contains(m) || mother.contains(m)
        if (hasM) {
            collect(m, d + 1, father, mother, res)
        } else {
            let od = res.get(m)
            if (let Some(_) <- od) {
            } else {
                if (d + 1 <= 4) { res[m] = d + 1 }
            }
        }
    }
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) {
                res.add(cur.toString())
                cur = StringBuilder()
            }
        } else {
            cur.append(rs)
        }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
