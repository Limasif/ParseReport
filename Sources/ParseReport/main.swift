import Foundation
import AppKit
import PathKit
import SwiftCSV
import ArgumentParser

enum Key: String {
    case task = "Ключ запроса"
    case title = "Тема запроса"
    case date = "Дата работы"
}

func run(with path: Path) {
    var parseResult: [Date: String] = [:]

    let csv = try? CSV<Named>(url: path.url, encoding: .utf8, loadColumns: true)
    csv?.content.rows.forEach {
        guard
            let date = Date.parse($0[Key.date.rawValue]),
            let title = $0[Key.title.rawValue],
            let task = $0[Key.task.rawValue]
        else { return }

        if let value = parseResult[date] {
            parseResult[date] = value.appending(", [\(task)] \(title)")
        } else {
            parseResult[date] = "[\(task)] \(title)"
        }
    }

    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([.string], owner: nil)
    pasteboard.setString(generateResult(from: parseResult), forType: .string)
}

func generateResult(from dict: [Date: String]) -> String {
    var result = ""

    dict.sorted(by: { $0.key < $1.key }).forEach {
        result.append("\($0.key.string)\t8\t0\tGeneral\t\($0.value)\n")
    }

    return result
}

extension Date {
    static let dateParseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    static let stringParseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static func parse(_ string: String?) -> Date? {
        guard let string else { return nil }
        return Date.dateParseFormatter.date(from: string)
    }

    var string: String {
        Date.stringParseFormatter.string(from: self)
    }
}

struct Parse: ParsableCommand {
    @Option(name: .shortAndLong, help: "The file path to read.")
    var input: String

    mutating func run() throws {
        let path = Path(input)
        guard path.exists else { throw RuntimeError("File \(input) does not exist.") }
        guard path.extension == "csv" else { throw RuntimeError("File \(input) must be .csv type.") }
        guard path.isReadable else { throw RuntimeError("Can not read file \(input).") }
        ParseReport.run(with: path)
        print("Result successfully copied to clipboard.")
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String

    init(_ description: String) {
        self.description = description
    }
}

Parse.main()
