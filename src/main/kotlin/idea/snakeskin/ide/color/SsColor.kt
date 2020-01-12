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
	MULTILINE("Braces and Operators//Multiline", Default.BRACES),

	DOT("Braces and Operators//Dot", Default.DOT),
	COMMA("Braces and Operators//Comma", Default.COMMA),
	SEMICOLON("Braces and Operators//Semicolon", Default.SEMICOLON),
	OPERATORS("Braces and Operators//Operators", Default.OPERATION_SIGN),

	KEYWORD("Keyword", Default.KEYWORD),

	TAG("Markup//Tag", Default.MARKUP_TAG),
	ATTRIBUTE_KEY("Markup//Attribute key", Default.MARKUP_ATTRIBUTE),
	ATTRIBUTE_VALUE("Markup//Attribute value", Default.STRING),
	TEXT("Markup//Text", Default.TEMPLATE_LANGUAGE_COLOR),

	COMMENT("Comment", Default.BLOCK_COMMENT)
	;

	val textAttributesKey = TextAttributesKey.createTextAttributesKey("idea.snakeskin.$name", fallback)
	val attributesDescriptor = AttributesDescriptor(uiName, textAttributesKey)
}
