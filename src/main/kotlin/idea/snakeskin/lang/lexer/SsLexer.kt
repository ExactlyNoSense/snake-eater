package idea.snakeskin.lang.lexer

import com.intellij.lexer.FlexAdapter

class SsLexer(isHighlighter: Boolean) : FlexAdapter(SnakeskinLexer(isHighlighter))
