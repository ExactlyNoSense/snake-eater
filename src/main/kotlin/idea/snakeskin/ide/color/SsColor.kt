package idea.snakeskin.ide.color

import com.intellij.openapi.editor.DefaultLanguageHighlighterColors as Default
import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.options.colors.AttributesDescriptor

enum class SsColor(uiName: String, val fallback: TextAttributesKey? = null) {
	IDENTIFIER("Identifier", Default.IDENTIFIER),
	STRING("String", Default.STRING),
	NUMBER("Number", Default.NUMBER),
	;

	val textAttributesKey = TextAttributesKey.createTextAttributesKey("idea.snakeskin.$name", fallback)
	val attributesDescriptor = AttributesDescriptor(uiName, textAttributesKey)
}
