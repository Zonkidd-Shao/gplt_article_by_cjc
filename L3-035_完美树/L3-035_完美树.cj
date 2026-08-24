// L3-035 完美树 - 最小代价使所有子树黑白平衡
import std.collection.*
import std.convert.*
import std.env.*

let INF: Int64 = 4000000000000000000

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size>0) { toks.add(p) } }
    var idx: Int64 = 0
    let N = Int64.parse(toks[idx]); idx++
    let C = Array<Int64>(N+1, repeat: 0)
    let P = Array<Int64>(N+1, repeat: 0)
    let children = Array<ArrayList<Int64>>(N+1, repeat: ArrayList<Int64>())
    for (i in 0..N+1) { children[i]=ArrayList<Int64>() }
    for (i in 1..N+1) {
        let ci = Int64.parse(toks[idx]); idx++
        let pi = Int64.parse(toks[idx]); idx++
        let ki = Int64.parse(toks[idx]); idx++
        C[i]=ci
        P[i]=pi
        for (j in 0..ki) {
            let ch = Int64.parse(toks[idx]); idx++
            children[i].add(ch)
        }
    }
    let szArr = Array<Int64>(N+1, repeat: 0)
    let dp0 = Array<Int64>(N+1, repeat: INF)
    let dp1 = Array<Int64>(N+1, repeat: INF)
    let q = ArrayList<Int64>()
    q.add(1)
    let bfsOrder = ArrayList<Int64>()
    var qhead: Int64 = 0
    while (qhead < Int64(q.size)) {
        let u = q[qhead]; qhead++
        bfsOrder.add(u)
        for (v in children[u]) {
            q.add(v)
        }
    }
    let depth = Array<Int64>(N+1, repeat: 0)
    for (u in bfsOrder) {
        for (v in children[u]) { depth[v]=depth[u]+1 }
    }
    let nodes = ArrayList<Int64>()
    for (i in 1..N+1) { nodes.add(i) }
    for (i in 0..nodes.size) {
        for (j in i+1..nodes.size) {
            if (depth[nodes[j]] > depth[nodes[i]]) {
                let t=nodes[i]; nodes[i]=nodes[j]; nodes[j]=t
            }
        }
    }
    for (u in nodes) {
        var sz: Int64 = 1
        for (v in children[u]) { sz += szArr[v] }
        szArr[u]=sz
        let need0 = sz / 2
        let need1 = (sz + 1) / 2
        var evenSum: Int64 = 0
        var evenCost: Int64 = 0
        var oddBaseSum: Int64 = 0
        var oddBaseCost: Int64 = 0
        let deltas = ArrayList<Int64>()
        for (v in children[u]) {
            let csz = szArr[v]
            if (csz % 2 == 0) {
                evenSum += csz / 2
                let c = if (dp0[v] < dp1[v]) { dp0[v] } else { dp1[v] }
                evenCost += c
            } else {
                let nd0 = csz / 2
                oddBaseSum += nd0
                oddBaseCost += dp0[v]
                deltas.add(dp1[v] - dp0[v])
            }
        }
        let baseSum = evenSum + oddBaseSum
        let baseCost = evenCost + oddBaseCost
        for (i in 0..deltas.size) {
            for (j in i+1..deltas.size) {
                if (deltas[j] < deltas[i]) {
                    let t=deltas[i]; deltas[i]=deltas[j]; deltas[j]=t
                }
            }
        }
        let pref = Array<Int64>(deltas.size+1, repeat: 0)
        for (i in 0..deltas.size) {
            pref[i+1]=pref[i]+deltas[i]
        }
        let oddCnt = Int64(deltas.size)
        func costFor(need: Int64): Int64 {
            var best: Int64 = INF
            for (col in 0..2) {
                let needSum = need - col
                if (needSum < baseSum || needSum > baseSum + oddCnt) { continue }
                let t = needSum - baseSum
                let cur = baseCost + pref[t] + (if (col==0) { if (C[u]==0) {0} else {P[u]} } else { if (C[u]==1) {0} else {P[u]} })
                if (cur < best) { best = cur }
            }
            return best
        }
        if (need0 == need1) {
            let c = costFor(need0)
            dp0[u]=c
            dp1[u]=c
        } else {
            dp0[u]=costFor(need0)
            dp1[u]=costFor(need1)
        }
    }
    let ans = if (dp0[1] < dp1[1]) { dp0[1] } else { dp1[1] }
    println(ans.toString())
}
