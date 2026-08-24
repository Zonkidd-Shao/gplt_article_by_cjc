// L1-083 谁能进图书馆 - 判断能否入馆及陪同逻辑
import std.env.*
import std.collection.*
import std.convert.*

main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    let cleaned = all.replace("\r", " ").replace("\n", " ").replace("\t", " ")
    var raw = cleaned.split(" ")
    var tokens = ArrayList<String>()
    for (p in raw) { if (p.trimAscii().size > 0) { tokens.add(p.trimAscii()) } }
    if (tokens.size < 4) { return }
    let ban = Int64.parse(tokens[0])
    let accom = Int64.parse(tokens[1])
    let a1 = Int64.parse(tokens[2])
    let a2 = Int64.parse(tokens[3])
    let canAlone1 = a1 >= ban
    let canAlone2 = a2 >= ban
    let canEscort1 = a1 >= accom
    let canEscort2 = a2 >= accom
    let canEnter1 = canAlone1 || (!canAlone1 && canEscort2)
    let canEnter2 = canAlone2 || (!canAlone2 && canEscort1)
    var s1 = ""
    var s2 = ""
    if (canEnter1) { s1 = "${a1}-Y" } else { s1 = "${a1}-N" }
    if (canEnter2) { s2 = "${a2}-Y" } else { s2 = "${a2}-N" }
    println("${s1} ${s2}")
    let needTogether = (!canAlone1 && canEscort2) || (!canAlone2 && canEscort1)
    if (canEnter1 && canEnter2 && needTogether) {
        if (!canAlone1 && canEscort2) {
            println("qing 2 zhao gu hao 1")
        } else {
            println("qing 1 zhao gu hao 2")
        }
    } else if (canEnter1 && canEnter2) {
        println("huan ying ru guan")
    } else if (!canEnter1 && !canEnter2) {
        println("zhang da zai lai ba")
    } else {
        if (canEnter1) {
            println("1: huan ying ru guan")
        } else {
            println("2: huan ying ru guan")
        }
    }
}
