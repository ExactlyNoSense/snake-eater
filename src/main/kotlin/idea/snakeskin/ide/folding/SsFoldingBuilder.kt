package idea.snakeskin.ide.folding

import com.intellij.lang.ASTNode
import com.intellij.lang.folding.FoldingBuilderEx
import com.intellij.lang.folding.FoldingDescriptor
import com.intellij.openapi.editor.Document
import com.intellij.psi.PsiElement
import idea.snakeskin.lang.psi.SsBlockBody

class SsFoldingBuilder : FoldingBuilderEx() {
	override fun getPlaceholderText(node: ASTNode) = "{ lol }"

	override fun buildFoldRegions(root: PsiElement, document: Document, quick: Boolean): Array<FoldingDescriptor> {
		val descriptors = mutableListOf<FoldingDescriptor>()

		fun findBlockBody(element: PsiElement) {
			when(element){
				is SsBlockBody -> {
					descriptors.add(FoldingDescriptor(element, element.getTextRange()))
				}

				else -> element.children.forEach(::findBlockBody)
			}
		}

		findBlockBody(root)
		return descriptors.toTypedArray()
	}

	override fun isCollapsedByDefault(node: ASTNode) = false
}
