package idea.snakeskin.lang

import com.intellij.lang.Language

class SsLanguage private constructor(): Language("Snakeskin") {
	companion object {
	    val INSTANCE = SsLanguage()
	}
}
