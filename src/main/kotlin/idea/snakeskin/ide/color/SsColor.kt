package idea.snakeskin.ide.color

import com.intellij.openapi.editor.DefaultLanguageHighlighterColors as Default
import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.editor.XmlHighlighterColors
import com.intellij.openapi.options.colors.AttributesDescriptor

enum class SsColor(uiName: String, val fallback: TextAttributesKey? = null) {
	IDENTIFIER("Identifier", Default.IDENTIFIER),
	STRING("String", Default.STRING),
	NUMBER("Number", Default.NUMBER),
	REGEXP("Regular expression", Default.STRING),

	BRACES("Braces and Operators//Braces", Default.BRACES),
	BRACKETS("Braces and Operators//Brackets", Default.BRACKETS),
	PARENTHESES("Braces and Operators//Parentheses", Default.PARENTHESES),
	MULTILINE("Braces and Operators//Multiline", Default.BRACES),

	DOT("Braces and Operators//Dot", Default.DOT),
	COMMA("Braces and Operators//Comma", Default.COMMA),
	SEMICOLON("Braces and Operators//Semicolon", Default.SEMICOLON),
	OPERATORS("Braces and Operators//Operators", Default.OPERATION_SIGN),

	KEYWORD("Keyword", Default.KEYWORD),

	XML_NAME("Markup//Xml name", XmlHighlighterColors.HTML_TAG_NAME),
	ATTRIBUTE_VALUE("Markup//Attribute value", XmlHighlighterColors.HTML_ATTRIBUTE_VALUE),
	TEXT("Markup//Text", XmlHighlighterColors.HTML_CODE),

	COMMENT("Comment", Default.BLOCK_COMMENT)
	;

	val textAttributesKey = TextAttributesKey.createTextAttributesKey("idea.snakeskin.$name", fallback)
	val attributesDescriptor = AttributesDescriptor(uiName, textAttributesKey)
}
