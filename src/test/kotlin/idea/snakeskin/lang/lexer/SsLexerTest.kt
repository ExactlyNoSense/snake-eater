package idea.snakeskin.lang.lexer

import com.intellij.lexer.Lexer
import com.intellij.testFramework.LexerTestCase

class SsLexerTest : LexerTestCase() {
	override fun getDirPath(): String {
		return "";
	}

	override fun createLexer(): Lexer {
		return SsLexer();
	}

	override fun getPathToTestDataFile(extension: String): String {
		return "src/test/resources/lexer/" + getTestName(true) + extension;
	}

	public fun testLineSplitting() {
		doFileTest("ss");
	}
}
