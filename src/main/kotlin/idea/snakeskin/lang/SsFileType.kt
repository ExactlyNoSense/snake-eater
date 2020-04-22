package idea.snakeskin.lang

import com.intellij.openapi.fileTypes.LanguageFileType

object SsFileType : LanguageFileType(SsLanguage.INSTANCE) {
	override fun getIcon() = SsIcons.FILE

	override fun getName() = "Snakeskin"

	override fun getDefaultExtension() = "ss"

	override fun getDescription() = "Snakeskin template language file"
}
