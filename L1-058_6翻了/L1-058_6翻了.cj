// L1-058 6翻了 — 连续6替换
import std.env.*
main() {
    let cin = getStdIn()
    var line = ""
    var got = false
    while (let Some(l) <- cin.readln()) {
        if (!got) {
            line = l
            got = true
            var extra = cin.readToEnd() ?? ""
            if (!extra.isEmpty()) {
                line = line + "\n" + extra
            }
            break
        }
    }
    if (!got) {
        let all = cin.readToEnd() ?? ""
        line = all
    }
    let ra = line.toRuneArray()
    let sb = StringBuilder()
    var cnt: Int64 = 0
    var idx: Int64 = 0
    let six = '6'.toRuneArray()[0]
    while (idx < ra.size) {
        let r = ra[idx]
        if (r == six) {
            cnt += 1
        } else {
            if (cnt > 0) {
                if (cnt > 9) { sb.append("27") }
                else if (cnt > 3) { sb.append("9") }
                else {
                    var k: Int64 = 0
                    while (k < cnt) { sb.append("6"); k += 1 }
                }
                cnt = 0
            }
            sb.append(r.toString())
        }
        idx += 1
    }
    if (cnt > 0) {
        if (cnt > 9) { sb.append("27") }
        else if (cnt > 3) { sb.append("9") }
        else {
            var k: Int64 = 0
            while (k < cnt) { sb.append("6"); k += 1 }
        }
    }
    println(sb.toString())
}
