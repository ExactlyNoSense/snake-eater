package idea.snakeskin.ide.highlight

import com.intellij.lexer.Lexer
import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.fileTypes.SyntaxHighlighterBase
import com.intellij.psi.tree.IElementType
import idea.snakeskin.lang.lexer.SsLexer
import idea.snakeskin.ide.color.SsColor
import idea.snakeskin.lang.psi.SsElementTypes.*
import idea.snakeskin.lang.psi.SS_OPERATORS

class SsSyntaxHighlighter : SyntaxHighlighterBase() {
	companion object {
		fun map(tokenType: IElementType): SsColor? = when (tokenType) {
			IDENTIFIER, WITH_IDENTIFIER, GLOBAL_IDENTIFIER -> SsColor.IDENTIFIER
			STRING_LITERAL -> SsColor.STRING
			NUMERIC_LITERAL -> SsColor.NUMBER

			BRACE_OPEN, BRACE_CLOSE -> SsColor.BRACES
			BRACK_OPEN, BRACK_CLOSE -> SsColor.BRACKETS
			PAREN_OPEN, PAREN_CLOSE -> SsColor.PARENTHESES
			DOT -> SsColor.DOT
			COMMA -> SsColor.COMMA
			SEMICOLON -> SsColor.SEMICOLON
			in SS_OPERATORS -> SsColor.OPERATORS

			else -> null
		}
	}

	override fun getTokenHighlights(tokenType: IElementType): Array<TextAttributesKey> =
		pack(map(tokenType)?.textAttributesKey)

	override fun getHighlightingLexer(): Lexer = SsLexer(true)
}
