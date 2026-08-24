// L1-007 念数字
import std.convert.*
// approach: map digits to pinyin
import std.env.*
import std.collection.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let s = all.trimAscii()
    if (s.isEmpty()) { return }
    let pinyin: Array<String> = ["ling","yi","er","san","si","wu","liu","qi","ba","jiu"]
    var res = ArrayList<String>()
    var startIdx: Int64 = 0
    if (s.startsWith("-")) {
        res.add("fu")
        startIdx = 1
    }
    let runes = s.toRuneArray()
    for (i in startIdx..Int64(runes.size)) {
        let rs = runes[i].toString()
        if (rs >= "0" && rs <= "9") {
            let d = Int64.parse(rs)
            res.add(pinyin[d])
        }
    }
    var sb = StringBuilder()
    for (i in 0..Int64(res.size)) {
        if (i > 0) { sb.append(" ") }
        sb.append(res[i])
    }
    println(sb.toString())
}
