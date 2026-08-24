// L3-008 喊山 - BFS最远点
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
    var p: Int64=0
    let n=Int64.parse(tokens[p]); p++
    let m=Int64.parse(tokens[p]); p++
    let k=Int64.parse(tokens[p]); p++
    let adj=ArrayList<ArrayList<Int64>>()
    for(i in 0..(n+1)){ adj.add(ArrayList<Int64>()) }
    for(i in 0..m){
        let a=Int64.parse(tokens[p]); p++
        let b=Int64.parse(tokens[p]); p++
        adj[a].add(b)
        adj[b].add(a)
    }
    let queries=ArrayList<Int64>()
    for(i in 0..k){
        if(p<tokens.size){ queries.add(Int64.parse(tokens[p])); p++ }
    }
    let sbOut=StringBuilder()
    for(q in queries){
        let dist=Array<Int64>(n+1, repeat:-1)
        let que=ArrayList<Int64>()
        var head: Int64=0
        que.add(q)
        dist[q]=0
        while(head < que.size){
            let cur=que[head]; head++
            for(nb in adj[cur]){
                if(dist[nb]==-1){
                    dist[nb]=dist[cur]+1
                    que.add(nb)
                }
            }
        }
        var maxD: Int64=0
        var ans: Int64=0
        for(i in 1..(n+1)){
            if(dist[i] > maxD || (dist[i]==maxD && i < ans && dist[i]!=-1)){
                maxD=dist[i]
                ans=i
            }
        }
        if(maxD==0){ sbOut.append("0\n") } else { sbOut.append(ans.toString()); sbOut.append("\n") }
    }
    print(sbOut.toString())
}
