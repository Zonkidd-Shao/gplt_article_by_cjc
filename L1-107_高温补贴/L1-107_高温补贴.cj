/* L1-107 高温补贴 - approach: thresholds T>=35 and t>=33 */
import std.env.*
import std.collection.*
import std.convert.*
main() {
    let cin = getStdIn()
    var tokens = ArrayList<String>()
    while (let Some(line) <- cin.readln()) {
        let parts = line.split(" ")
        for (p in parts) {
            let t = p.trimAscii()
            if (t.size != 0) { tokens.add(t) }
        }
    }
    if (tokens.size < 3) { return }
    let T = Int64.parse(tokens[0])
    let S = Int64.parse(tokens[1])
    let t = Int64.parse(tokens[2])
    let hot = T >= 35
    let hotWork = t >= 33
    var status: String = ""
    var outTemp: Int64 = 0
    if (hot && hotWork && S == 1) {
        status = "Bu Tie"
        outTemp = T
    } else if (hot && hotWork && S == 0) {
        status = "Shi Nei"
        outTemp = T
    } else if (S == 1) {
        status = "Bu Re"
        outTemp = t
    } else {
        status = "Shu Shi"
        outTemp = t
    }
    println(status)
    println(outTemp)
}
