package idea.snakeskin.ide.highlight

import com.intellij.lexer.Lexer
import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.fileTypes.SyntaxHighlighterBase
import com.intellij.psi.tree.IElementType
import idea.snakeskin.lang.lexer.SsLexer
import idea.snakeskin.ide.color.SsColor
import idea.snakeskin.lang.psi.SsElementTypes.*

class SsSyntaxHighlighter : SyntaxHighlighterBase() {
	companion object {
		fun map(tokenType: IElementType): SsColor? = when (tokenType) {
			IDENTIFIER -> SsColor.IDENTIFIER
			STRING_LITERAL -> SsColor.STRING
			NUMERIC_LITERAL -> SsColor.NUMBER

			else -> null
		}
	}

	override fun getTokenHighlights(tokenType: IElementType): Array<TextAttributesKey> =
		pack(map(tokenType)?.textAttributesKey)

	override fun getHighlightingLexer(): Lexer = SsLexer()
}
