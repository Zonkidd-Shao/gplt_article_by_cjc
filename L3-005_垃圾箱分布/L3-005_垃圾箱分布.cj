// L3-005 垃圾箱分布 - Dijkstra多候选点
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

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
    if(tokens.size<4){ return }
    var p: Int64=0
    let N=Int64.parse(tokens[p]); p++
    let M=Int64.parse(tokens[p]); p++
    let K=Int64.parse(tokens[p]); p++
    let DS=Int64.parse(tokens[p]); p++
    let V=N+M
    let adj=ArrayList<ArrayList<Array<Int64>>>()
    for(i in 0..(V+1)){ adj.add(ArrayList<Array<Int64>>()) }
    func parseNode(s:String):Int64{
        let rs=s.toRuneArray()
        let g:Rune='G'
        if(rs.size>0 && rs[0]==g){
            let sb2=StringBuilder()
            for(i in 1..rs.size){ sb2.append(rs[i]) }
            let num=Int64.parse(sb2.toString())
            return N + num
        } else {
            return Int64.parse(s)
        }
    }
    for(i in 0..K){
        if(p+2 >= tokens.size){ break }
        let p1=tokens[p]; p++
        let p2=tokens[p]; p++
        let d=Int64.parse(tokens[p]); p++
        let u=parseNode(p1)
        let v=parseNode(p2)
        adj[u].add([v,d])
        adj[v].add([u,d])
    }
    let INF: Int64 = 9000000000000000000
    var bestIdx: Int64 = -1
    var bestMin: Int64 = -1
    var bestAvg: Float64 = 1e100
    for(g in 1..(M+1)){
        let src=N+g
        let dist=Array<Int64>(V+1, repeat:INF)
        let vis=Array<Bool>(V+1, repeat:false)
        dist[src]=0
        for(iter in 0..(V)){
            var u: Int64=-1
            var best: Int64=INF
            for(v in 1..(V+1)){
                if(!vis[v] && dist[v] < best){ best=dist[v]; u=v }
            }
            if(u==-1){ break }
            vis[u]=true
            for(e in adj[u]){
                let to=e[0]; let w=e[1]
                if(!vis[to] && dist[to] > dist[u]+w){
                    dist[to]=dist[u]+w
                }
            }
        }
        var ok=true
        var minD: Int64=INF
        var sum: Int64=0
        for(i in 1..(N+1)){
            if(dist[i] > DS){ ok=false; break }
            if(dist[i] < minD){ minD=dist[i] }
            sum+=dist[i]
        }
        if(!ok){ continue }
        let avg = Float64(sum) / Float64(N)
        var take=false
        if(bestIdx==-1){ take=true }
        else if(minD > bestMin){ take=true }
        else if(minD==bestMin && avg < bestAvg - 1e-9){ take=true }
        else if(minD==bestMin && abs(avg - bestAvg) < 1e-9 && g < bestIdx){ take=true }
        if(take){
            bestIdx=g
            bestMin=minD
            bestAvg=avg
        }
    }
    if(bestIdx==-1){
        println("No Solution")
    } else {
        let sb2=StringBuilder()
        sb2.append("G")
        sb2.append(bestIdx.toString())
        println(sb2.toString())
        func fmtOne(v: Float64): String {
            var iv = Int64(floor(v*10.0 + 0.5 + 1e-9))
            let neg = iv < 0
            if(neg){ iv = -iv }
            let intPart = iv / 10
            let dec = iv % 10
            var s=""
            if(neg){ s="-" }
            s += intPart.toString()
            s += "."
            s += dec.toString()
            return s
        }
        let minStr = fmtOne(Float64(bestMin))
        let avgStr = fmtOne(bestAvg)
        println("${minStr} ${avgStr}")
    }
}
