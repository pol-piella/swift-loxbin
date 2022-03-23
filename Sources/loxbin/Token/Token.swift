struct Token: CustomDebugStringConvertible {
    let type: TokenType
    let lexeme: String
    let literal: Any?
    let line: Int
    
    var debugDescription: String {
        "\(lexeme)"
    }
}
