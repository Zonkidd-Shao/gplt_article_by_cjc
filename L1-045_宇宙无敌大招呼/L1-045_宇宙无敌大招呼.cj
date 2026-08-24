// L1-045 宇宙无敌大招呼 — 输出 Hello S
import std.env.*
main() {
    let cin = getStdIn()
    var s = ""
    while (let Some(l) <- cin.readln()) {
        let t = l.trimAscii()
        if (!t.isEmpty()) { s = t; break }
    }
    if (s.isEmpty()) {
        let all = cin.readToEnd() ?? ""
        s = all.trimAscii()
    }
    // S is first token (word)
    let parts = s.split(" ")
    var name = ""
    for (p in parts) {
        let t = p.trimAscii()
        if (!t.isEmpty()) { name = t; break }
    }
    if (name.isEmpty()) { name = s.trimAscii() }
    println("Hello ${name}")
}
