package idea.snakeskin.ide.commenter

import com.intellij.lang.Commenter

class SsCommenter : Commenter {
	override fun getCommentedBlockCommentPrefix(): String? = null
	override fun getCommentedBlockCommentSuffix(): String? = null

	override fun getBlockCommentPrefix(): String? = "/*"
	override fun getBlockCommentSuffix(): String? = "*/"

	override fun getLineCommentPrefix(): String? = "///"
}
