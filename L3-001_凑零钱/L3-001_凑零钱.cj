// L3-001 凑零钱 - 0/1背包求和为M且字典序最小的有序序列(升序)
// Approach: coins sorted ascending, DP keep best sequence per sum
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
    if(tokens.size<2){ return }
    let N=Int64.parse(tokens[0])
    let M=Int64.parse(tokens[1])
    let coins=ArrayList<Int64>()
    for(i in 0..N){
        let idx=i+2
        if(idx < tokens.size){
            let v=Int64.parse(tokens[idx])
            if(v<=M){ coins.add(v) }
        }
    }
    func qs(l:Int64,r:Int64):Unit{
        if(l>=r){return}
        var i=l; var j=r
        let piv=coins[(l+r)/2]
        while(i<=j){
            while(coins[i] < piv){ i++ }
            while(coins[j] > piv){ j-- }
            if(i<=j){
                let t=coins[i]; coins[i]=coins[j]; coins[j]=t
                i++; j--
            }
        }
        if(l<j){ qs(l,j) }
        if(i<r){ qs(i,r) }
    }
    if(coins.size>1){ qs(0, coins.size-1) }
    // dp[sum] = sequence (ArrayList<Int64>) or null sentinel empty indicates not reachable except 0
    let dp=ArrayList<ArrayList<Int64>>()
    let has=ArrayList<Bool>()
    for(i in 0..(M+1)){
        dp.add(ArrayList<Int64>())
        has.add(false)
    }
    has[0]=true // empty
    // For 0..coins.size
    for(ci in 0..coins.size){
        let c=coins[ci]
        var s=M - c
        while(s>=0){
            if(has[s]){
                let ns=s + c
                let cand=ArrayList<Int64>()
                for(v in dp[s]){ cand.add(v) }
                cand.add(c)
                if(!has[ns]){
                    dp[ns]=cand
                    has[ns]=true
                } else {
                    // compare cand vs dp[ns] lexicographically
                    let a=cand
                    let b=dp[ns]
                    var isSmaller=false
                    var isLarger=false
                    var mn: Int64 = 0
                    if(a.size < b.size){ mn = a.size } else { mn = b.size }
                    var diffFound=false
                    for(k in 0..mn){
                        if(a[k] < b[k]){ isSmaller=true; diffFound=true; break }
                        if(a[k] > b[k]){ isLarger=true; diffFound=true; break }
                    }
                    if(!diffFound){
                        // prefix equal, shorter is smaller
                        if(a.size < b.size){ isSmaller=true }
                        else if(a.size > b.size){ isLarger=true }
                    }
                    if(isSmaller){
                        dp[ns]=cand
                    }
                }
            }
            s--
        }
    }
    if(!has[M]){
        println("No Solution")
    } else {
        let seq=dp[M]
        let sb2=StringBuilder()
        for(i in 0..seq.size){
            if(i>0){ sb2.append(" ") }
            sb2.append(seq[i].toString())
        }
        println(sb2.toString())
    }
}
