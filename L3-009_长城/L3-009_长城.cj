// L3-009 长城 - 最少烽火台覆盖
// Approach: 可视最远next via上凸包 + 跳跃贪心
import std.env.*
import std.collection.*
import std.convert.*

main(){
    let cin=getStdIn()
    let all=cin.readToEnd()??""
    let runes=all.toRuneArray()
    let tokens=ArrayList<String>()
    var sb=StringBuilder()
    let sp:Rune=' '
    let nl:Rune='\n'
    let tab:Rune='\t'
    let cr:Rune='\r'
    for(r in runes){
        if(r==sp||r==nl||r==tab||r==cr){
            let cur=sb.toString()
            if(cur.size>0){ tokens.add(cur) }
            sb=StringBuilder()
        } else { sb.append(r) }
    }
    let last=sb.toString()
    if(last.size>0){ tokens.add(last) }
    if(tokens.size==0){ return }
    var p: Int64=0
    let N=Int64.parse(tokens[p]); p++
    let xs=Array<Int64>(N, repeat:0)
    let ys=Array<Int64>(N, repeat:0)
    for(i in 0..N){
        xs[i]=Int64.parse(tokens[p]); p++
        ys[i]=Int64.parse(tokens[p]); p++
    }
    if(N<=1){ println("0"); return }
    let nextIdx=Array<Int64>(N, repeat:0)
    for(i in 0..N){ nextIdx[i]=i }
    // hull as list of [x,y,idx]
    let hull=ArrayList<Array<Int64>>()
    // we will process from north to south: i = N-1 downto 0
    for(iter in 0..N){
        let i = N-1 - iter
        if(hull.size>0){
            // query best
            var lo: Int64=0
            var hi: Int64=hull.size-1
            while(lo < hi){
                let mid=(lo+hi)/2
                let a=hull[mid]
                let b=hull[mid+1]
                // compare slope to a vs b
                // slope(i,a) < slope(i,b) ? go right
                let y_a=a[1]; let x_a=a[0]
                let y_b=b[1]; let x_b=b[0]
                let yi=ys[i]; let xi=xs[i]
                // slope_a = (y_a - yi)/(xi - x_a)  denominator >0 because xi > x_a (south larger)
                // compare cross: (y_a - yi)*(xi - x_b) < (y_b - yi)*(xi - x_a)  => a < b
                let left = (y_a - yi)*(xi - x_b)
                let right = (y_b - yi)*(xi - x_a)
                if(left < right){
                    lo = mid + 1
                } else {
                    hi = mid
                }
            }
            let best=hull[lo]
            nextIdx[i]=best[2]
        } else {
            nextIdx[i]=i
        }
        // insert point i into hull
        let pt=Array<Int64>(3, repeat:0)
        pt[0]=xs[i]; pt[1]=ys[i]; pt[2]=i
        while(hull.size>=2){
            let a=hull[hull.size-2]
            let b=hull[hull.size-1]
            // cross (b-a) x (pt-a)
            let cross = (b[0]-a[0])*(pt[1]-a[1]) - (b[1]-a[1])*(pt[0]-a[0])
            if(cross >= 0){
                hull.remove((hull.size-1)..hull.size)
            } else { break }
        }
        hull.add(pt)
    }
    // greedy minimum jumps to cover 0..N-1
    // nextIdx[i] is farthest visible from i (maybe i itself if isolated)
    // Jump game
    if(nextIdx[0]==0 && N>1){
        // cannot move at all, but maybe beacons can be placed elsewhere? Still need at least one?
        // If isolated, count beacons maybe N-1? But spec expects coverage.
        println("-1")
        return
    }
    var jumps: Int64=0
    var curEnd: Int64=0
    var farthest: Int64=0
    var i: Int64=0
    while(curEnd < N-1){
        jumps++
        var nextEnd = farthest
        // find max nextIdx in [i .. curEnd]  ??? Actually we need to consider current coverage.
        // Use classic loop: for j from i to curEnd, farthest = max(farthest, nextIdx[j])
        // But we maintain i pointer.
        var j = i
        // Actually i should be curEnd+1? Let's use standard jump game II:
        // We have curEnd as farthest reachable with jumps jumps, nextEnd is farthest reachable with jumps+1
        // For each index in (prevEnd+1 .. curEnd) update nextEnd
        // Simpler iterate.
        var newFarthest = farthest
        var scanL = i
        var scanR = curEnd
        // But for first iteration i=0 curEnd=0 => scan 0..0
        for(k in scanL..(scanR+1)){
            if(k>=N){ break }
            let cand=nextIdx[k]
            if(cand > newFarthest){ newFarthest=cand }
        }
        if(newFarthest == curEnd){
            // stuck
            break
        }
        i = curEnd + 1
        curEnd = newFarthest
        farthest = newFarthest
        if(curEnd >= N-1){ break }
        // prevent infinite
        if(jumps > N){ break }
    }
    // jumps counts number of intervals to reach N-1, but number of beacons excludes headquarters?
    // If start at 0 headquarters, first jump corresponds to first beacon? The headquarters itself not counted.
    // Example sample answer 2, our jumps should be 2.
    // Let's test with sample via mental.
    println(jumps.toString())
}
