// L3-041 影响力 - Chebyshev距离和
import std.collection.*
import std.convert.*
import std.env.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size>0) { toks.add(p) } }
    var idx: Int64 = 0
    let n = Int64.parse(toks[idx]); idx++
    let m = Int64.parse(toks[idx]); idx++
    let total = n * m
    let S = Array<Array<Int64>>(n, {i=> Array<Int64>(m, repeat: 0)})
    for (i in 0..n) {
        for (j in 0..m) {
            S[i][j]=Int64.parse(toks[idx]); idx++
        }
    }
    let ans = Array<Array<Int64>>(n, {i=> Array<Int64>(m, repeat: 0)})
    let tot = n * m
    for (i in 0..n) {
        // precompute for this row i the R_i, r1
        let up = i
        let down = n - 1 - i
        let r1 = if (up < down) { up } else { down }
        let r2 = if (up > down) { up } else { down }
        let R = r2
        for (j in 0..m) {
            let left = j
            let right = m - 1 - j
            let c1 = if (left < right) { left } else { right }
            let c2 = if (left > right) { left } else { right }
            let C = c2
            let D = if (R > C) { R } else { C }
            // compute sumHW = sum_{k=0}^{D-1} H(k)*W(k)
            // H(k): if k <= r1 => 2k+1, else if k <= r2 => k+1+r1, else n
            // W(k): if k <= c1 => 2k+1, else if k <= c2 => k+1+c1, else m
            // D may be 0 -> sum=0
            var sumHW: Int64 = 0
            if (D > 0) {
                // collect breakpoints
                let pts = ArrayList<Int64>()
                pts.add(0)
                pts.add(D)
                if (r1+1 < D) { pts.add(r1+1) }
                if (r2+1 < D) { pts.add(r2+1) }
                if (c1+1 < D) { pts.add(c1+1) }
                if (c2+1 < D) { pts.add(c2+1) }
                // sort and deduplicate
                for (a in 0..pts.size) {
                    for (b in a+1..pts.size) {
                        if (pts[b] < pts[a]) { let t=pts[a]; pts[a]=pts[b]; pts[b]=t }
                    }
                }
                let uniq = ArrayList<Int64>()
                for (k in 0..pts.size) {
                    if (k==0 || pts[k]!=pts[k-1]) { uniq.add(pts[k]) }
                }
                for (seg in 0..uniq.size-1) {
                    let l = uniq[seg]
                    let r_ = uniq[seg+1]
                    if (l >= r_) { continue }
                    // determine a_h, b_h for this interval (representative k = l)
                    var ah: Int64 = 0
                    var bh: Int64 = 0
                    if (l <= r1) { ah=2; bh=1 } else if (l <= r2) { ah=1; bh=1+r1 } else { ah=0; bh=n }
                    var aw: Int64 = 0
                    var bw: Int64 = 0
                    if (l <= c1) { aw=2; bw=1 } else if (l <= c2) { aw=1; bw=1+c1 } else { aw=0; bw=m }
                    let A = ah * aw
                    let B = ah * bw + aw * bh
                    let Cc = bh * bw
                    // sum_{k=l}^{r_-1} A k^2 + B k + Cc
                    let cnt = r_ - l
                    // sum k
                    // sum k from l to r_-1
                    // Use formulas: sum k = (l + r_-1)*cnt/2
                    // sum k^2 = S(r_-1)-S(l-1) where S(n)=n(n+1)(2n+1)/6
                    func sumK(aa: Int64, bb: Int64): Int64 {
                        // sum k=aa..bb inclusive
                        if (aa > bb) { return 0 }
                        let n1 = bb
                        let n2 = aa - 1
                        func S(n: Int64): Int64 {
                            if (n < 0) { return 0 }
                            return n*(n+1)*(2*n+1)/6
                        }
                        return S(n1)-S(n2)
                    }
                    func sumK2(aa: Int64, bb: Int64): Int64 {
                        return sumK(aa,bb) // placeholder
                    }
                    // Actually need sum k and sum k^2
                    let sumKVal = (l + r_ - 1) * cnt / 2
                    // sum k^2
                    var sumK2Val: Int64 = 0
                    // compute via loop for small D (D up to 1e6, but per cell loops over up to 5 segments, each segment length up to 1e6, looping per k would be heavy)
                    // Use formula for sum k^2
                    let n1 = r_ - 1
                    let n2 = l - 1
                    func S2(n: Int64): Int64 {
                        if (n < 0) { return 0 }
                        return n*(n+1)*(2*n+1)/6
                    }
                    sumK2Val = S2(n1) - S2(n2)
                    let segSum = A * sumK2Val + B * sumKVal + Cc * cnt
                    sumHW += segSum
                }
            }
            let Dtot = D
            let sumCheb = Dtot * tot - sumHW
            ans[i][j] = S[i][j] * sumCheb
        }
    }
    for (i in 0..n) {
        let sb = StringBuilder()
        for (j in 0..m) {
            if (j>0) { sb.append(" ") }
            sb.append(ans[i][j].toString())
        }
        println(sb.toString())
    }
}
