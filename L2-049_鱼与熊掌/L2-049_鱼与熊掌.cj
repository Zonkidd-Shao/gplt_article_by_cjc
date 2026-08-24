// L2-049 鱼与熊掌 - 集合交集
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
    let n = Int64.parse(toks[p]); p+=1
    let m = Int64.parse(toks[p]); p+=1
    var owners = Array<HashSet<Int64>>(m+1, repeat: HashSet<Int64>())
    for (i in 0..m) { owners[i]=HashSet<Int64>() }
    for (person in 1..=n) {
        let K = Int64.parse(toks[p]); p+=1
        for (k in 0..K) {
            let item = Int64.parse(toks[p]); p+=1
            owners[item].add(person)
        }
    }
    let Q = Int64.parse(toks[p]); p+=1
    var out = StringBuilder()
    for (q in 0..Q) {
        let a = Int64.parse(toks[p]); let b = Int64.parse(toks[p+1]); p+=2
        let setA = owners[a]
        let setB = owners[b]
        var small = setA
        var large = setB
        if (setA.size > setB.size) { small=setB; large=setA }
        var cnt: Int64 = 0
        for (x in small) {
            if (large.contains(x)) { cnt+=1 }
        }
        out.append("${cnt}\n")
    }
    print(out.toString())
}
