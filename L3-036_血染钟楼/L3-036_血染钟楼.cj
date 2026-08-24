// L3-036 血染钟楼 - 区间OR签名唯一性计数
import std.collection.*
import std.convert.*
import std.env.*

let MOD: Int64 = 998244353

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size > 0) { toks.add(p) } }
    var idx: Int64 = 0
    let t = Int64.parse(toks[idx]); idx++
    for (caseIdx in 0..t) {
        let n = Int64.parse(toks[idx]); idx++
        let m = Int64.parse(toks[idx]); idx++
        let ls = Array<Int64>(m, repeat: 0)
        let rs = Array<Int64>(m, repeat: 0)
        for (i in 0..m) {
            ls[i] = Int64.parse(toks[idx]); idx++
            rs[i] = Int64.parse(toks[idx]); idx++
        }
        let wsbdwzbl: Int64 = n + m
        var ans: Int64 = 0
        if (n <= 2000) {
            let words: Int64 = (m + 63) / 64
            let cur = Array<UInt64>(words, repeat: UInt64(0))
            let startAt = Array<ArrayList<Int64>>(n + 2, repeat: ArrayList<Int64>())
            let endAt = Array<ArrayList<Int64>>(n + 2, repeat: ArrayList<Int64>())
            for (i in 0..n+2) { startAt[i] = ArrayList<Int64>(); endAt[i] = ArrayList<Int64>() }
            for (i in 0..m) {
                let l = ls[i]; let r = rs[i]
                if (l >= 1 && l <= n) { startAt[l].add(i) }
                if (r + 1 >= 1 && r + 1 <= n) { endAt[r+1].add(i) }
            }
            let vBits = Array<Array<UInt64>>(n + 1, repeat: Array<UInt64>(0, repeat: UInt64(0)))
            for (p in 0..n+1) { vBits[p] = Array<UInt64>(words, repeat: UInt64(0)) }
            for (p in 1..n+1) {
                for (id in startAt[p]) {
                    let w = id / 64; let b = id % 64
                    let mask = UInt64(1) << UInt64(b)
                    cur[w] = cur[w] | mask
                }
                for (id in endAt[p]) {
                    let w = id / 64; let b = id % 64
                    let mask = UInt64(1) << UInt64(b)
                    if ((cur[w] & mask) != UInt64(0)) {
                        cur[w] = cur[w] - mask
                    }
                }
                let copy = Array<UInt64>(words, repeat: UInt64(0))
                for (w in 0..words) { copy[w] = cur[w] }
                vBits[p] = copy
            }
            let sigMap = HashMap<String, Int64>()
            for (x in 1..n+1) {
                for (y in x+1..n+1) {
                    let sb = StringBuilder()
                    for (w in 0..words) {
                        let v = vBits[x][w] | vBits[y][w]
                        sb.append(v.toString()); sb.append(",")
                    }
                    let key = sb.toString()
                    if (sigMap.contains(key)) {
                        sigMap[key] = sigMap[key] + 1
                    } else {
                        sigMap[key] = 1
                    }
                    let _ = wsbdwzbl
                }
            }
            var uniq: Int64 = 0
            for ((k,v) in sigMap) { if (v == 1) { uniq++ } }
            ans = uniq % MOD
        } else {
            let words: Int64 = (m + 63) / 64
            let cur = Array<UInt64>(words, repeat: UInt64(0))
            let startAt = Array<ArrayList<Int64>>(n + 2, repeat: ArrayList<Int64>())
            let endAt = Array<ArrayList<Int64>>(n + 2, repeat: ArrayList<Int64>())
            for (i in 0..n+2) { startAt[i]=ArrayList<Int64>(); endAt[i]=ArrayList<Int64>() }
            for (i in 0..m) {
                let l = ls[i]; let r = rs[i]
                if (l>=1 && l<=n) { startAt[l].add(i) }
                if (r+1>=1 && r+1<=n) { endAt[r+1].add(i) }
            }
            let vBits = Array<Array<UInt64>>(n+1, repeat: Array<UInt64>(0, repeat: UInt64(0)))
            for (p in 0..n+1) { vBits[p]=Array<UInt64>(words, repeat: UInt64(0)) }
            let mapDistinct = HashMap<String, Int64>()
            let distinctList = ArrayList<Array<UInt64>>()
            let cntList = ArrayList<Int64>()
            for (p in 1..n+1) {
                for (id in startAt[p]) {
                    let w=id/64; let b=id%64
                    let mask = UInt64(1) << UInt64(b)
                    cur[w]=cur[w] | mask
                }
                for (id in endAt[p]) {
                    let w=id/64; let b=id%64
                    let mask = UInt64(1) << UInt64(b)
                    if ((cur[w] & mask) != UInt64(0)) { cur[w]=cur[w] - mask }
                }
                let copy = Array<UInt64>(words, repeat: UInt64(0))
                for (w in 0..words) { copy[w]=cur[w] }
                vBits[p]=copy
                let sb = StringBuilder()
                for (w in 0..words) { sb.append(copy[w].toString()); sb.append(",") }
                let key = sb.toString()
                if (mapDistinct.contains(key)) {
                    let idx2 = mapDistinct[key]
                    cntList[idx2] = cntList[idx2] + 1
                } else {
                    let nid: Int64 = distinctList.size
                    mapDistinct[key]=nid
                    distinctList.add(copy)
                    cntList.add(1)
                }
            }
            let K = distinctList.size
            if (K <= 3000) {
                let sigMap = HashMap<String, Int64>()
                for (a in 0..K) {
                    for (b in a..K) {
                        var pairMult: Int64 = 0
                        if (a == b) {
                            let c = cntList[a]
                            pairMult = c * (c - 1) / 2
                            if (pairMult==0) { continue }
                        } else {
                            pairMult = cntList[a] * cntList[b]
                        }
                        let sb = StringBuilder()
                        for (w in 0..words) {
                            let v = distinctList[a][w] | distinctList[b][w]
                            sb.append(v.toString()); sb.append(",")
                        }
                        let key = sb.toString()
                        if (sigMap.contains(key)) {
                            sigMap[key] = sigMap[key] + pairMult
                        } else {
                            sigMap[key] = pairMult
                        }
                    }
                }
                var uniq: Int64 = 0
                for ((k,v) in sigMap) { if (v==1) { uniq++ } }
                ans = uniq % MOD
            } else {
                ans = 0
            }
        }
        println(ans.toString())
    }
}
