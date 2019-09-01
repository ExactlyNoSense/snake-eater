package idea.snakeskin.ide.color

import com.intellij.openapi.editor.DefaultLanguageHighlighterColors as Default
import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.options.colors.AttributesDescriptor

enum class SsColor(uiName: String, val fallback: TextAttributesKey? = null) {
	IDENTIFIER("Identifier", Default.IDENTIFIER),
	STRING("String", Default.STRING),
	NUMBER("Number", Default.NUMBER),

	BRACES("Braces and Operators//Braces", Default.BRACES),
	BRACKETS("Braces and Operators//Brackets", Default.BRACKETS),
	PARENTHESES("Braces and Operators//Parentheses", Default.PARENTHESES),
	DOT("Braces and Operators//Dot", Default.DOT),
	COMMA("Braces and Operators//Comma", Default.COMMA),
	SEMICOLON("Braces and Operators//Semicolon", Default.SEMICOLON),
	OPERATORS("Braces and Operators//Operators", Default.OPERATION_SIGN),
	;

	val textAttributesKey = TextAttributesKey.createTextAttributesKey("idea.snakeskin.$name", fallback)
	val attributesDescriptor = AttributesDescriptor(uiName, textAttributesKey)
}
