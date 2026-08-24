// L1-049 天梯赛座位分配 — 按规则分配座位
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var parts = all.split(" ")
    var toks = ArrayList<String>()
    for (p in parts) {
        let a = p.split("\n")
        for (q in a) {
            let b = q.split("\r")
            for (r in b) {
                let c = r.split("\t")
                for (t in c) {
                    let s = t.trimAscii()
                    if (!s.isEmpty()) { toks.add(s) }
                }
            }
        }
    }
    let n = Int64.parse(toks[0])
    var teams = Array<Int64>(n, repeat: 0)
    var i: Int64 = 0
    while (i < n) {
        teams[i] = Int64.parse(toks[i+1])
        i += 1
    }
    var totalStudents = Array<Int64>(n, repeat: 0)
    i = 0
    while (i < n) { totalStudents[i] = teams[i]*10; i += 1 }
    var allocated = Array<Int64>(n, repeat: 0)
    var seats = Array<Array<Int64>>(n, repeat: Array<Int64>(0, repeat: 0))
    var si: Int64 = 0
    while (si < n) {
        seats[si] = Array<Int64>(totalStudents[si], repeat: 0)
        si += 1
    }
    var cur: Int64 = 1
    while (true) {
        var remaining: Int64 = 0
        var last: Int64 = -1
        var j: Int64 = 0
        while (j < n) {
            if (allocated[j] < totalStudents[j]) { remaining += 1; last = j }
            j += 1
        }
        if (remaining == 0) { break }
        if (remaining == 1) {
            if (cur != 1) { cur += 1 }
            while (allocated[last] < totalStudents[last]) {
                seats[last][allocated[last]] = cur
                allocated[last] += 1
                cur += 2
            }
            break
        }
        j = 0
        while (j < n) {
            if (allocated[j] < totalStudents[j]) {
                seats[j][allocated[j]] = cur
                allocated[j] += 1
                cur += 1
            }
            j += 1
        }
    }
    i = 0
    while (i < n) {
        println("#${i+1}")
        var team: Int64 = 0
        while (team < teams[i]) {
            let sb = StringBuilder()
            var k: Int64 = 0
            while (k < 10) {
                if (k > 0) { sb.append(" ") }
                let idx2 = team*10 + k
                sb.append(seats[i][idx2].toString())
                k += 1
            }
            println(sb.toString())
            team += 1
        }
        i += 1
    }
}
