package idea.snakeskin.lang

import com.intellij.openapi.fileTypes.LanguageFileType
import javax.swing.Icon

class SsFileType : LanguageFileType(SsLanguage.INSTANCE) {
	companion object {
	    val INSTANCE = SsFileType()
	}

	override fun getIcon(): Icon? {
		return SsIcons.FILE
	}

	override fun getName(): String {
		return "Snakeskin file"
	}

	override fun getDefaultExtension(): String {
		return "ss"
	}

	override fun getDescription(): String {
		return "Snakeskin template language file"
	}
}
