/* L1-115 就挺突然的 - approach: lifespan = B-A, classify */
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
    if (tokens.size < 2) { return }
    let A = Int64.parse(tokens[0])
    let B = Int64.parse(tokens[1])
    let diff = B - A
    println(diff)
    if (diff > 250) {
        println("jiu ting tu ran de...")
    } else if (diff <= 0) {
        println("hai sheng ma?")
    } else {
        println("nin tai cong ming le!")
    }
}
