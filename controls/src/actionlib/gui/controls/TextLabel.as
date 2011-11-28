package actionlib.gui.controls
{
	import actionlib.common.localization.MessageBundle;
	import actionlib.gui.utils.TextUtil;

	import flash.text.TextField;

	public class TextLabel extends ControlBase
	{
		private var _field:TextField;
		private var _text:String;

		public function TextLabel(field:TextField, bundle:MessageBundle = null)
		{
			_field = field;

			setBundle(bundle || defaultBundle);
			wrapTarget(field);
			initialize();
		}

		private function initialize():void
		{
			TextUtil.initTextField(_field);
			text = _field.text
		}

		override protected function applyLocalization():void
		{
			_field.text = (bundle) ? bundle.getLocalizedText(text) : text;
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