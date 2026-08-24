// L2-043 龙龙送外卖 - 树上增量 Steiner
import std.env.*
import std.collection.*
import std.convert.*

func find(par: Array<Int64>, x: Int64): Int64 {
    var cur = x
    while (par[cur] != cur) {
        par[cur] = par[par[cur]]
        cur = par[cur]
    }
    return cur
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var toks = ArrayList<String>()
    var curSb = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s==" "||s=="\n"||s=="\r"||s=="\t") {
            if (curSb.toString().size>0) { toks.add(curSb.toString()); curSb=StringBuilder() }
        } else { curSb.append(s) }
    }
    if (curSb.toString().size>0) { toks.add(curSb.toString()) }
    var p: Int64 = 0
    let N = Int64.parse(toks[p]); p+=1
    let M = Int64.parse(toks[p]); p+=1
    var parent = Array<Int64>(N+1, repeat: 0)
    var root: Int64 = 1
    for (i in 1..=N) {
        let pr = Int64.parse(toks[p]); p+=1
        if (pr == -1) { root=i; parent[i]=i } else { parent[i]=pr }
        // store for DSU find? we use parentTree separately
    }
    // depth via BFS from root
    var children = Array<ArrayList<Int64>>(N+1, repeat: ArrayList<Int64>())
    for (i in 1..=N) { children[i]=ArrayList<Int64>() }
    for (i in 1..=N) {
        if (i==root) { continue }
        let pr = parent[i]
        if (pr>=1 && pr<=N) { children[pr].add(i) }
    }
    var depth = Array<Int64>(N+1, repeat: 0)
    var stack = ArrayList<Int64>(); stack.add(root)
    var visited = Array<Bool>(N+1, repeat: false)
    visited[root]=true
    var q = ArrayList<Int64>(); q.add(root)
    var qhead: Int64 = 0
    while (qhead < q.size) {
        let u = q[qhead]; qhead+=1
        for (v in children[u]) {
            depth[v]=depth[u]+1
            q.add(v)
        }
    }
    // DSU for uncovered edges
    var dsu = Array<Int64>(N+1, repeat: 0)
    for (i in 0..N) { dsu[i]=i }
    // helper find with path compression iterative
    var isMarked = Array<Bool>(N+1, repeat: false)
    isMarked[root]=true // root considered visited for edge counting? we count edges of non-root nodes only
    // Actually mark root as visited so its edge not counted
    // For DSU, root's parent is itself
    var total: Int64 = 0
    var maxDepth: Int64 = 0
    var out = StringBuilder()
    // need parentTree for DSU jumps: parentTree[i]
    var treePar = Array<Int64>(N+1, repeat: 0)
    for (i in 1..=N) { treePar[i]=parent[i] }
    treePar[root]=root

    func findRep(x: Int64): Int64 {
        var r = x
        while (dsu[r] != r) { r = dsu[r] }
        // path compress
        var cur2 = x
        while (dsu[cur2] != r) {
            let nxt = dsu[cur2]
            dsu[cur2]=r
            cur2=nxt
        }
        return r
    }

    for (i in 0..M) {
        if (p >= toks.size) { break }
        let x = Int64.parse(toks[p]); p+=1
        if (!isMarked[x]) {
            isMarked[x]=true
            if (depth[x] > maxDepth) { maxDepth = depth[x] }
            var curNode = findRep(x)
            while (curNode != root) {
                total+=1
                dsu[curNode]=findRep(treePar[curNode])
                curNode = dsu[curNode]
            }
        }
        let ans = total*2 - maxDepth
        out.append("${ans}\n")
    }
    print(out.toString())
}
