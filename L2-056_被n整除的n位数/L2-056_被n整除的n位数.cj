// L2-056 被n整除的n位数 - 求区间内满足前缀整除的n位数
// Approach: DFS按前缀可整除剪枝生成所有满足条件的n位数
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
    if(tokens.size<3){ return }
    let n=Int64.parse(tokens[0])
    let a=Int64.parse(tokens[1])
    let b=Int64.parse(tokens[2])
    let results=ArrayList<Int64>()
    // low/high for n digits: 10^(n-1) .. 10^n -1, but we also limit to [a,b]
    func pow10(k: Int64): Int64 {
        var p: Int64=1
        for(i in 0..k){ p*=10 }
        return p
    }
    // quick prune: if b < 10^(n-1) or a > 10^n-1 -> no solution (but still search will be empty)
    func dfs(pos: Int64, cur: Int64): Unit {
        if(pos==n){
            if(cur>=a && cur<=b){
                results.add(cur)
            }
            return
        }
        if(pos==0){
            for(d in 1..10){
                // pos will be 1
                // d%1==0 always
                dfs(1, d)
            }
        } else {
            let nextPos = pos+1
            for(d in 0..10){
                let nxt = cur*10 + d
                if(nxt % nextPos == 0){
                    // prune by range: if nxt with remaining digits cannot reach [a,b]
                    // minimal possible final number = nxt * 10^(n-nextPos)
                    // maximal = nxt *10^(n-nextPos) + (10^(n-nextPos)-1)
                    let remain = n - nextPos
                    let p = pow10(remain)
                    let low = nxt * p
                    let high = nxt * p + p - 1
                    if(high < a || low > b){
                        continue
                    }
                    dfs(nextPos, nxt)
                }
            }
        }
    }
    dfs(0, 0)
    if(results.size==0){
        println("No Solution")
    } else {
        // results are generated in increasing order because d iterates 0..9 and first digit 1..9
        let sb2=StringBuilder()
        for(v in results){
            sb2.append(v.toString())
            sb2.append("\n")
        }
        print(sb2.toString())
    }
}
