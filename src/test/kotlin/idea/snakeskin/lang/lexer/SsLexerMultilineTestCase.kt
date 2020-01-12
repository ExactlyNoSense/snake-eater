package idea.snakeskin.lang.lexer

class SsLexerMultilineTestCase : SsLexerTestCaseBase() {
	override fun getDirPath() = super.getDirPath() + "/multiline"

	fun testAmpDoesNotTreatAsMlOpen() = compare()
	fun testDecimalSeparatorDoesNotTreatAsMlCloseWhileParsingIsInMultilineMode() = compare()
	fun testDecimalSeparatorDoesNotTreatAsMlCloseWhileParsingIsNotInMultilineMode() = compare()
	fun testIdentifierSeparatorDoesNotTreatAsMlCloseWhileParsingIsInMultilineMode() = compare()
	fun testIdentifierSeparatorDoesNotTreatAsMlCloseWhileParsingIsNotInMultilineMode() = compare()

	fun testMlCloseOnNewLine() = compare()
	fun testMlCloseOnNewLineWithSpace() = compare()
	fun testMlCloseOnTheLastLine() = compare()
	fun testMlOpenInTheMiddleOfExpression() = compare()
	fun testSpacesAfterMlClose() = compare()
	fun testSpacesAfterMlOpen() = compare()
	fun testSpacesBeforeMlClose() = compare()
	fun testSpacesBeforeMlOpen() = compare()

	fun testXmlClassDotDoesNotTreatAsMlCloseWhileParsingIsInMultilineMode() = compare()
	fun testXmlClassDotDoesNotTreatAsMlCloseWhileParsingIsNotInMultilineMode() = compare()
}
