// L1-003 个位数统计
// approach: count digits 0-9 in up to 1000-digit number
import std.env.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let s = all.trimAscii()
    if (s.isEmpty()) { return }
    var cnt = Array<Int64>(10, repeat: 0)
    for (r in s.toRuneArray()) {
        let rs = r.toString()
        if (rs >= "0" && rs <= "9") {
            let d = Int64.parse(rs)
            cnt[d] = cnt[d] + 1
        }
    }
    for (i in 0..10) {
        if (cnt[i] > 0) {
            println("${i}:${cnt[i]}")
        }
    }
}
