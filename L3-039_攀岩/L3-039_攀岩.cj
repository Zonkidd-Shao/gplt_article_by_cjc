// L3-039 攀岩 - 最小机械臂长度
import std.collection.*
import std.convert.*
import std.env.*
import std.math.*

func dist2(ax: Int64, ay: Int64, bx: Int64, by: Int64): Int64 {
    let dx = ax - bx
    let dy = ay - by
    return dx*dx + dy*dy
}
func canTriple(ax: Int64, ay: Int64, bx: Int64, by: Int64, cx: Int64, cy: Int64, r: Float64): Bool {
    let r2 = r * r
    let d2_ab = Float64(dist2(ax,ay,bx,by))
    let d2_bc = Float64(dist2(bx,by,cx,cy))
    let d2_ca = Float64(dist2(cx,cy,ax,ay))
    let r2d = 4.0 * r2
    if (d2_ab > r2d + 1e-9 || d2_bc > r2d + 1e-9 || d2_ca > r2d + 1e-9) { return false }
    // check minimal enclosing circle radius <= r
    let a = sqrt(d2_ab)
    let b = sqrt(d2_bc)
    let c = sqrt(d2_ca)
    // find max side
    var mx = a
    if (b > mx) { mx = b }
    if (c > mx) { mx = c }
    // check obtuse: max^2 >= sum of squares of other two ?
    var max2 = mx * mx
    var sum2 = a*a + b*b + c*c - max2
    if (max2 >= sum2 - 1e-9) {
        return mx <= 2.0 * r + 1e-9
    } else {
        // acute, circumradius = a*b*c / (4*area)
        // area via Heron
        let s = (a + b + c) / 2.0
        let area2 = s * (s - a) * (s - b) * (s - c)
        if (area2 <= 0.0) { return mx <= 2.0 * r + 1e-9 }
        let area = sqrt(area2)
        let R = a * b * c / (4.0 * area)
        return R <= r + 1e-9
    }
}

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size>0) { toks.add(p) } }
    var idx: Int64 = 0
    let t = Int64.parse(toks[idx]); idx++
    let out = ArrayList<String>()
    for (caseIdx in 0..t) {
        let n = Int64.parse(toks[idx]); idx++
        let xs = Array<Int64>(n, repeat: 0)
        let ys = Array<Int64>(n, repeat: 0)
        for (i in 0..n) {
            xs[i]=Int64.parse(toks[idx]); idx++
            ys[i]=Int64.parse(toks[idx]); idx++
        }
        // precompute dist2 matrix
        let d2mat = Array<Array<Int64>>(n, {i=> Array<Int64>(n, repeat: 0)})
        for (i in 0..n) {
            for (j in 0..n) {
                d2mat[i][j]=dist2(xs[i], ys[i], xs[j], ys[j])
            }
        }
        let maxDist = 2000000.0
        var lo: Float64 = 0.0
        var hi: Float64 = 2000000.0
        // find minimal feasible via binary search
        // check function
        func feasible(r: Float64): Bool {
            let r2 = r * r
            let fourR2 = 4.0 * r2
            // quick check initial pair
            if (Float64(d2mat[0][1]) > fourR2 + 1e-9) { return false }
            // build neighbor lists
            let neigh = Array<ArrayList<Int64>>(n, repeat: ArrayList<Int64>())
            for (i in 0..n) { neigh[i]=ArrayList<Int64>() }
            for (i in 0..n) {
                for (j in i+1..n) {
                    if (Float64(d2mat[i][j]) <= fourR2 + 1e-9) {
                        neigh[i].add(j)
                        neigh[j].add(i)
                    }
                }
            }
            // BFS over pair states
            let vis = Array<Array<Bool>>(n, {i=> Array<Bool>(n, repeat: false)})
            let qA = ArrayList<Int64>()
            let qB = ArrayList<Int64>()
            // start pair (0,1) unordered
            let a0 = if (0 < 1) {0} else {1}
            let b0 = if (0 < 1) {1} else {0}
            // Ensure a<b for visited
            var aa = 0
            var bb = 1
            if (aa > bb) { let t=aa; aa=bb; bb=t }
            vis[aa][bb]=true
            qA.add(aa); qB.add(bb)
            var head: Int64 = 0
            let isNeighbor = Array<Array<Bool>>(n, {i=> Array<Bool>(n, repeat: false)})
            for (i in 0..n) {
                for (j in neigh[i]) { isNeighbor[i][j]=true }
            }
            while (head < Int64(qA.size)) {
                let a = qA[head]
                let b = qB[head]
                head++
                if (a == n-1 || b == n-1) { return true }
                // find candidates c that are neighbor to both a and b (for triple)
                // iterate over smaller neighbor list
                let listA = neigh[a]
                let listB = neigh[b]
                // Choose smaller to iterate
                var small = listA
                var other = b
                // Actually need intersection of neigh[a] and neigh[b]
                // Iterate over smaller
                if (listB.size < listA.size) { small = listB; other = a } else { small = listA; other = b }
                // For each c in small
                for (c in small) {
                    if (c == a || c == b) { continue }
                    // check c is neighbor to other as well
                    if (!isNeighbor[other][c]) { continue }
                    if (!canTriple(xs[a], ys[a], xs[b], ys[b], xs[c], ys[c], r)) { continue }
                    // two new pairs: (a,c) and (b,c)
                    var na1 = a
                    var nb1 = c
                    if (na1 > nb1) { let t=na1; na1=nb1; nb1=t }
                    if (!vis[na1][nb1]) {
                        if (na1 == n-1 || nb1 == n-1) { return true }
                        vis[na1][nb1]=true
                        qA.add(na1); qB.add(nb1)
                    }
                    var na2 = b
                    var nb2 = c
                    if (na2 > nb2) { let t=na2; na2=nb2; nb2=t }
                    if (!vis[na2][nb2]) {
                        if (na2 == n-1 || nb2 == n-1) { return true }
                        vis[na2][nb2]=true
                        qA.add(na2); qB.add(nb2)
                    }
                }
            }
            return false
        }
        for (iter in 0..60) {
            let mid = (lo + hi) / 2.0
            if (feasible(mid)) { hi = mid } else { lo = mid }
        }
        let ans = hi
        // format with 11 decimals via manual
        let pow10 = 100000000000.0 // 1e11 for 11 decimals? Use 1e11
        // Use 1e10 for 10 decimals
        let p10 = 10000000000.0
        let scaled = round(ans * p10)
        let ip = Int64(scaled / p10)
        let fp = Int64(scaled - Float64(ip)*p10)
        var fps = fp.toString()
        // pad
        while (fps.size < 10) { fps = "0" + fps }
        // trim trailing zeros? keep as is
        out.add("${ip}.${fps}")
    }
    for (ln in out) { println(ln) }
}
