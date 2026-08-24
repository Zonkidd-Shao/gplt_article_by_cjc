// L2-050 懂蛇语 - 首字母映射
import std.env.*
import std.collection.*
import std.convert.*

func acronym(s: String): String {
    let parts = s.split(" ")
    var sb = StringBuilder()
    for (p in parts) {
        if (p.size==0) { continue }
        // first character of p
        let rr = p.toRuneArray()
        if (rr.size>0) { sb.append(rr[0].toString()) }
    }
    return sb.toString()
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var lines = ArrayList<String>()
    var tmp = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s=="\n") { lines.add(tmp.toString()); tmp=StringBuilder() } else if (s=="\r") {} else { tmp.append(s) }
    }
    lines.add(tmp.toString())
    var p: Int64 = 0
    while (p < lines.size && lines[p].trimAscii().size==0) { p+=1 }
    let N = Int64.parse(lines[p].trimAscii()); p+=1
    var dict = HashMap<String, ArrayList<String>>()
    for (i in 0..N) {
        if (p >= lines.size) { break }
        let sentence = lines[p]; p+=1
        let key = acronym(sentence)
        if (!dict.contains(key)) { dict[key]=ArrayList<String>() }
        dict[key].add(sentence)
    }
    // sort each list lexicographically
    for ((k, lst) in dict) {
        // bubble sort
        for (i in 0..lst.size) {
            for (j in i+1..lst.size) {
                if (lst[j] < lst[i]) {
                    let tmp2 = lst[i]; lst[i]=lst[j]; lst[j]=tmp2
                }
            }
        }
    }
    while (p < lines.size && lines[p].trimAscii().size==0) { p+=1 }
    if (p>=lines.size) { return }
    let M = Int64.parse(lines[p].trimAscii()); p+=1
    var out = StringBuilder()
    for (i in 0..M) {
        if (p >= lines.size) { break }
        let query = lines[p]; p+=1
        let key = acronym(query)
        if (dict.contains(key)) {
            let lst = dict[key]
            for (k in 0..lst.size) {
                if (k>0) { out.append("|") }
                out.append(lst[k])
            }
            out.append("\n")
        } else {
            out.append("${query}\n")
        }
    }
    print(out.toString())
}
