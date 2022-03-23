import ArgumentParser
import Foundation

@main
struct LoxBin: AsyncParsableCommand {
    @Argument(help: "The path to the file to be run")
    var filePath: String?
    
    func run() async throws {
        if let filePath = filePath {
            try runFile(withURL: URL(fileURLWithPath: filePath))
        } else {
            try runPrompt()
        }
    }
    
    private func runFile(withURL url: URL) throws {
        let contentsOfFile = try String(contentsOf: url, encoding: .utf8)
        print(contentsOfFile)
    }
    
    private func runPrompt() throws {
        while true {
            print("> ", terminator: "")
            guard let input = readLine() else { break }
            let tokens = try Scanner(source: input).scanTokens()
        }
    }
    
    private func error(line: Int, message: String) {
        report(line: line, where: "", message: message)
    }
    
    private func report(line: Int, where: String, message: String) {
        print("[line '\(line)'] Error \(`where`): \(message)")
    }
    
//    private func run(_ code: String) {
//        let scanner = Scanner(source: code)
//        let tokens = scanner.scanTokens()
//
//        tokens.forEach { print($0) }
//    }
}
