package idea.snakeskin.ide.folding

import com.intellij.lang.ASTNode
import com.intellij.lang.folding.FoldingBuilderEx
import com.intellij.lang.folding.FoldingDescriptor
import com.intellij.openapi.editor.Document
import com.intellij.openapi.util.TextRange
import com.intellij.psi.PsiElement
import com.intellij.psi.PsiWhiteSpace
import com.intellij.psi.util.PsiTreeUtil
import idea.snakeskin.lang.psi.*

class SsFoldingBuilder : FoldingBuilderEx() {
	override fun getPlaceholderText(node: ASTNode) = "{ ... }"

	override fun buildFoldRegions(root: PsiElement, document: Document, quick: Boolean): Array<FoldingDescriptor> {
		val descriptors = mutableListOf<FoldingDescriptor>()

		fun findBlockBody(element: PsiElement): Int {
			when (element) {
				is SsBlockBody, is SsSwitchBlockBody, is SsLoopBlockBody, is SsCallBlockBody -> {
					val rangeStart = PsiTreeUtil.skipWhitespacesBackward(element)?.textRange?.startOffset
						?: element.textRange.startOffset

					var rangeEnd = rangeStart
					for (child in element.children) {
						val end = findBlockBody(child)
						rangeEnd = if (end > rangeEnd) end else rangeEnd
					}
					val textRange = TextRange(rangeStart, rangeEnd)
					descriptors.add(FoldingDescriptor(element, textRange))
					return rangeEnd
				}

				else -> {
					if (element.children.isEmpty()) {
						return element.textRange.endOffset
					}
					var last = element.lastChild
					if (last is PsiWhiteSpace) {
						last = PsiTreeUtil.skipWhitespacesBackward(last)
					}
					if (last == null) {
						// element has only one child - white space. Don't take it in account
						return element.textRange.startOffset
					}
					if (last is SsStatementEnd) {
						return last.textRange.startOffset
					}

					var offsetEnd = element.textRange.startOffset
					for (child in element.children) {
						val end = findBlockBody(child)
						offsetEnd = if (end > offsetEnd) end else offsetEnd
					}

					return offsetEnd
				}
			}
		}

		findBlockBody(root)
		return descriptors.toTypedArray()
	}

	override fun isCollapsedByDefault(node: ASTNode) = false
}
