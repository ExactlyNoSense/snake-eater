package idea.snakeskin.lang.psi

import com.intellij.psi.tree.IElementType
import com.intellij.psi.tree.TokenSet
import idea.snakeskin.lang.SsLanguage
import idea.snakeskin.lang.psi.SsElementTypes.*

class SsTokenType(debugName: String) : IElementType(debugName, SsLanguage.INSTANCE) {
	override fun toString(): String {
		return "SsTokenType." + super.toString()
	}
}

fun tokensSet(vararg tokens: IElementType) = TokenSet.create(*tokens)

val SS_OPERATORS = tokensSet(
	COLON, SEMICOLON, QUESTION,
	EQ, EQ_EQ, EQ_EQ_EQ, EXCLAMATION, NOT_EQ, NOT_EQ_EQ,
	PLUS, PLUS_PLUS, PLUS_EQ, MINUS, MINUS_MINUS, MINUS_EQ,
	ASTERISK, ASTERISK_EQ, SLASH, SLASH_EQ, PERCENT, PERCENT_EQ,
	PIPE, PIPE_PIPE, PIPE_EQ, AMP, AMP_AMP, AMP_EQ, CARET, CARET_EQ, TILDE,
	LT, LT_LT, LT_EQ, LT_LT_EQ, GT, GT_GT, GT_GT_GT, GT_EQ, GT_GT_EQ, GT_GT_GT_EQ
)

val SS_KEYWORDS = tokensSet(
	AS,
	ASYNC,
	BLOCK,
	BREAK,
	CALL,
	CASE,
	CATCH,
	CONST,
	CONTINUE,
	DEFAULT,
	DELETE,
	DO,
	DOCTYPE,
	ELSE,
	EXTENDS,
	EVAL,
	FROM,
	FINALLY,
	FOR,
	FOREACH,
	FORIN,
	FUNC,
	GLOBAL,
	HEAD,
	IF,
	IMPORT,
	IN,
	INCLUDE,
	INTERFACE,
	INSTANCEOF,
	LINK,
	NAMESPACE,
	NEW,
	OUTPUT,
	PLACEHOLDER,
	PUT_IN,
	RETURN,
	SCRIPT,
	STYLE,
	SUPER,
	SWITCH,
	TAG,
	TARGET,
	TEMPLATE,
	THROW,
	TRY,
	TYPEOF,
	UNLESS,
	VAR,
	VOID,
	WHILE,
	WITH,
	NULL_LITERAL,
	UNDEFINED_LITERAL,
	BOOLEAN_LITERAL
)
