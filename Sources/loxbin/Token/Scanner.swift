class Scanner {
    let source: String
    var line = 1
    var start: Int
    var current: Int
    var tokens = [Token]()
    
    init(source: String) {
        self.source = source
        start = 0
        current = 0
    }
    
    enum ScannerError: Error {
        case unexpectedCharacter
    }
    
    func scanTokens() throws -> [Token] {
        while(!isAtEnd(index: current)) {
            start = current
            try scanToken()
            current += 1
        }
        
        tokens.append(Token(type: .eof, lexeme: "", literal: "", line: line))
        print(tokens)
        return tokens
    }
    
    func scanToken() throws {
        let character: Character = source[source.index(source.startIndex, offsetBy: current)]
        switch character {
        case "(": addToken(type: .leftParen)
        case ")": addToken(type: .rightParen)
        case "{": addToken(type: .leftBrace)
        case "}": addToken(type: .rightBrace)
        case ",": addToken(type: .comma)
        case ".": addToken(type: .dot)
        case "-": addToken(type: .minus)
        case "+": addToken(type: .plus)
        case ";": addToken(type: .semicolon)
        case "*": addToken(type: .star)
        case "!": addToken(type: match(expected: "=") ? .bangEqual : .bang)
        case "=": addToken(type: match(expected: "=") ? .equalEqual : .equal)
        case "<": addToken(type: match(expected: "=") ? .lessEqual : .less)
        case ">": addToken(type: match(expected: "=") ? .greaterEqual : .greater)
        case "/":
            if (match(expected: "/")) {
                while(peek() != "\n" && !isAtEnd(index: current)) {
                    current += 1
                }
            } else {
                addToken(type: .slash)
            }
        case " ", "\r", "\t": break
        case "\n": line += 1
        default: throw ScannerError.unexpectedCharacter
        }
    }
    
    private func peek() -> Character { // This is called a `lookahead`
        if isAtEnd(index: current + 1) { return "\0" }
        return source[source.index(source.startIndex, offsetBy: current + 1)]
    }
    
    private func addToken(type: TokenType) {
        addToken(type: type, literal: "")
    }
    
    private func addToken(type: TokenType, literal: String) {
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: current)
        let lexeme = String(source[startIndex...endIndex])
        
        tokens.append(Token(type: type, lexeme: lexeme, literal: literal, line: line))
    }
    
    private func match(expected: Character) -> Bool {
        guard !isAtEnd(index: current + 1) else { return false }
        if source[source.index(source.startIndex, offsetBy: current + 1)] != expected {
            return false
        }
        current += 1
        return true
    }
    
    private func isAtEnd(index: Int) -> Bool {
        index >= source.count
    }
}
