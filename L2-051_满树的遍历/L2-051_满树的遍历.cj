// L2-051 满树的遍历 - 判断满树+前序
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
    var children = Array<ArrayList<Int64>>(n+1, repeat: ArrayList<Int64>())
    for (i in 1..=n) { children[i]=ArrayList<Int64>() }
    var root: Int64 = 1
    for (i in 1..=n) {
        let par = Int64.parse(toks[p]); p+=1
        if (par==0) { root=i } else { children[par].add(i) }
    }
    for (i in 1..=n) {
        let lst = children[i]
        for (a in 0..lst.size) {
            for (b in a+1..lst.size) {
                if (lst[b] < lst[a]) {
                    let t = lst[a]; lst[a]=lst[b]; lst[b]=t
                }
            }
        }
    }
    var maxDeg: Int64 = 0
    for (i in 1..=n) { if (children[i].size > maxDeg) { maxDeg = children[i].size } }
    var isFull = true
    for (i in 1..=n) {
        let d = children[i].size
        if (d>0 && d != maxDeg) { isFull=false; break }
    }
    var order = ArrayList<Int64>()
    var stack = ArrayList<Int64>(); stack.add(root)
    while (stack.size > 0) {
        let u = stack[stack.size-1]; stack.remove((stack.size-1)..stack.size)
        order.add(u)
        let lst = children[u]
        var idx = lst.size - 1
        while (idx >= 0) {
            stack.add(lst[idx]); idx-=1
        }
    }
    if (isFull) { println("${maxDeg} yes") } else { println("${maxDeg} no") }
    var sb = StringBuilder()
    for (i in 0..order.size) {
        if (i>0) { sb.append(" ") }
        sb.append("${order[i]}")
    }
    println(sb.toString())
}
