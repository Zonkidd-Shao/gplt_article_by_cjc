// L1-005 考试座位号
// approach: map trial seat -> (id, exam seat)
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
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var ids = Array<String>(n + 1, repeat: "")
    var exams = Array<Int64>(n + 1, repeat: 0)
    var idx: Int64 = 1
    for (_ in 0..n) {
        let id = tokens[idx]
        let trial = Int64.parse(tokens[idx+1])
        let exam = Int64.parse(tokens[idx+2])
        ids[trial] = id
        exams[trial] = exam
        idx += 3
    }
    let m = Int64.parse(tokens[idx])
    idx += 1
    for (i in 0..m) {
        let seat = Int64.parse(tokens[idx+i])
        println("${ids[seat]} ${exams[seat]}")
    }
}
