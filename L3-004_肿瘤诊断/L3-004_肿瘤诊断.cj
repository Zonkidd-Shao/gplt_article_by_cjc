// L3-004 肿瘤诊断 - 3D BFS六连通
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
    if(tokens.size<4){ return }
    var p: Int64=0
    let M=Int64.parse(tokens[p]); p++
    let N=Int64.parse(tokens[p]); p++
    let L=Int64.parse(tokens[p]); p++
    let T=Int64.parse(tokens[p]); p++
    let total = M * N * L
    let vol=Array<Int64>(total, repeat:0)
    // fill vol: order is L slices each with M rows each with N ints
    for(i in 0..total){
        if(p >= tokens.size){ break }
        vol[i]=Int64.parse(tokens[p]); p++
    }
    let visited=Array<Bool>(total, repeat:false)
    let strideN=N
    let strideMN=M*N
    func idx(l:Int64,m:Int64,n:Int64):Int64{
        return l*strideMN + m*strideN + n
    }
    var totalAns: Int64=0
    // direction deltas for 6 neighbors: dl, dm, dn
    let dL=Array<Int64>(6, repeat:0)
    let dM=Array<Int64>(6, repeat:0)
    let dN=Array<Int64>(6, repeat:0)
    dL[0]=1; dM[0]=0; dN[0]=0
    dL[1]=-1; dM[1]=0; dN[1]=0
    dL[2]=0; dM[2]=1; dN[2]=0
    dL[3]=0; dM[3]=-1; dN[3]=0
    dL[4]=0; dM[4]=0; dN[4]=1
    dL[5]=0; dM[5]=0; dN[5]=-1
    let queue=ArrayList<Int64>()
    for(l in 0..L){
        for(m in 0..M){
            for(n in 0..N){
                let id=idx(l,m,n)
                if(visited[id] || vol[id]==0){ continue }
                // BFS
                queue.clear()
                // Actually clear not available - recreate
                // Use manual pointer
                // For simplicity recreate new list each component
                let q=ArrayList<Int64>()
                q.add(id)
                visited[id]=true
                var head: Int64=0
                var cnt: Int64=1
                while(head < q.size){
                    let cur=q[head]; head++
                    let curL=cur / strideMN
                    let rem=cur % strideMN
                    let curM=rem / strideN
                    let curN=rem % strideN
                    for(k in 0..6){
                        let nl=curL + dL[k]
                        let nm=curM + dM[k]
                        let nn=curN + dN[k]
                        if(nl<0||nl>=L||nm<0||nm>=M||nn<0||nn>=N){ continue }
                        let nid=idx(nl,nm,nn)
                        if(visited[nid] || vol[nid]==0){ continue }
                        visited[nid]=true
                        q.add(nid)
                        cnt++
                    }
                }
                if(cnt >= T){ totalAns+=cnt }
            }
        }
    }
    println(totalAns.toString())
}
