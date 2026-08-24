// L3-038 工业园区建设 - 仓库选址
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
    let T = Int64.parse(toks[idx]); idx++
    let outLines = ArrayList<String>()
    for (tc in 0..T) {
        let N = Int64.parse(toks[idx]); idx++
        let M = Int64.parse(toks[idx]); idx++
        let k = Int64.parse(toks[idx]); idx++
        let S = toks[idx]; idx++
        let isE = Array<Bool>(N+2, repeat: false)
        for (i in 1..N+1) {
            let ch = S[i-1]
            if (ch == UInt8(49)) { isE[i]=true }
        }
        let cntE = Array<Int64>(N+2, repeat: 0)
        let sumE = Array<Int64>(N+2, repeat: 0)
        for (i in 1..N+1) {
            cntE[i]=cntE[i-1] + (if (isE[i]) {1} else {0})
            sumE[i]=sumE[i-1] + (if (isE[i]) {i} else {0})
        }
        let cntZ = Array<Int64>(N+2, repeat: 0)
        let sumZ = Array<Int64>(N+2, repeat: 0)
        for (i in 1..N+1) {
            cntZ[i]=cntZ[i-1] + (if (!isE[i]) {1} else {0})
            sumZ[i]=sumZ[i-1] + (if (!isE[i]) {i} else {0})
        }
        var zTotal: Int64 = 0
        for (i in 1..N+1) { if (!isE[i]) { zTotal++ } }
        let limit = if (zTotal < M) { zTotal } else { M }
        let answers = Array<Int64>(N, repeat: 0)
        for (pos in 1..N+1) {
            var T_M: Int64 = 1000000000
            if (limit > 0) {
                var lo: Int64 = 0
                var hi: Int64 = N
                while (lo < hi) {
                    let mid = (lo+hi)/2
                    var l = pos - mid
                    var r = pos + mid
                    if (l<1) { l=1 }
                    if (r> N) { r=N }
                    var cnt: Int64 = 0
                    if (l<=r) { cnt = cntZ[r]-cntZ[l-1] }
                    if (cnt >= limit) { hi=mid } else { lo=mid+1 }
                }
                T_M = lo
            }
            var lo2: Int64 = 0
            var hi2: Int64 = N
            while (lo2 < hi2) {
                let mid = (lo2+hi2)/2
                var l = pos - mid
                var r = pos + mid
                if (l<1) { l=1 }
                if (r> N) { r=N }
                var cntE2: Int64 = 0
                var cntZ2: Int64 = 0
                if (l<=r) {
                    cntE2 = cntE[r]-cntE[l-1]
                    cntZ2 = cntZ[r]-cntZ[l-1]
                }
                let c = cntE2 + (if (cntZ2 < limit) {cntZ2} else {limit})
                if (c >= k) { hi2=mid } else { lo2=mid+1 }
            }
            let D = lo2
            // S_E
            var cntE_D: Int64 = 0
            var sumDistE_D: Int64 = 0
            if (D > 0) {
                var l = pos - D + 1
                var r = pos + D - 1
                if (l<1) { l=1 }
                if (r> N) { r=N }
                if (l<=r) {
                    var cl: Int64 = 0
                    var sl: Int64 = 0
                    var cr: Int64 = 0
                    var sr: Int64 = 0
                    var cntMid: Int64 = 0
                    if (l <= pos-1) {
                        let ll = l
                        let rr = pos-1
                        cl = cntE[rr]-cntE[ll-1]
                        sl = sumE[rr]-sumE[ll-1]
                    }
                    if (pos+1 <= r) {
                        let ll = pos+1
                        let rr = r
                        cr = cntE[rr]-cntE[ll-1]
                        sr = sumE[rr]-sumE[ll-1]
                    }
                    if (isE[pos]) { cntMid=1 }
                    cntE_D = cl+cr+cntMid
                    sumDistE_D = pos*cl - sl + sr - pos*cr
                }
            }
            let S_E = cntE_D * D - sumDistE_D
            var S_Z: Int64 = 0
            if (limit==0) {
                S_Z=0
            } else if (D <= T_M) {
                var l = pos - D + 1
                var r = pos + D - 1
                if (l<1) { l=1 }
                if (r> N) { r=N }
                var cl: Int64 = 0
                var sl: Int64 = 0
                var cr: Int64 = 0
                var sr: Int64 = 0
                var cntMid: Int64 = 0
                if (l <= pos-1) {
                    let ll=l
                    let rr=pos-1
                    cl=cntZ[rr]-cntZ[ll-1]
                    sl=sumZ[rr]-sumZ[ll-1]
                }
                if (pos+1 <= r) {
                    let ll=pos+1
                    let rr=r
                    cr=cntZ[rr]-cntZ[ll-1]
                    sr=sumZ[rr]-sumZ[ll-1]
                }
                if (!isE[pos]) { cntMid=1 }
                let cntZ_D = cl+cr+cntMid
                let sumDistZ_D = pos*cl - sl + sr - pos*cr
                S_Z = cntZ_D * D - sumDistZ_D
            } else {
                var l = pos - T_M + 1
                var r = pos + T_M - 1
                if (l<1) { l=1 }
                if (r> N) { r=N }
                var cl: Int64 = 0
                var sl: Int64 = 0
                var cr: Int64 = 0
                var sr: Int64 = 0
                var cntMid: Int64 = 0
                if (l <= pos-1) {
                    let ll=l
                    let rr=pos-1
                    cl=cntZ[rr]-cntZ[ll-1]
                    sl=sumZ[rr]-sumZ[ll-1]
                }
                if (pos+1 <= r) {
                    let ll=pos+1
                    let rr=r
                    cr=cntZ[rr]-cntZ[ll-1]
                    sr=sumZ[rr]-sumZ[ll-1]
                }
                if (!isE[pos]) { cntMid=1 }
                let cntZ_T = cl+cr+cntMid
                let sumDistZ_T = pos*cl - sl + sr - pos*cr
                S_Z = cntZ_T * T_M - sumDistZ_T + (D - T_M)*limit
            }
            let sumC = S_E + S_Z
            let ans = D * k - sumC
            answers[pos-1]=ans
        }
        let sb = StringBuilder()
        for (i in 0..N) {
            if (i>0) { sb.append(" ") }
            sb.append(answers[i].toString())
        }
        outLines.add(sb.toString())
    }
    for (ln in outLines) { println(ln) }
}
