package idea.snakeskin.ide.highlight

import com.intellij.openapi.fileTypes.SingleLazyInstanceSyntaxHighlighterFactory

class SsSyntaxHighlighterFactory : SingleLazyInstanceSyntaxHighlighterFactory() {
	override fun createHighlighter() = SsSyntaxHighlighter()
}
