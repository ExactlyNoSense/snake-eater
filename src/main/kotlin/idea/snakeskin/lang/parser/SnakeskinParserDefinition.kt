package idea.snakeskin.lang.parser

import com.intellij.lang.ASTNode
import com.intellij.lang.ParserDefinition
import com.intellij.lang.PsiParser
import com.intellij.lexer.Lexer
import com.intellij.openapi.project.Project
import com.intellij.psi.FileViewProvider
import com.intellij.psi.PsiElement
import com.intellij.psi.PsiFile
import com.intellij.psi.tree.IFileElementType
import com.intellij.psi.tree.TokenSet
import idea.snakeskin.lang.SsLanguage
import idea.snakeskin.lang.lexer.SsLexer
import idea.snakeskin.lang.psi.SsElementTypes
import idea.snakeskin.lang.psi.SsElementTypes.COMMENT_BLOCK
import idea.snakeskin.lang.psi.SsElementTypes.STRING_LITERAL
import idea.snakeskin.lang.psi.SsFile

class SnakeskinParserDefinition : ParserDefinition {
	companion object {
		val FILE = IFileElementType(SsLanguage.INSTANCE)
	}

	override fun createFile(viewProvider: FileViewProvider): PsiFile = SsFile(viewProvider)

	override fun getStringLiteralElements(): TokenSet = TokenSet.create(STRING_LITERAL)

	override fun getFileNodeType(): IFileElementType = FILE

	override fun createLexer(project: Project?): Lexer = SsLexer()

	override fun createElement(node: ASTNode?): PsiElement = SsElementTypes.Factory.createElement(node)

	override fun getCommentTokens(): TokenSet = TokenSet.create(COMMENT_BLOCK)

	override fun createParser(project: Project?): PsiParser = SnakeskinParser()
}
