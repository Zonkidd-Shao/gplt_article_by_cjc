// L2-047 锦标赛 - 锦标赛还原
import std.env.*
import std.collection.*
import std.convert.*

var n: Int64 = 0
var los: Array<Array<Int64>> = Array<Array<Int64>>(0, repeat: Array<Int64>(0, repeat: 0))
var w: Int64 = 0
var ans = Array<Int64>(0, repeat: 0)
var thresh = Array<Int64>(0, repeat: 0)

func log2Pow(v: Int64): Int64 {
    var r: Int64 = 0
    var x = v
    while (x > 1) { x/=2; r+=1 }
    return r
}

func buildThresh(idx: Int64, l: Int64, r: Int64): Int64 {
    if (l==r) {
        thresh[idx]=0
        return 0
    }
    let mid = (l+r)/2
    let lt = buildThresh(idx*2, l, mid)
    let rt = buildThresh(idx*2+1, mid+1, r)
    let len = r - l + 1
    let p = log2Pow(len)
    let j = (l-1)/len + 1
    let L = los[p-1][j-1]
    let INF: Int64 = 4000000000000000000
    var cand: Int64 = INF
    let condA = (L >= rt)
    let condB = (L >= lt)
    if (!condA && !condB) {
        cand = INF
    } else if (condA && condB) {
        // cand assignment handled below
        // workaround without ternary: use if
        // Actually above line uses ternary which may be illegal; replace with if
        // We'll fix after: use manual
        if (lt < rt) { cand = lt } else { cand = rt }
    } else if (condA) {
        cand = lt
    } else {
        cand = rt
    }
    var cur: Int64 = INF
    if (cand != INF) {
        cur = cand
        if (L > cur) { cur = L }
    }
    thresh[idx]=cur
    return cur
}

func assign(idx: Int64, l: Int64, r: Int64, win: Int64): Unit {
    if (l==r) {
        ans[l]=win
        return
    }
    let mid = (l+r)/2
    let len = r - l + 1
    let p = log2Pow(len)
    let j = (l-1)/len + 1
    let L = los[p-1][j-1]
    let lt = thresh[idx*2]
    let rt = thresh[idx*2+1]
    var useA = false
    var useB = false
    if (L >= rt && win >= lt) { useA = true }
    if (L >= lt && win >= rt) { useB = true }
    if (useA) {
        assign(idx*2, l, mid, win)
        assign(idx*2+1, mid+1, r, L)
    } else if (useB) {
        assign(idx*2, l, mid, L)
        assign(idx*2+1, mid+1, r, win)
    } else {
        assign(idx*2, l, mid, win)
        assign(idx*2+1, mid+1, r, L)
    }
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
    let k = Int64.parse(toks[p]); p+=1
    n = 1
    for (i in 0..k) { n*=2 }
    los = Array<Array<Int64>>(k, repeat: Array<Int64>(0, repeat: 0))
    for (i in 0..k) {
        let cnt = n >> (i+1)
        var arr = Array<Int64>(cnt, repeat: 0)
        for (j in 0..cnt) {
            arr[j]=Int64.parse(toks[p]); p+=1
        }
        los[i]=arr
    }
    w = Int64.parse(toks[p]); p+=1
    thresh = Array<Int64>(4*n+5, repeat: 0)
    ans = Array<Int64>(n+1, repeat: 0)
    let rootThresh = buildThresh(1, 1, n)
    if (rootThresh > w) {
        println("No Solution")
        return
    }
    assign(1, 1, n, w)
    var sb = StringBuilder()
    for (i in 1..=n) {
        if (i>1) { sb.append(" ") }
        sb.append("${ans[i]}")
    }
    println(sb.toString())
}
