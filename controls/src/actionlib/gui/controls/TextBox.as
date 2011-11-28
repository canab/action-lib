package actionlib.gui.controls
{
	import actionlib.common.localization.MessageBundle;
	import actionlib.gui.utils.TextUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class TextBox extends ControlBase
	{
		private var _field:TextField;
		private var _background:MovieClip;
		private var _text:String;

		public function TextBox(content:Sprite, bundle:MessageBundle = null)
		{
			_background = MovieClip(content.getChildAt(0));
			_field = TextField(content.getChildAt(1));

			setBundle(bundle || defaultBundle);
			wrapContent(content);
			initialize();
		}

		private function initialize():void
		{
			_field.selectable = false;
			_field.wordWrap = false;

			TextUtil.initTextField(_field);
			text = _field.text;
		}

		override protected function applyLocalization():void
		{
			_field.text = bundle.getLocalizedText(text);
			adjustSize();
		}

		private function adjustSize():void
		{
			_field.width = _field.textWidth + 10;
			_background.width = _field.width + 2 * _field.x;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			applyLocalization();
		}
	}
}