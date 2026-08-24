// L2-014 列车调度 - patience LIS
import std.env.*
import std.collection.*
import std.convert.*
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
    var nums = ArrayList<Int64>()
    for (i in 1..(n+1)) {
        if (i < tokens.size) { nums.add(Int64.parse(tokens[i])) }
    }
    var tracks = ArrayList<Int64>()
    for (num in nums) {
        var left: Int64 = 0
        var right: Int64 = tracks.size - 1
        var found: Int64 = -1
        while (left <= right) {
            let mid = (left + right) / 2
            if (tracks[mid] > num) {
                found = mid
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        if (found != -1) {
            tracks[found] = num
        } else {
            tracks.add(num)
        }
    }
    println(tracks.size)
}
