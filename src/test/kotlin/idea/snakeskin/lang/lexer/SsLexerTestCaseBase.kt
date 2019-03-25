package idea.snakeskin.lang.lexer

import com.intellij.testFramework.LexerTestCase
import java.nio.file.Paths

open class SsLexerTestCaseBase : LexerTestCase() {
	companion object {
		val BASE_PATH = "src/test/resources"
	}

	override fun getDirPath() = "lexer"

	override fun createLexer() = SsLexer()

	override fun getPathToTestDataFile(extension: String): String {
		return Paths.get(BASE_PATH, getTestName(true), extension).toString()
	}

	protected fun getActualFileExtension() = "ss"

	protected fun compare() {
		doFileTest(getActualFileExtension())
	}
}
