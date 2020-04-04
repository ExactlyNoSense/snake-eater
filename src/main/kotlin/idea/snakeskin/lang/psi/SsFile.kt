package idea.snakeskin.lang.psi

import com.intellij.extapi.psi.PsiFileBase
import com.intellij.openapi.fileTypes.FileType
import com.intellij.psi.FileViewProvider
import idea.snakeskin.lang.SsFileType
import idea.snakeskin.lang.SsLanguage

class SsFile(fileViewProvider: FileViewProvider) : PsiFileBase(fileViewProvider, SsLanguage.INSTANCE) {
	override fun getFileType(): FileType = SsFileType
}
