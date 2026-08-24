// L2-030 冰岛人 - 维京姓氏五代判定(不含第五代)
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
    func next(): String { let v = toks[idx]; idx++; return v }
    let N = Int64.parse(next())
    let gender = HashMap<String, String>()
    let parentName = HashMap<String, String>()
    for (_ in 0..N) {
        let first = next()
        let last = next()
        var g = ""
        var father = ""
        if (last.endsWith("sson")) {
            g = "m"
            father = last[0..(last.size - 4)]
        } else if (last.endsWith("sdottir")) {
            g = "f"
            father = last[0..(last.size - 7)]
        } else if (last.endsWith("m")) {
            g = "m"
            father = ""
        } else if (last.endsWith("f")) {
            g = "f"
            father = ""
        }
        gender[first] = g
        parentName[first] = father
    }
    let M = Int64.parse(next())
    let sb = StringBuilder()
    for (_ in 0..M) {
        let fn1 = next()
        let ln1 = next()
        let fn2 = next()
        let ln2 = next()
        if (!gender.contains(fn1) || !gender.contains(fn2)) {
            sb.append("NA\n")
            continue
        }
        let g1 = gender[fn1]
        let g2 = gender[fn2]
        if (g1 == g2) {
            sb.append("Whatever\n")
            continue
        }
        let anc1 = HashMap<String,Int64>()
        let anc2 = HashMap<String,Int64>()
        collect(fn1, 0, parentName, anc1)
        collect(fn2, 0, parentName, anc2)
        var forbid = false
        for ((k, d1) in anc1) {
            let opt = anc2.get(k)
            if (let Some(v) <- opt) {
                if (d1 <= 3 && v <= 3) { forbid = true; break }
            }
        }
        sb.append(if (forbid) {"No\n"} else {"Yes\n"})
    }
    print(sb.toString())
}

func collect(name: String, d: Int64, parent: HashMap<String,String>, res: HashMap<String,Int64>): Unit {
    if (d >= 5) { return }
    if (!parent.contains(name)) {
        res[name] = d
        return
    }
    let old = res.get(name)
    if (let Some(v) <- old) { if (v <= d) { return } }
    res[name] = d
    let f = parent.get(name) ?? ""
    if (!f.isEmpty()) { collect(f, d+1, parent, res) }
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
