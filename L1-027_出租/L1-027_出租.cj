// L1-027 出租 - arr descending unique digits, index mapping
import std.env.*
main() {
    let cin = getStdIn()
    let all = cin.readToEnd() ?? ""
    var phone = ""
    for (c in all.toRuneArray()) {
        if (c >= r'0' && c <= r'9') { phone += c.toString() }
        else if (c == r'\n' || c == r'\r') {
            if (phone.size > 0) { break }
        }
    }
    if (phone.size == 0) { phone = all.trimAscii() }
    var present = Array<Bool>(10, repeat: false)
    for (c in phone.toRuneArray()) {
        if (c >= r'0' && c <= r'9') {
            // digit value via offset from '0'
            var d: Int64 = 0
            if (c == r'0') { d = 0 } else if (c == r'1') { d = 1 } else if (c == r'2') { d = 2 }
            else if (c == r'3') { d = 3 } else if (c == r'4') { d = 4 } else if (c == r'5') { d = 5 }
            else if (c == r'6') { d = 6 } else if (c == r'7') { d = 7 } else if (c == r'8') { d = 8 }
            else if (c == r'9') { d = 9 }
            present[d] = true
        }
    }
    var arrVals = Array<Int64>(0, repeat: 0)
    var d: Int64 = 9
    while (d >= 0) {
        if (present[d]) {
            var tmp = Array<Int64>(arrVals.size + 1, repeat: 0)
            var k: Int64 = 0
            while (k < arrVals.size) { tmp[k] = arrVals[k]; k += 1 }
            tmp[arrVals.size] = d
            arrVals = tmp
        }
        d -= 1
    }
    var digitToIdx = Array<Int64>(10, repeat: -1)
    var idx: Int64 = 0
    while (idx < arrVals.size) {
        let dig = arrVals[idx]
        digitToIdx[dig] = idx
        idx += 1
    }
    var sbArr = StringBuilder()
    sbArr.append("int[] arr = new int[]{")
    var k: Int64 = 0
    while (k < arrVals.size) {
        if (k > 0) { sbArr.append(",") }
        sbArr.append(arrVals[k])
        k += 1
    }
    sbArr.append("};")
    println(sbArr.toString())
    var sbIdx = StringBuilder()
    sbIdx.append("int[] index = new int[]{")
    let runes = phone.toRuneArray()
    var p: Int64 = 0
    while (p < runes.size) {
        if (p > 0) { sbIdx.append(",") }
        let c = runes[p]
        var dig: Int64 = 0
        if (c == r'0') { dig = 0 } else if (c == r'1') { dig = 1 } else if (c == r'2') { dig = 2 }
        else if (c == r'3') { dig = 3 } else if (c == r'4') { dig = 4 } else if (c == r'5') { dig = 5 }
        else if (c == r'6') { dig = 6 } else if (c == r'7') { dig = 7 } else if (c == r'8') { dig = 8 }
        else if (c == r'9') { dig = 9 }
        let id = digitToIdx[dig]
        sbIdx.append(id)
        p += 1
    }
    sbIdx.append("};")
    println(sbIdx.toString())
}
