package idea.snakeskin.ide.color

import com.intellij.openapi.editor.DefaultLanguageHighlighterColors
import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.options.colors.AttributesDescriptor

enum class SsColor(uiName: String, val fallback: TextAttributesKey? = null) {
	IDENTIFIER("identifier", DefaultLanguageHighlighterColors.IDENTIFIER),
	STRING("string", DefaultLanguageHighlighterColors.STRING);

	val textAttributesKey = TextAttributesKey.createTextAttributesKey("idea.snakeskin.$name", fallback)
	val attributesDescriptor = AttributesDescriptor(uiName, textAttributesKey)
}
