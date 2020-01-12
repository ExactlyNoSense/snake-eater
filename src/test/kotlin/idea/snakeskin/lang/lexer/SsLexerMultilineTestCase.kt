package idea.snakeskin.lang.lexer

class SsLexerMultilineTestCase: SsLexerTestCaseBase() {
	override fun getDirPath() = super.getDirPath() + "/multiline";

	fun testMlCloseOnNewLine() = compare()
	fun testMlCloseOnNewLineWithSpace() = compare()
	fun testMlCloseOnTheLastLine() = compare()
	fun testMlOpenInTheMiddleOfExpression() = compare()
}
