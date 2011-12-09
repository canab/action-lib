package actionlib.gui.utils
{
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextUtil
	{
		private static var _fontMapping:Object = {};

		public static function mapFont(sourceFont:String, targetFont:String):void
		{
			_fontMapping[sourceFont] = targetFont;
		}

		public static function fitText(field:TextField):void
		{
			var format:TextFormat = field.getTextFormat();
			var size:Number = format.size as Number;
			while ((field.textWidth + 5 > field.width || field.textHeight > field.height) && size > 6)
			{
				format.size = --size;
				field.setTextFormat(format);
			}
		}

		public static function initTextField(field:TextField):void
		{
			field.wordWrap = field.multiline;
			field.selectable = false;
			field.mouseEnabled = false;
			applyFont(field);
		}

		public static function initInputField(field:TextField):void
		{
			applyFont(field);
		}

		public static function applyFont(field:TextField):void
		{
			field.gridFitType = GridFitType.PIXEL;
			field.antiAliasType = AntiAliasType.ADVANCED;
			var format:TextFormat = field.getTextFormat();
			var fontName:String = _fontMapping[format.font];

			if (fontName)
			{
				field.embedFonts = true;
				format.font = fontName;
			}
			else
			{
				field.embedFonts = false;
				field.background = true;
				field.backgroundColor = 0x000000;
				format.color = 0xFF0000;
				format.font = "_typewriter";
			}

			field.defaultTextFormat = format;
		}
	}
}
