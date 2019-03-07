package idea.snakeskin.lang

import com.intellij.openapi.fileTypes.LanguageFileType
import javax.swing.Icon

class SnakeFileType : LanguageFileType(SnakeLanguage.INSTANCE) {
	companion object {
	    val INSTANCE = SnakeFileType()
	}

	override fun getIcon(): Icon? {
		return SnakeIcons.FILE
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
