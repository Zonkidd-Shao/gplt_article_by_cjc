// L2-036 网红点打卡攻略 - Floyd最短路+攻略检验
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size == 0) { return }
    var toks = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s == " " || s == "\n" || s == "\r" || s == "\t") {
            if (cur.toString().size > 0) { toks.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(s) }
    }
    if (cur.toString().size > 0) { toks.add(cur.toString()) }
    var p: Int64 = 0
    let N = Int64.parse(toks[p]); p+=1
    let M = Int64.parse(toks[p]); p+=1
    let SZ = N+1
    let INF: Int64 = 1000000000000
    var dist = Array<Array<Int64>>(SZ, repeat: Array<Int64>(0, repeat: 0))
    for (i in 0..SZ) { dist[i]=Array<Int64>(SZ, repeat: INF); dist[i][i]=0 }
    for (i in 0..M) {
        let a = Int64.parse(toks[p]); let b = Int64.parse(toks[p+1]); let c = Int64.parse(toks[p+2]); p+=3
        if (c < dist[a][b]) {
            dist[a][b]=c; dist[b][a]=c
        }
    }
    // no Floyd, direct edges only
    let K = Int64.parse(toks[p]); p+=1
    var validCnt: Int64 = 0
    var bestIdx: Int64 = 0
    var bestCost: Int64 = INF
    for (idx in 1..=K) {
        if (p >= toks.size) { break }
        let n = Int64.parse(toks[p]); p+=1
        var path = Array<Int64>(n, repeat: 0)
        for (i in 0..n) {
            if (p < toks.size) { path[i]=Int64.parse(toks[p]); p+=1 } else { path[i]=0 }
        }
        if (n != N) { continue }
        // check distinct and range 1..N
        var seen = HashSet<Int64>()
        var ok = true
        for (v in path) {
            if (v < 1 || v > N) { ok=false; break }
            if (seen.contains(v)) { ok=false; break }
            seen.add(v)
        }
        if (!ok) { continue }
        // check connectivity via INF (if any segment INF -> invalid)
        var cost: Int64 = 0
        var conn = true
        let first = path[0]
        if (dist[0][first] >= INF) { conn=false } else { cost+=dist[0][first] }
        for (i in 1..n) {
            if (!conn) { break }
            let u = path[i-1]; let v = path[i]
            if (dist[u][v] >= INF) { conn=false; break }
            cost+=dist[u][v]
        }
        let last = path[n-1]
        if (conn && dist[last][0] >= INF) { conn=false }
        if (conn) { cost+=dist[last][0] } else { continue }
        // valid
        validCnt+=1
        if (cost < bestCost) {
            bestCost=cost; bestIdx=idx
        }
    }
    println("${validCnt}")
    println("${bestIdx} ${bestCost}")
}
