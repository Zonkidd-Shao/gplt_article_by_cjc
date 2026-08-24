/* L1-099 帮助色盲 - approach: decide sound/action by A,B */
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
    let a = Int64.parse(tokens[0])
    let b = Int64.parse(tokens[1])
    var sound: String = ""
    var action: String = ""
    if (a == 2) {
        sound = "-"
        action = "stop"
    } else if (b == 1) {
        sound = "-"
        if (a == 1) {
            action = "move"
        } else {
            action = "stop"
        }
    } else {
        if (a == 0) {
            sound = "biii"
            action = "stop"
        } else {
            sound = "dudu"
            action = "move"
        }
    }
    println(sound)
    println(action)
}
