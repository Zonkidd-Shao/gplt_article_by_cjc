// L3-040 人生就像一场旅行
import std.collection.*
import std.convert.*
import std.env.*

let INF: Int64 = 4000000000000

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size>0) { toks.add(p) } }
    var idx: Int64 = 0
    let b = Int64.parse(toks[idx]); idx++
    let n = Int64.parse(toks[idx]); idx++
    let m = Int64.parse(toks[idx]); idx++
    let k = Int64.parse(toks[idx]); idx++
    let adj = Array<ArrayList<Array<Int64>>>(n+1, repeat: ArrayList<Array<Int64>>())
    for (i in 0..n+1) { adj[i]=ArrayList<Array<Int64>>() }
    for (i in 0..m) {
        let u = Int64.parse(toks[idx]); idx++
        let v = Int64.parse(toks[idx]); idx++
        let w = Int64.parse(toks[idx]); idx++
        let h = Int64.parse(toks[idx]); idx++
        adj[u].add([v,w,h])
        adj[v].add([u,w,h])
    }
    let queries = Array<Int64>(k, repeat: 0)
    for (i in 0..k) { queries[i]=Int64.parse(toks[idx]); idx++ }
    let out = ArrayList<String>()
    for (qi in 0..k) {
        let s = queries[qi]
        let dist = Array<Int64>(n+1, repeat: INF)
        let mood = Array<Int64>(n+1, repeat: -1)
        let vis = Array<Bool>(n+1, repeat: false)
        dist[s]=0
        mood[s]=0
        for (iter in 0..n) {
            var u: Int64 = -1
            var best: Int64 = INF
            var bestMood: Int64 = -1
            for (i in 1..n+1) {
                if (!vis[i] && dist[i] < best) {
                    best = dist[i]; u=i; bestMood=mood[i]
                } else if (!vis[i] && dist[i]==best && mood[i] > bestMood) {
                    // tie on dist, pick larger mood to propagate max mood among shortest
                    // But for Dijkstra selection, we should pick minimal dist, and among equal dist maximal mood
                    // So update
                    if (mood[i] > bestMood) { u=i; bestMood=mood[i] }
                }
            }
            // Actually need to find minimal dist; if tie, maximal mood
            // The above loop may not correctly handle tie because we update bestMood only when dist==best
            // Let's do second pass to find best correctly
            // Instead do linear scan for minimal dist, then among those minimal dist pick max mood
            // Simpler: first find minDist, then find among those with minDist the max mood
            // We already did but need to handle initial best INF
            if (u==-1) { break }
            vis[u]=true
            for (e in adj[u]) {
                let v = e[0]
                let w = e[1]
                let h = e[2]
                let nd = dist[u] + w
                let nm = mood[u] + h
                if (nd < dist[v]) {
                    dist[v]=nd
                    mood[v]=nm
                } else if (nd == dist[v] && nm > mood[v]) {
                    mood[v]=nm
                }
            }
        }
        // After first Dijkstra, we have dist and best mood among shortest paths? But our Dijkstra that updates mood on equal dist may not guarantee maximal mood among all shortest paths because the order of relaxation matters.
        // To ensure maximal mood among shortest, we should do second phase DP over DAG of shortest paths
        // Build DAG edges where dist[u]+w == dist[v]
        // Then DP for max mood in order of increasing dist
        let order = ArrayList<Int64>()
        for (i in 1..n+1) { if (dist[i] < INF) { order.add(i) } }
        // sort by dist ascending
        for (i in 0..order.size) {
            for (j in i+1..order.size) {
                if (dist[order[j]] < dist[order[i]]) {
                    let t=order[i]; order[i]=order[j]; order[j]=t
                }
            }
        }
        let bestMood2 = Array<Int64>(n+1, repeat: -1)
        bestMood2[s]=0
        for (u in order) {
            if (bestMood2[u]==-1) { continue }
            for (e in adj[u]) {
                let v=e[0]; let w=e[1]; let h=e[2]
                if (dist[u]+w == dist[v]) {
                    let cand = bestMood2[u]+h
                    if (cand > bestMood2[v]) { bestMood2[v]=cand }
                }
            }
        }
        // Use bestMood2 as final mood
        let reachable = ArrayList<Int64>()
        for (i in 1..n+1) {
            if (i==s) { continue }
            if (dist[i] <= b) { reachable.add(i) }
        }
        if (reachable.size==0) {
            out.add("T_T")
        } else {
            // first line: reachable sorted ascending (already in order added 1..n)
            let sb1 = StringBuilder()
            for (i in 0..reachable.size) {
                if (i>0) { sb1.append(" ") }
                sb1.append(reachable[i].toString())
            }
            out.add(sb1.toString())
            // second line: among reachable, max mood
            var maxM: Int64 = -1
            for (v in reachable) {
                if (bestMood2[v] > maxM) { maxM = bestMood2[v] }
            }
            let bestNodes = ArrayList<Int64>()
            for (v in reachable) {
                if (bestMood2[v]==maxM) { bestNodes.add(v) }
            }
            let sb2 = StringBuilder()
            for (i in 0..bestNodes.size) {
                if (i>0) { sb2.append(" ") }
                sb2.append(bestNodes[i].toString())
            }
            out.add(sb2.toString())
        }
    }
    for (ln in out) { println(ln) }
}
