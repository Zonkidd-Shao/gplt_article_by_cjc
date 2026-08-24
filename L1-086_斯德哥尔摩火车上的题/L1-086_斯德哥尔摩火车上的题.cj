// L1-086 斯德哥尔摩火车上的题 - 按伪代码处理字符串
import std.env.*
import std.collection.*
import std.convert.*

func process(a: String): String {
    let arr = a.toRuneArray()
    var sb = StringBuilder()
    var i = 1
    while (i < arr.size) {
        let prev = arr[i-1]
        let cur = arr[i]
        let pv = Int64.parse("${prev}")
        let cv = Int64.parse("${cur}")
        if ((pv % 2) == (cv % 2)) {
            if (prev > cur) {
                sb.append(prev)
            } else {
                sb.append(cur)
            }
        }
        i++
    }
    return sb.toString()
}

main() {
    let cin = getStdIn()
    var lines = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        // trim only trailing \r handled by trimAscii but keep digits
        let t = line.trimAscii()
        if (t.size > 0 || lines.size < 2) {
            // keep as is (including possible empty? but problem says non-empty)
            if (t.size > 0) { lines.add(t) } else { if (lines.size < 2) { /* skip empty */ } }
        }
        if (lines.size == 2) { break }
    }
    // fallback if readln missed due to no newline at end and readToEnd
    if (lines.size < 2) {
        let all = cin.readToEnd() ?? ""
        if (all.size > 0) {
            let cleaned = all.replace("\r", " ").replace("\n", " ").replace("\t", " ")
            var raw = cleaned.split(" ")
            for (p in raw) { if (p.trimAscii().size > 0) { lines.add(p.trimAscii()) } }
        }
    }
    if (lines.size < 2) { return }
    let s1 = lines[0]
    let s2 = lines[1]
    let r1 = process(s1)
    let r2 = process(s2)
    if (r1 == r2) {
        println(r1)
    } else {
        println(r1)
        println(r2)
    }
}
