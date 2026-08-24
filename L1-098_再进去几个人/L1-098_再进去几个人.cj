/* L1-098 再进去几个人 - approach: answer = B - A, stdin read */
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
    if (tokens.size < 2) {
        return
    }
    let a = Int64.parse(tokens[0])
    let b = Int64.parse(tokens[1])
    println(b - a)
}
