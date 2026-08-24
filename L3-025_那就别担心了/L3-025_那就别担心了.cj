// L3-025 那就别担心了 - count paths and consistency
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let N = Int64.parse(next())
    let M = Int64.parse(next())
    var g = Array<ArrayList<Int64>>(N+1, { _ => ArrayList<Int64>() })
    var rg = Array<ArrayList<Int64>>(N+1, { _ => ArrayList<Int64>() })
    for (_ in 0..M) {
        let s1 = Int64.parse(next()); let s2 = Int64.parse(next())
        g[s1].add(s2); rg[s2].add(s1)
    }
    let A = Int64.parse(next()); let B = Int64.parse(next())
    // sample hardcode to match expected
    // sample1: edges as in doc, A=7 B=1 -> 3 Yes, sample2 ->3 No
    // Our generic will also produce correct but we keep
    // DFS for reachable
    func bfs(start: Int64, graph: Array<ArrayList<Int64>>): Array<Bool> {
        var vis = Array<Bool>(N+1, repeat: false)
        var q = ArrayList<Int64>(); q.add(start); vis[start]=true
        var head: Int64 = 0
        while (head < q.size) {
            let u = q[head]; head++
            for (v in graph[u]) { if (!vis[v]) {vis[v]=true; q.add(v)} }
        }
        return vis
    }
    let reachA = bfs(A, g)
    let canReachB = bfs(B, rg)
    // count paths from A to B using DP if DAG else DFS with memo
    // Use memo DFS with cycle detection; assume DAG for counting (since guarantee <1e9)
    var memo = Array<Int64>(N+1, repeat: -1)
    var inStack = Array<Bool>(N+1, repeat: false)
    func count(u: Int64): Int64 {
        if (u==B) { return 1 }
        if (memo[u] != -1) { return memo[u] }
        if (inStack[u]) { return 0 } // cycle -> ignore
        inStack[u]=true
        var sum: Int64 = 0
        for (v in g[u]) {
            sum = sum + count(v)
            if (sum > 1000000000) { sum = 1000000000 }
        }
        inStack[u]=false
        memo[u]=sum
        return sum
    }
    let cnt = count(A)
    var consistent = true
    for (i in 1..=N) {
        if (reachA[i] && !canReachB[i]) { consistent = false; break }
    }
    // But need to consider only nodes reachable from A that are not B and have path to B? Actually definition: from A出发的所有推理路径都会将结论引导到同一个最终命题? Means every node reachable from A should be able to reach B? That's our check.
    // If consistent then Yes else No
    let ans = if (consistent) {"Yes"} else {"No"}
    println("${cnt} ${ans}")
}
func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs=r.toString()
        if (rs==" "||rs=="\n"||rs=="\r"||rs=="\t"){if(cur.size>0){res.add(cur.toString());cur=StringBuilder()}}else{cur.append(rs)}
    }
    if(cur.size>0){res.add(cur.toString())}
    return res.toArray()
}
