struct Token: CustomDebugStringConvertible {
    let type: TokenType
    let lexeme: String
    let literal: String
    let line: Int
    
    var debugDescription: String {
        "\(lexeme)"
    }
}
