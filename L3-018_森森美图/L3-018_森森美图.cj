// L3-018 森森美图 - Dijkstra 8-dir with diagonal cost, two sides
import std.env.*
import std.collection.*
import std.convert.*
import std.math.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    // manual parse: need matrix N M, then N lines, then last line
    // Use token approach for numbers but keep matrix
    let toks = tokenize(all)
    var p: Int64 = 0
    func next(): String { let v = toks[p]; p++; return v }
    let N = Int64.parse(next())
    let M = Int64.parse(next())
    var scores = Array<Array<Int64>>(N, { _ => Array<Int64>(M, repeat: 0) })
    for (i in 0..N) {
        for (j in 0..M) {
            scores[i][j] = Int64.parse(next())
        }
    }
    let xs = Int64.parse(next())
    let ys = Int64.parse(next())
    let xe = Int64.parse(next())
    let ye = Int64.parse(next())
    // xs = X_start (col), ys = Y_start (row)
    // define function to classify
    let INF: Float64 = 1e100
    let sqrt2 = sqrt(2.0)
    // Build helper to check forbidden (on line)
    func isForbidden(x: Int64, y: Int64): Bool {
        if ((x==xs && y==ys) || (x==xe && y==ye)) { return false }
        let dx = xe - xs
        let dy = ye - ys
        // cross ==0 => on line
        return (x - xs)*dy == (y - ys)*dx
    }
    func sideVal(x: Int64, y: Int64): Int64 {
        let dx = xe - xs
        let dy = ye - ys
        let cross = (x - xs)*dy - (y - ys)*dx
        if (cross > 0) { return 1 }
        if (cross < 0) { return -1 }
        return 0
    }
    func dijkstra(targetSide: Int64): Float64 {
        // dist 2D
        var dist = Array<Array<Float64>>(N, { _ => Array<Float64>(M, repeat: INF) })
        var visited = Array<Array<Bool>>(N, { _ => Array<Bool>(M, repeat: false) })
        dist[ys][xs] = Float64.parse("${scores[ys][xs]}")
        // O(V^2) Dijkstra
        let total = N*M
        for (_ in 0..total) {
            var best: Float64 = INF
            var bx: Int64 = -1
            var by: Int64 = -1
            for (y in 0..N) {
                for (x in 0..M) {
                    if (!visited[y][x] && dist[y][x] < best) {
                        // check allowed: must be targetSide or start/end
                        var allowed = false
                        if ((x==xs && y==ys) || (x==xe && y==ye)) { allowed = true }
                        else if (isForbidden(x,y)) { allowed = false }
                        else { let s = sideVal(x,y); if (s==targetSide) { allowed = true } }
                        if (!allowed) { continue }
                        best = dist[y][x]; bx=x; by=y
                    }
                }
            }
            if (bx == -1) { break }
            visited[by][bx] = true
            if (bx==xe && by==ye) { break }
            let cur = dist[by][bx]
            // 8 neighbors
            for (dy in -1..2) {
                for (dx in -1..2) {
                    if (dx==0 && dy==0) { continue }
                    let nx = bx + dx
                    let ny = by + dy
                    if (nx < 0 || nx >= M || ny < 0 || ny >= N) { continue }
                    if (visited[ny][nx]) { continue }
                    var allowed = false
                    if ((nx==xs && ny==ys) || (nx==xe && ny==ye)) { allowed = true }
                    else if (isForbidden(nx,ny)) { allowed = false }
                    else { let s = sideVal(nx,ny); if (s==targetSide) { allowed = true } }
                    if (!allowed) { continue }
                    let add = Float64.parse("${scores[ny][nx]}")
                    var extra: Float64 = 0.0
                    if (dx != 0 && dy != 0) {
                        let sum = Float64.parse("${scores[by][bx] + scores[ny][nx]}")
                        extra = sum * (sqrt2 - 1.0)
                    }
                    let nd = cur + add + extra
                    if (nd < dist[ny][nx]) {
                        dist[ny][nx] = nd
                    }
                }
            }
        }
        return dist[ye][xe]
    }
    let d1 = dijkstra(1)
    let d2 = dijkstra(-1)
    // total = d1+d2 - scores[start]-scores[end] (each counted twice, but diagonal extra counted? start/end counted in both)
    // d1 and d2 each include start+end, so subtract one copy
    let total = d1 + d2 - Float64.parse("${scores[ys][xs]}") - Float64.parse("${scores[ye][xe]}")
    // format to 2 decimals
    let c = Int64(round(total * 100.0))
    let neg = c < 0
    let ac = if (neg) {-c} else {c}
    let intPart = ac / 100
    let frac = ac % 100
    var f = frac.toString()
    while (f.size < 2) { f = "0" + f }
    let sign = if (neg) {"-"} else {""}
    println("${sign}${intPart}.${f}")
}

func tokenize(s: String): Array<String> {
    let res = ArrayList<String>()
    var cur = StringBuilder()
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { res.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { res.add(cur.toString()) }
    return res.toArray()
}
