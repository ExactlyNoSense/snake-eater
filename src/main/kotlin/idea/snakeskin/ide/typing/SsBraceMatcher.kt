package idea.snakeskin.ide.typing

import com.intellij.lang.BracePair
import com.intellij.lang.PairedBraceMatcher
import com.intellij.psi.PsiFile
import com.intellij.psi.tree.IElementType
import idea.snakeskin.lang.psi.SsElementTypes.*

class SsBraceMatcher : PairedBraceMatcher {
	override fun getCodeConstructStart(file: PsiFile?, openingBraceOffset: Int): Int = openingBraceOffset

	override fun getPairs(): Array<BracePair> = PAIRS

	override fun isPairedBracesAllowedBeforeType(lbraceType: IElementType, contextType: IElementType?): Boolean = true

	companion object {
	    private val PAIRS: Array<BracePair> = arrayOf(
			BracePair(BRACE_OPEN, BRACE_CLOSE, false),
			BracePair(BRACK_OPEN, BRACK_CLOSE, false),
			BracePair(PAREN_OPEN, PAREN_CLOSE, false),
			BracePair(INTERPOLATION_OPEN, INTERPOLATION_CLOSE, false),
			BracePair(BRACE_OPEN_OPEN, BRACE_CLOSE_CLOSE, false)
		)
	}
}
