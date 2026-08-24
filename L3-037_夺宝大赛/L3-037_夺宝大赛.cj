// L3-037 夺宝大赛 - 最短路径夺宝
import std.collection.*
import std.convert.*
import std.env.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().size == 0) { return }
    let tmp = all.replace("\n", " ").replace("\r", " ").replace("\t", " ")
    let parts = tmp.split(" ")
    let toks = ArrayList<String>()
    for (p in parts) { if (p.size>0) { toks.add(p) } }
    var idx: Int64 = 0
    let m = Int64.parse(toks[idx]); idx++
    let n = Int64.parse(toks[idx]); idx++
    let grid = Array<Array<Int64>>(m, {i=> Array<Int64>(n, repeat: 0)})
    var bx: Int64 = -1
    var by: Int64 = -1
    for (y in 0..m) {
        for (x in 0..n) {
            let v = Int64.parse(toks[idx]); idx++
            grid[y][x]=v
            if (v==2) { bx=x; by=y }
        }
    }
    let k = Int64.parse(toks[idx]); idx++
    let teams = Array<Array<Int64>>(k, {i=> Array<Int64>(3, repeat: 0)})
    for (i in 0..k) {
        let x = Int64.parse(toks[idx]); idx++
        let y = Int64.parse(toks[idx]); idx++
        teams[i][0]=x-1
        teams[i][1]=y-1
        teams[i][2]=i+1
    }
    let dist = Array<Array<Int64>>(m, {i=> Array<Int64>(n, repeat: -1)})
    let qx = ArrayList<Int64>()
    let qy = ArrayList<Int64>()
    qx.add(bx); qy.add(by)
    dist[by][bx]=0
    var head: Int64 = 0
    let dx = [1, -1, 0, 0]
    let dy = [0, 0, 1, -1]
    while (head < Int64(qx.size)) {
        let x = qx[head]
        let y = qy[head]
        head++
        for (d in 0..4) {
            let nx = x + dx[d]
            let ny = y + dy[d]
            if (nx>=0 && nx<n && ny>=0 && ny<m && dist[ny][nx]==-1 && grid[ny][nx]!=0) {
                dist[ny][nx]=dist[y][x]+1
                qx.add(nx); qy.add(ny)
            }
        }
    }
    let mp = HashMap<Int64, ArrayList<Int64>>()
    for (i in 0..k) {
        let x=teams[i][0]
        let y=teams[i][1]
        let id=teams[i][2]
        if (x<0 || x>=n || y<0 || y>=m) { continue }
        if (grid[y][x]==0) { continue }
        let d = dist[y][x]
        if (d==-1) { continue }
        if (!mp.contains(d)) { mp[d]=ArrayList<Int64>() }
        mp[d].add(id)
    }
    if (mp.size==0) {
        println("No winner.")
        return
    }
    let keys = ArrayList<Int64>()
    for ((kk, v) in mp) { keys.add(kk) }
    for (i in 0..keys.size) {
        for (j in i+1..keys.size) {
            if (keys[j] < keys[i]) {
                let t=keys[i]; keys[i]=keys[j]; keys[j]=t
            }
        }
    }
    var winner: Int64 = -1
    var winDist: Int64 = -1
    for (kk in keys) {
        let lst = mp[kk]
        if (lst.size==1) {
            winner=lst[0]
            winDist=kk
            break
        }
    }
    if (winner==-1) {
        println("No winner.")
    } else {
        let sb = StringBuilder()
        sb.append(winner.toString())
        sb.append(" ")
        sb.append(winDist.toString())
        println(sb.toString())
    }
}
