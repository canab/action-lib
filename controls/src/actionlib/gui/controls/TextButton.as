package actionlib.gui.controls
{
	import actionlib.common.localization.MessageBundle;
	import actionlib.common.query.fromDisplay;
	import actionlib.gui.utils.TextUtil;

	import flash.display.Sprite;
	import flash.text.TextField;

	public class TextButton extends PushButton
	{
		protected var _field:TextField;
		private var _text:String;

		public function TextButton(content:Sprite, onClick:Function = null, bundle:MessageBundle = null)
		{
			super(content, onClick);
			setBundle(bundle || defaultBundle);
			initText();
		}

		override protected function assignStates():void
		{
			var children:Array = fromDisplay(this).select();

			_field = children.pop();
			_upState = children.pop();
			_overState = (children.length > 0) ? children.pop() : _upState;
			_downState = (children.length > 0) ? children.pop() : _overState;
		}

		protected function initText():void
		{
			TextUtil.initTextField(_field);

			var isDefinedInField:Boolean = _field.text.indexOf("{") >= 0
					&& _field.text.indexOf("}") > 0;

			text = isDefinedInField ? _field.text : TextUtil.surroundWithBraces(name);
		}

		override protected function applyLocalization():void
		{
			_field.text = bundle.getLocalizedText(text);
			TextUtil.fitText(_field);
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