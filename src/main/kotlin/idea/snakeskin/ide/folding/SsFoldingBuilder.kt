package idea.snakeskin.ide.folding

import com.intellij.lang.ASTNode
import com.intellij.lang.folding.FoldingBuilderEx
import com.intellij.lang.folding.FoldingDescriptor
import com.intellij.openapi.editor.Document
import com.intellij.openapi.util.TextRange
import com.intellij.psi.PsiElement
import com.intellij.psi.util.PsiTreeUtil
import idea.snakeskin.lang.psi.SsBlockBody

class SsFoldingBuilder : FoldingBuilderEx() {
	override fun getPlaceholderText(node: ASTNode) = "{ ... }"

	override fun buildFoldRegions(root: PsiElement, document: Document, quick: Boolean): Array<FoldingDescriptor> {
		val descriptors = mutableListOf<FoldingDescriptor>()

		fun findBlockBody(element: PsiElement) {
			when(element){
				is SsBlockBody -> {
					val rangeStart = PsiTreeUtil.skipWhitespacesBackward(element)?.textRange?.startOffset
						?: element.textRange.startOffset
					val rangeEnd = element.lastChild?.prevSibling?.textRange?.endOffset
						?: element.textRange.endOffset
					val textRange = TextRange(rangeStart, rangeEnd)
					descriptors.add(FoldingDescriptor(element, textRange))
				}

				else -> element.children.forEach(::findBlockBody)
			}
		}

		findBlockBody(root)
		return descriptors.toTypedArray()
	}

	override fun isCollapsedByDefault(node: ASTNode) = false
}
