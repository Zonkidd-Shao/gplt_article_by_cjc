// L1-042 日期格式化 — mm-dd-yyyy 转 yyyy-mm-dd
import std.env.*
import std.collection.*
main() {
    let cin = getStdIn()
    var line = ""
    // try read line by line
    while (let Some(l) <- cin.readln()) {
        let t = l.trimAscii()
        if (!t.isEmpty()) { line = t; break }
    }
    if (line.isEmpty()) {
        let all = cin.readToEnd() ?? ""
        line = all.trimAscii()
    }
    line = line.trimAscii()
    if (line.isEmpty()) { return }
    let parts = line.split("-")
    if (parts.size < 3) { return }
    let mm = parts[0].trimAscii()
    let dd = parts[1].trimAscii()
    let yyyy = parts[2].trimAscii()
    println("${yyyy}-${mm}-${dd}")
}
