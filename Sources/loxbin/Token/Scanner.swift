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
        while(!isAtEnd()) {
            start = current
            try scanToken()
            current += 1
        }
        
        tokens.append(Token(type: .eof, lexeme: "", literal: "", line: line))
        return tokens
    }
    
    func scanToken() throws {
        let character = String(source[source.index(source.startIndex, offsetBy: current)])
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
        default: throw ScannerError.unexpectedCharacter
        }
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
    
    private func isAtEnd() -> Bool {
        current >= source.count
    }
}
