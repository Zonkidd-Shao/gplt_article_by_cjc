// L2-009 抢红包
import std.env.*
import std.collection.*
import std.convert.*
class Person {
    var id: Int64 = 0
    var money: Int64 = 0
    var cnt: Int64 = 0
}
func fmtMoney(cent: Int64): String {
    var neg = cent < 0
    var abs = if (neg) { -cent } else { cent }
    let ip = abs / 100
    let fp = abs % 100
    var fps = "${fp}"
    if (fp < 10) { fps = "0${fp}" }
    var s = "${ip}.${fps}"
    if (neg) { s = "-${s}" }
    return s
}
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    if (all.trimAscii().isEmpty()) { return }
    let sp: Rune = ' '
    let nl: Rune = '\n'
    let cr: Rune = '\r'
    let tab: Rune = '\t'
    var tokens = ArrayList<String>()
    var sb = StringBuilder()
    var inTok = false
    for (ch in all.toRuneArray()) {
        let isSpace = (ch == sp) || (ch == nl) || (ch == cr) || (ch == tab)
        if (isSpace) { if (inTok) { tokens.add(sb.toString()); sb=StringBuilder(); inTok=false } }
        else { sb.append(ch); inTok=true }
    }
    if (inTok) { tokens.add(sb.toString()) }
    if (tokens.size == 0) { return }
    let n = Int64.parse(tokens[0])
    var money = ArrayList<Int64>()
    var cnt = ArrayList<Int64>()
    for (_ in 0..(n+1)) { money.add(0); cnt.add(0) }
    var pos: Int64 = 1
    for (i in 1..(n+1)) {
        if (pos >= tokens.size) { break }
        let k = Int64.parse(tokens[pos]); pos+=1
        var total: Int64 = 0
        for (_ in 0..k) {
            if (pos + 1 >= tokens.size) { break }
            let ni = Int64.parse(tokens[pos]); pos+=1
            let pi = Int64.parse(tokens[pos]); pos+=1
            if (ni >= 0 && ni < money.size) {
                money[ni] += pi
                cnt[ni] += 1
            }
            total += pi
        }
        money[i] -= total
    }
    var people = ArrayList<Person>()
    for (i in 1..(n+1)) {
        let p = Person()
        p.id = i
        p.money = money[i]
        p.cnt = cnt[i]
        people.add(p)
    }
    // sort
    for (i in 0..people.size) {
        for (j in (i+1)..people.size) {
            let a = people[i]
            let b = people[j]
            var needSwap = false
            if (a.money < b.money) { needSwap = true }
            else if (a.money == b.money) {
                if (a.cnt < b.cnt) { needSwap = true }
                else if (a.cnt == b.cnt) {
                    if (a.id > b.id) { needSwap = true }
                }
            }
            if (needSwap) {
                let tmp = people[i]
                people[i] = people[j]
                people[j] = tmp
            }
        }
    }
    for (p in people) {
        println("${p.id} ${fmtMoney(p.money)}")
    }
}
