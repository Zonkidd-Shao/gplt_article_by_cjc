// L3-007 天梯地图 - 最快与最短路径
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
    var p: Int64=0
    let N=Int64.parse(tokens[p]); p++
    let M=Int64.parse(tokens[p]); p++
    let adj=ArrayList<ArrayList<Array<Int64>>>()
    for(i in 0..N){ adj.add(ArrayList<Array<Int64>>()) }
    for(i in 0..M){
        let v1=Int64.parse(tokens[p]); p++
        let v2=Int64.parse(tokens[p]); p++
        let ow=Int64.parse(tokens[p]); p++
        let len=Int64.parse(tokens[p]); p++
        let tim=Int64.parse(tokens[p]); p++
        adj[v1].add([v2,len,tim])
        if(ow==0){ adj[v2].add([v1,len,tim]) }
    }
    let start=Int64.parse(tokens[p]); p++
    let dest=Int64.parse(tokens[p]); p++
    let INF: Int64 = 9000000000000000000
    // Dijkstra for time primary distance secondary
    func dijkstraTime():Array<Int64> {
        let distT=Array<Int64>(N, repeat:INF)
        let distL=Array<Int64>(N, repeat:INF)
        let parent=Array<Int64>(N, repeat:-1)
        let vis=Array<Bool>(N, repeat:false)
        distT[start]=0
        distL[start]=0
        for(iter in 0..N){
            var u: Int64=-1
            var best: Int64=INF
            for(v in 0..N){
                if(!vis[v] && distT[v] < best){ best=distT[v]; u=v }
            }
            if(u==-1){ break }
            vis[u]=true
            for(e in adj[u]){
                let to=e[0]; let len=e[1]; let tim=e[2]
                if(vis[to]){ continue }
                let nt=distT[u]+tim
                let nl=distL[u]+len
                if(nt < distT[to] || (nt==distT[to] && nl < distL[to])){
                    distT[to]=nt
                    distL[to]=nl
                    parent[to]=u
                }
            }
        }
        // Return combined: we need distT[dest] and parent array encoded via closure, but we will reconstruct outside
        // Instead we store parent globally via return values using arrays captured
        // For simplicity do separate function returning parent; but we use outer arrays
        // We'll just store into globals and access - here we return parent
        return parent
    }
    // We'll implement inline for time and dist
    let distT=Array<Int64>(N, repeat:INF)
    let distLforT=Array<Int64>(N, repeat:INF)
    let parentT=Array<Int64>(N, repeat:-1)
    let visT=Array<Bool>(N, repeat:false)
    distT[start]=0; distLforT[start]=0
    for(iter in 0..N){
        var u: Int64=-1
        var best: Int64=INF
        for(v in 0..N){ if(!visT[v] && distT[v] < best){ best=distT[v]; u=v } }
        if(u==-1){ break }
        visT[u]=true
        for(e in adj[u]){
            let to=e[0]; let len=e[1]; let tim=e[2]
            if(visT[to]){ continue }
            let nt=distT[u]+tim
            let nl=distLforT[u]+len
            if(nt < distT[to] || (nt==distT[to] && nl < distLforT[to])){
                distT[to]=nt
                distLforT[to]=nl
                parentT[to]=u
            }
        }
    }
    let distD=Array<Int64>(N, repeat:INF)
    let cntD=Array<Int64>(N, repeat:INF)
    let parentD=Array<Int64>(N, repeat:-1)
    let visD=Array<Bool>(N, repeat:false)
    distD[start]=0
    cntD[start]=1
    for(iter in 0..N){
        var u: Int64=-1
        var best: Int64=INF
        for(v in 0..N){ if(!visD[v] && distD[v] < best){ best=distD[v]; u=v } }
        if(u==-1){ break }
        visD[u]=true
        for(e in adj[u]){
            let to=e[0]; let len=e[1]
            if(visD[to]){ continue }
            let nd=distD[u]+len
            let nc=cntD[u]+1
            if(nd < distD[to] || (nd==distD[to] && nc < cntD[to])){
                distD[to]=nd
                cntD[to]=nc
                parentD[to]=u
            }
        }
    }
    func buildPath(parent: Array<Int64>, dest: Int64): ArrayList<Int64> {
        let rev=ArrayList<Int64>()
        var cur=dest
        while(cur != -1){
            rev.add(cur)
            cur=parent[cur]
        }
        let path=ArrayList<Int64>()
        var i=rev.size-1
        while(i>=0){
            path.add(rev[i])
            i--
        }
        return path
    }
    let pathT=buildPath(parentT, dest)
    let pathD=buildPath(parentD, dest)
    var same=true
    if(pathT.size != pathD.size){ same=false }
    else {
        for(i in 0..pathT.size){
            if(pathT[i]!=pathD[i]){ same=false; break }
        }
    }
    func fmtPath(p: ArrayList<Int64>): String {
        let sb2=StringBuilder()
        for(i in 0..p.size){
            if(i>0){ sb2.append(" => ") }
            sb2.append(p[i].toString())
        }
        return sb2.toString()
    }
    if(same){
        println("Time = ${distT[dest]}; Distance = ${distD[dest]}: ${fmtPath(pathT)}")
    } else {
        println("Time = ${distT[dest]}: ${fmtPath(pathT)}")
        println("Distance = ${distD[dest]}: ${fmtPath(pathD)}")
    }
}
