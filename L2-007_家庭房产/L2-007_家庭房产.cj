// L2-007 家庭房产
import std.env.*
import std.collection.*
import std.convert.*
class Fam {
    var minId: String = ""
    var cnt: Int64 = 0
    var houses: Float64 = 0.0
    var area: Float64 = 0.0
}
func find(par: HashMap<String,String>, x: String): String {
    let p = par[x]
    if (p == x) { return x }
    let r = find(par, p)
    par[x] = r
    return r
}
func union(par: HashMap<String,String>, a: String, b: String) {
    let ra = find(par, a)
    let rb = find(par, b)
    if (ra == rb) { return }
    // union by numeric smaller root to be parent (optional)
    // compare numeric values
    let na = Int64.parse(ra)
    let nb = Int64.parse(rb)
    if (na < nb) { par[rb] = ra } else { par[ra] = rb }
}
func fmtId(s: String): String {
    var r = s
    while (r.size < 4) { r = "0" + r }
    return r
}
func fmt3(x: Float64): String {
    let scaled = x * 1000.0
    let v = Int64(scaled + 0.5 + 0.000001)
    let ip = v / 1000
    let fp = v % 1000
    var fps = "${fp}"
    if (fp < 10) { fps = "00${fp}" } else if (fp < 100) { fps = "0${fp}" }
    return "${ip}.${fps}"
}
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let sp: Rune = ' '
    let nl: Rune = '\n'
    let cr: Rune = '\r'
    let tab: Rune = '\t'
    var tokens = ArrayList<String>()
    var sb = StringBuilder()
    var inTok = false
    for (ch in all.toRuneArray()) {
        let isSpace = (ch == sp) || (ch == nl) || (ch == cr) || (ch == tab)
        if (isSpace) { if (inTok) { tokens.add(sb.toString()); sb=StringBuilder(); inTok=false } }
        else { sb.append(ch); inTok=true }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var pos: Int64 = 1
    var parent = HashMap<String,String>()
    var houseMap = HashMap<String, Float64>()
    var areaMap = HashMap<String, Float64>()
    // also need set of all persons; parent keys will represent
    for (_ in 0..n) {
        if (pos + 3 >= tokens.size) { break }
        let id = tokens[pos]; pos+=1
        let fa = tokens[pos]; pos+=1
        let mo = tokens[pos]; pos+=1
        let k = Int64.parse(tokens[pos]); pos+=1
        var childs = ArrayList<String>()
        for (i in 0..k) {
            if (pos >= tokens.size) { break }
            childs.add(tokens[pos]); pos+=1
        }
        if (pos + 1 >= tokens.size) { break }
        let cntH = Float64.parse(tokens[pos]); pos+=1
        let areaV = Float64.parse(tokens[pos]); pos+=1
        // ensure entry for id
        if (!parent.contains(id)) { parent[id] = id }
        houseMap[id] = cntH
        areaMap[id] = areaV
        if (fa != "-1") {
            if (!parent.contains(fa)) { parent[fa]=fa; houseMap[fa]=0.0; areaMap[fa]=0.0 }
            union(parent, id, fa)
        }
        if (mo != "-1") {
            if (!parent.contains(mo)) { parent[mo]=mo; houseMap[mo]=0.0; areaMap[mo]=0.0 }
            union(parent, id, mo)
        }
        for (ch in childs) {
            if (!parent.contains(ch)) { parent[ch]=ch; houseMap[ch]=0.0; areaMap[ch]=0.0 }
            union(parent, id, ch)
        }
        // ensure maps for id already
        // also for missing houseMap entries already handled
    }
    // aggregate
    var famMap = HashMap<String, Fam>()
    for ((id, _) in parent) {
        let root = find(parent, id)
        var f: Fam
        if (famMap.contains(root)) {
            f = famMap[root]
        } else {
            f = Fam()
            f.minId = id
            f.cnt = 0
            f.houses = 0.0
            f.area = 0.0
            famMap[root] = f
        }
        // update min
        if (Int64.parse(id) < Int64.parse(f.minId)) { f.minId = id }
        f.cnt += 1
        let h = if (houseMap.contains(id)) { houseMap[id] } else { 0.0 }
        let a = if (areaMap.contains(id)) { areaMap[id] } else { 0.0 }
        f.houses += h
        f.area += a
    }
    var fams = ArrayList<Fam>()
    for ((_, f) in famMap) { fams.add(f) }
    // sort: avg area descending, tie minId ascending
    for (i in 0..fams.size) {
        for (j in (i+1)..fams.size) {
            let a = fams[i]
            let b = fams[j]
            let avgA = a.area / Float64.parse("${a.cnt}")
            let avgB = b.area / Float64.parse("${b.cnt}")
            var needSwap = false
            if (avgA < avgB) { needSwap = true }
            else if (avgA == avgB) {
                if (Int64.parse(a.minId) > Int64.parse(b.minId)) { needSwap = true }
            }
            if (needSwap) {
                let tmp = fams[i]
                fams[i] = fams[j]
                fams[j] = tmp
            }
        }
    }
    println(fams.size)
    for (f in fams) {
        let avgH = f.houses / Float64.parse("${f.cnt}")
        let avgA = f.area / Float64.parse("${f.cnt}")
        println("${fmtId(f.minId)} ${f.cnt} ${fmt3(avgH)} ${fmt3(avgA)}")
    }
}
