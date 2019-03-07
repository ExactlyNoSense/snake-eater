package idea.snakeskin.lang

import com.intellij.lang.Language

class SnakeLanguage private constructor(): Language("Snakeskin") {
	companion object {
	    val INSTANCE = SnakeLanguage()
	}
}
