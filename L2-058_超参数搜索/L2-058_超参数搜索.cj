// L2-058 超参数搜索 - 最大值得编号 + 对每次查询找严格大于x的最小得分对应最小编号
// Approach: map value->minIndex, sorted distinct values binary search
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
    let n=Int64.parse(tokens[p]); p++
    let scores=ArrayList<Int64>()
    let posMap=ArrayList<Array<Int64>>() // we will use HashMap-like via parallel search but easier: use mapping via sorting distinct
    // But we need min index per score
    // Use HashMap via two arrays: values distinct and minIdx
    let valToMin = ArrayList<Int64>() // not efficient but we can brute
    // Instead use ArrayList for distinct values and minIdx arrays with linear search since n 1e5
    let distinct=ArrayList<Int64>()
    let minIdxArr=ArrayList<Int64>()
    // We'll also keep max
    var maxScore: Int64 = -1
    for(i in 0..n){
        let v=Int64.parse(tokens[p]); p++
        scores.add(v)
        if(v>maxScore){ maxScore=v }
        // update distinct min
        var found: Int64 = -1
        for(j in 0..distinct.size){
            if(distinct[j]==v){ found=j; break }
        }
        if(found==-1){
            distinct.add(v)
            minIdxArr.add(i+1)
        } else {
            if(i+1 < minIdxArr[found]){ minIdxArr[found]=i+1 }
        }
    }
    // output max indices sorted
    let maxIdxs=ArrayList<Int64>()
    for(i in 0..n){
        if(scores[i]==maxScore){ maxIdxs.add(i+1) }
    }
    // maxIdxs already sorted ascending
    let sbOut=StringBuilder()
    for(i in 0..maxIdxs.size){
        if(i>0){ sbOut.append(" ") }
        sbOut.append(maxIdxs[i].toString())
    }
    println(sbOut.toString())
    // sort distinct ascending
    // simple sort via quicksort on distinct with parallel minIdx
    func qs(l:Int64,r:Int64):Unit{
        if(l>=r){return}
        var i=l; var j=r
        let pivot=distinct[(l+r)/2]
        while(i<=j){
            while(distinct[i] < pivot){ i++ }
            while(distinct[j] > pivot){ j-- }
            if(i<=j){
                let tv=distinct[i]; distinct[i]=distinct[j]; distinct[j]=tv
                let ti=minIdxArr[i]; minIdxArr[i]=minIdxArr[j]; minIdxArr[j]=ti
                i++; j--
            }
        }
        if(l<j){ qs(l,j) }
        if(i<r){ qs(i,r) }
    }
    if(distinct.size>1){ qs(0, distinct.size-1) }
    let m=Int64.parse(tokens[p]); p++
    for(q in 0..m){
        if(p >= tokens.size){ break }
        let x=Int64.parse(tokens[p]); p++
        // binary search for smallest value > x
        var lo: Int64=0
        var hi: Int64=distinct.size
        while(lo<hi){
            let mid=(lo+hi)/2
            if(distinct[mid] > x){ hi=mid } else { lo=mid+1 }
        }
        if(lo >= distinct.size){
            println("0")
        } else {
            println(minIdxArr[lo].toString())
        }
    }
}
