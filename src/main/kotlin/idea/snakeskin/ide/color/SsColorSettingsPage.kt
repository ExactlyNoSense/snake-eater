package idea.snakeskin.ide.color

import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.fileTypes.SyntaxHighlighter
import com.intellij.openapi.options.colors.AttributesDescriptor
import com.intellij.openapi.options.colors.ColorDescriptor
import com.intellij.openapi.options.colors.ColorSettingsPage
import com.intellij.openapi.util.io.StreamUtil
import idea.snakeskin.ide.highlight.SsSyntaxHighlighter
import idea.snakeskin.lang.SsIcons
import javax.swing.Icon

class SsColorSettingsPage : ColorSettingsPage {
	private val demoTemplate by lazy {
		val stream = javaClass.classLoader.getResourceAsStream("idea/snakeskin/ide/color/highlighterDemo.ss")
		StreamUtil.convertSeparators(StreamUtil.readText(stream, "UTF-8"))
	}

	override fun getHighlighter(): SyntaxHighlighter = SsSyntaxHighlighter()

	override fun getAdditionalHighlightingTagToDescriptorMap(): MutableMap<String, TextAttributesKey> = hashMapOf()

	override fun getIcon(): Icon? = SsIcons.FILE

	override fun getAttributeDescriptors(): Array<AttributesDescriptor> =
		SsColor.values().map{it.attributesDescriptor}.toTypedArray()

	override fun getColorDescriptors(): Array<ColorDescriptor> = ColorDescriptor.EMPTY_ARRAY

	override fun getDisplayName(): String = "Snakeskin"

	override fun getDemoText(): String = demoTemplate
}
