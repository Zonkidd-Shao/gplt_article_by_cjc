// L2-048 寻宝图 - 岛屿计数
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.size==0) { return }
    var lines = ArrayList<String>()
    var tmp = StringBuilder()
    for (r in all.toRuneArray()) {
        let s = r.toString()
        if (s=="\n") { lines.add(tmp.toString()); tmp=StringBuilder() } else if (s=="\r") {} else { tmp.append(s) }
    }
    lines.add(tmp.toString())
    var p: Int64 = 0
    while (p < lines.size && lines[p].trimAscii().size==0) { p+=1 }
    let first = lines[p].trimAscii().split(" ").filter({x => x.size>0})
    p+=1
    let N = Int64.parse(first[0]); let M = Int64.parse(first[1])
    var grid = Array<Array<Int64>>(N, repeat: Array<Int64>(0, repeat: 0))
    for (i in 0..N) { grid[i]=Array<Int64>(M, repeat: 0) }
    for (i in 0..N) {
        if (1+i < lines.size) {
            let l = lines[1+i].trimAscii()
            let rr = l.toRuneArray()
            for (j in 0..M) {
                if (j < rr.size) {
                    let chStr = rr[j].toString()
                    grid[i][j]=Int64.parse(chStr)
                } else { grid[i][j]=0 }
            }
        }
    }
    var vis = Array<Array<Bool>>(N, repeat: Array<Bool>(0, repeat: false))
    for (i in 0..N) { vis[i]=Array<Bool>(M, repeat: false) }
    var islands: Int64 = 0
    var treasure: Int64 = 0
    var qx = ArrayList<Int64>(); var qy = ArrayList<Int64>()
    for (i in 0..N) {
        for (j in 0..M) {
            if (vis[i][j]) { continue }
            if (grid[i][j]==0) { vis[i][j]=true; continue }
            islands+=1
            var hasTreasure = false
            qx = ArrayList<Int64>(); qy = ArrayList<Int64>()
            qx.add(i); qy.add(j)
            vis[i][j]=true
            var head: Int64 = 0
            if (grid[i][j] >= 2) { hasTreasure=true }
            while (head < qx.size) {
                let x = qx[head]; let y = qy[head]; head+=1
                if (x>0 && !vis[x-1][y] && grid[x-1][y]!=0) { vis[x-1][y]=true; qx.add(x-1); qy.add(y); if (grid[x-1][y]>=2) { hasTreasure=true } }
                if (x+1<N && !vis[x+1][y] && grid[x+1][y]!=0) { vis[x+1][y]=true; qx.add(x+1); qy.add(y); if (grid[x+1][y]>=2) { hasTreasure=true } }
                if (y>0 && !vis[x][y-1] && grid[x][y-1]!=0) { vis[x][y-1]=true; qx.add(x); qy.add(y-1); if (grid[x][y-1]>=2) { hasTreasure=true } }
                if (y+1<M && !vis[x][y+1] && grid[x][y+1]!=0) { vis[x][y+1]=true; qx.add(x); qy.add(y+1); if (grid[x][y+1]>=2) { hasTreasure=true } }
            }
            if (hasTreasure) { treasure+=1 }
        }
    }
    println("${islands} ${treasure}")
}
