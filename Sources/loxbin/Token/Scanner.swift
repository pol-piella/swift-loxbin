class Scanner {
    let source: String
    var line = 1
    var start: Int
    var current: Int
    var tokens = [Token]()
    
    let keywords: [String: TokenType] = [
        "and": .and,
        "class": .class,
        "else": .else,
        "false": .false,
        "for": .for,
        "fun": .fun,
        "if": .if,
        "nil": .nil,
        "or": .or,
        "print": .print,
        "return": .return,
        "super": .super,
        "this": .this,
        "true": .true,
        "var": .var,
        "while": .while
    ]
    
    init(source: String) {
        self.source = source
        start = 0
        current = 0
    }
    
    enum ScannerError: Error {
        case unexpectedCharacter
        case unterminatedString
    }
    
    func scanTokens() throws -> [Token] {
        while(!isAtEnd(index: current)) {
            start = current
            try scanToken()
            current += 1
        }
        
        tokens.append(Token(type: .eof, lexeme: "", literal: nil, line: line))
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
        case "\"": try string()
        default:
            if isDigit(character) {
                number()
            } else if isAlpha(character) {
                identifier()
            } else {
                throw ScannerError.unexpectedCharacter
            }
        }
    }
    
    private func identifier() {
        while isAlpha(peek()) { current += 1 }
        
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: current)
        let lexeme = String(source[startIndex...endIndex])
        
        if let tokenType = keywords[lexeme] {
            addToken(type: tokenType)
        } else {
            addToken(type: .identifier)
        }
    }
    
    private func isAlphaNumeric(_ character: Character) -> Bool {
        isDigit(character) || isAlpha(character)
    }
    
    private func isAlpha(_ character: Character) -> Bool {
        character.isLetter || character == "_"
    }
    
    private func number() {
        while isDigit(peek()) { current += 1 }
        
        if (peek() == "." && isDigit(peekNext())) {
            // Add the '.' to the sequence...
            current += 1
            
            while (isDigit(peek())) { current += 1 }
        }
        
        let literal = String(source[source.index(source.startIndex, offsetBy: start)...source.index(source.startIndex, offsetBy: current)])
        addToken(type: .number, literal: Double(literal))
    }
    
    private func peekNext() -> Character {
        if isAtEnd(index: current + 2) { return "\0" }
        return source[source.index(source.startIndex, offsetBy: current + 2)]
    }
    
    private func isDigit(_ character: Character) -> Bool {
        character.isNumber
    }
    
    private func string() throws {
        while(peek() != "\"" && !isAtEnd(index: current)) {
            // Scan through the string...
            if peek() == "\n" { line += 1 } // Multiline strings are allowed
            current += 1
        }
        
        // Make sure that string is terminated
        if isAtEnd(index: current) {
            throw ScannerError.unterminatedString
        }
        
        // Grab the closing `"`
        current += 1
        
        // Get the string literal...
        var value = String(source[source.index(source.startIndex, offsetBy: start)...source.index(source.startIndex, offsetBy: current)])
        // Removes opening and closing `"`
        value.removeFirst()
        value.removeLast()
        addToken(type: .string, literal: value)
    }
    
    private func peek() -> Character { // This is called a `lookahead`
        if isAtEnd(index: current + 1) { return "\0" }
        return source[source.index(source.startIndex, offsetBy: current + 1)]
    }
    
    private func addToken(type: TokenType) {
        addToken(type: type, literal: nil)
    }
    
    private func addToken(type: TokenType, literal: Any?) {
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
