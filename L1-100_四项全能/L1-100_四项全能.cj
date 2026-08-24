/* L1-100 四项全能 - approach: max(0, sum(k_i)-n*(m-1)) */
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
            if (t.size != 0) {
                tokens.add(t)
            }
        }
    }
    if (tokens.size < 2) { return }
    let n = Int64.parse(tokens[0])
    let m = Int64.parse(tokens[1])
    var total: Int64 = 0
    for (i in 0..m) {
        // tokens index 2+i, ensure exists
        if (2 + i < tokens.size) {
            total += Int64.parse(tokens[2 + i])
        }
    }
    let maxCover = n * (m - 1)
    var ans: Int64 = 0
    if (total > maxCover) {
        ans = total - maxCover
    } else {
        ans = 0
    }
    println(ans)
}
