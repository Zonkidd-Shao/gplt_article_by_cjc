// L2-012 关于堆的判断
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
    if (tokens.size < 2) { return }
    let n = Int64.parse(tokens[0])
    let m = Int64.parse(tokens[1])
    var nums = ArrayList<Int64>()
    var pos: Int64 = 2
    for (_ in 0..n) {
        if (pos >= tokens.size) { break }
        nums.add(Int64.parse(tokens[pos])); pos+=1
    }
    // build heap
    var heap = ArrayList<Int64>()
    heap.add(0) // dummy
    for (num in nums) {
        heap.add(num)
        var i = heap.size - 1
        while (i > 1) {
            let p = i / 2
            if (heap[p] > heap[i]) {
                let tmp = heap[p]
                heap[p] = heap[i]
                heap[i] = tmp
                i = p
            } else {
                break
            }
        }
    }
    var posMap = HashMap<Int64, Int64>()
    for (i in 1..heap.size) {
        let v = heap[i]
        posMap[v] = i
    }
    // parse m propositions using tokens remaining
    for (_ in 0..m) {
        if (pos >= tokens.size) { break }
        // peek
        // need to determine type
        // tokens[pos] is x (maybe for siblings, but also first token)
        // check if pos+1 < size and tokens[pos+1]=="and"
        var consumed: Int64 = 0
        var result: Bool = false
        if (pos+1 < tokens.size && tokens[pos+1] == "and") {
            // x and y are siblings
            if (pos+4 >= tokens.size) { break }
            let x = Int64.parse(tokens[pos])
            let y = Int64.parse(tokens[pos+2])
            // tokens: x and y are siblings -> 5 tokens
            let px = if (posMap.contains(x)) { posMap[x] } else { -1 }
            let py = if (posMap.contains(y)) { posMap[y] } else { -1 }
            if (px != -1 && py != -1) {
                if (px/2 == py/2 && px != py) { result = true } else { result = false }
            } else { result = false }
            consumed = 5
        } else if (pos+1 < tokens.size && tokens[pos+1] == "is") {
            // could be is the root / is the parent of / is a child of
            if (pos+2 < tokens.size && tokens[pos+2] == "the") {
                if (pos+3 < tokens.size && tokens[pos+3] == "root") {
                    let x = Int64.parse(tokens[pos])
                    let px = if (posMap.contains(x)) { posMap[x] } else { -1 }
                    result = (px == 1)
                    consumed = 4
                } else if (pos+3 < tokens.size && tokens[pos+3] == "parent") {
                    // x is the parent of y -> 6 tokens: x is the parent of y
                    if (pos+5 >= tokens.size) { break }
                    let x = Int64.parse(tokens[pos])
                    let y = Int64.parse(tokens[pos+5])
                    let px = if (posMap.contains(x)) { posMap[x] } else { -1 }
                    let py = if (posMap.contains(y)) { posMap[y] } else { -1 }
                    if (px != -1 && py != -1) {
                        if (px == py/2) { result = true } else { result = false }
                    } else { result = false }
                    consumed = 6
                } else {
                    consumed = 4
                }
            } else if (pos+2 < tokens.size && tokens[pos+2] == "a") {
                // x is a child of y -> 6 tokens: x is a child of y
                if (pos+5 >= tokens.size) { break }
                let x = Int64.parse(tokens[pos])
                let y = Int64.parse(tokens[pos+5])
                let px = if (posMap.contains(x)) { posMap[x] } else { -1 }
                let py = if (posMap.contains(y)) { posMap[y] } else { -1 }
                if (px != -1 && py != -1) {
                    if (py == px/2) { result = true } else { result = false }
                } else { result = false }
                consumed = 6
            } else {
                consumed = 3
            }
        } else {
            // unknown, skip one
            consumed = 1
        }
        if (result) { println("T") } else { println("F") }
        pos += consumed
    }
}
