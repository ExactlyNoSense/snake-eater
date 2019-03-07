package idea.snakeskin.lang.psi

import com.intellij.psi.tree.IElementType
import idea.snakeskin.lang.SsLanguage

class SsTokenType(debugName: String) : IElementType(debugName, SsLanguage.INSTANCE) {
	override fun toString(): String {
		return "SsTokenType" + super.toString()
	}
}
