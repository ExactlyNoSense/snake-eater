package idea.snakeskin.ide.color

import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.fileTypes.SyntaxHighlighter
import com.intellij.openapi.options.colors.AttributesDescriptor
import com.intellij.openapi.options.colors.ColorDescriptor
import com.intellij.openapi.options.colors.ColorSettingsPage
import idea.snakeskin.ide.highlight.SsSyntaxHighlighter
import idea.snakeskin.lang.SsIcons
import javax.swing.Icon

class SsColorSettingsPage : ColorSettingsPage {
	override fun getHighlighter(): SyntaxHighlighter = SsSyntaxHighlighter()

	override fun getAdditionalHighlightingTagToDescriptorMap(): MutableMap<String, TextAttributesKey> = hashMapOf()

	override fun getIcon(): Icon? = SsIcons.FILE

	override fun getAttributeDescriptors(): Array<AttributesDescriptor> =
		SsColor.values().map{it.attributesDescriptor}.toTypedArray()

	override fun getColorDescriptors(): Array<ColorDescriptor> = ColorDescriptor.EMPTY_ARRAY

	override fun getDisplayName(): String = "Snakeskin color dialog"

	override fun getDemoText(): String = "- namespace demo"
}
