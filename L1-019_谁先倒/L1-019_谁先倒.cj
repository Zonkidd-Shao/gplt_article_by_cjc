// L1-019 谁先倒
// approach: simulate rounds
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    var tokens = ArrayList<String>()
    var cur = StringBuilder()
    for (r in all.toRuneArray()) {
        let rs = r.toString()
        if (rs == " " || rs == "\n" || rs == "\r" || rs == "\t") {
            if (cur.size > 0) { tokens.add(cur.toString()); cur = StringBuilder() }
        } else { cur.append(rs) }
    }
    if (cur.size > 0) { tokens.add(cur.toString()) }
    let capA = Int64.parse(tokens[0])
    let capB = Int64.parse(tokens[1])
    let n = Int64.parse(tokens[2])
    var drunkA: Int64 = 0
    var drunkB: Int64 = 0
    var idx: Int64 = 3
    for (_ in 0..n) {
        let aCall = Int64.parse(tokens[idx])
        let aDraw = Int64.parse(tokens[idx+1])
        let bCall = Int64.parse(tokens[idx+2])
        let bDraw = Int64.parse(tokens[idx+3])
        idx += 4
        let sum = aCall + bCall
        let aLose = aDraw == sum
        let bLose = bDraw == sum
        if (aLose && !bLose) { drunkA += 1 }
        if (!aLose && bLose) { drunkB += 1 }
        if (drunkA > capA) {
            println("A")
            println(drunkB)
            return
        }
        if (drunkB > capB) {
            println("B")
            println(drunkA)
            return
        }
    }
}
