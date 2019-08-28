package idea.snakeskin.ide.color

import com.intellij.openapi.editor.DefaultLanguageHighlighterColors
import com.intellij.openapi.editor.colors.TextAttributesKey

enum class SsColor(name: String, val fallback: TextAttributesKey? = null) {
	IDENTIFIER("identifier", DefaultLanguageHighlighterColors.IDENTIFIER),
	STRING("string", DefaultLanguageHighlighterColors.STRING);

	val textAttributesKey = TextAttributesKey.createTextAttributesKey("idea.snakeskin.$name", fallback)
}
