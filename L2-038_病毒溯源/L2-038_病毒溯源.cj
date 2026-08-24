// L2-038 病毒溯源 - 最长变异链，字典序最小
import std.env.*
import std.collection.*
import std.convert.*
import std.sort.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size == 0) { return }
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
    var adj = Array<ArrayList<Int64>>(N, repeat: ArrayList<Int64>())
    for (i in 0..N) { adj[i]=ArrayList<Int64>() }
    var indeg = Array<Int64>(N, repeat: 0)
    for (i in 0..N) {
        let k = Int64.parse(toks[p]); p+=1
        for (j in 0..k) {
            let ch = Int64.parse(toks[p]); p+=1
            adj[i].add(ch)
            indeg[ch]+=1
        }
    }
    for (i in 0..N) { sort(adj[i]) }
    var root: Int64 = 0
    for (i in 0..N) { if (indeg[i]==0) { root=i; break } }
    var best = ArrayList<Int64>()
    var curPath = ArrayList<Int64>()
    var stackNode = ArrayList<Int64>()
    var stackIdx = ArrayList<Int64>()
    stackNode.add(root); stackIdx.add(0)
    curPath.add(root)
    if (adj[root].size==0) { best = ArrayList<Int64>(); for (x in curPath) { best.add(x) } }
    while (stackNode.size > 0) {
        let top = stackNode.size-1
        let node = stackNode[top]
        let idx = stackIdx[top]
        if (idx < adj[node].size) {
            let child = adj[node][idx]
            stackIdx[top] = idx+1
            stackNode.add(child); stackIdx.add(0)
            curPath.add(child)
        } else {
            if (adj[node].size==0) {
                if (curPath.size > best.size) {
                    best = ArrayList<Int64>()
                    for (x in curPath) { best.add(x) }
                } else if (curPath.size == best.size && curPath.size>0) {
                    var smaller = false
                    var larger = false
                    for (k in 0..curPath.size) {
                        let a = curPath[k]; let b = best[k]
                        if (a < b) { smaller=true; break }
                        if (a > b) { larger=true; break }
                    }
                    if (smaller) {
                        best = ArrayList<Int64>()
                        for (x in curPath) { best.add(x) }
                    }
                }
            }
            stackNode.remove(top..top+1); stackIdx.remove(top..top+1)
            curPath.remove((curPath.size-1)..curPath.size)
        }
    }
    println("${best.size}")
    var sb = StringBuilder()
    for (i in 0..best.size) {
        if (i>0) { sb.append(" ") }
        sb.append("${best[i]}")
    }
    println(sb.toString())
}
