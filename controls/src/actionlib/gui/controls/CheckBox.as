package actionlib.gui.controls
{
	import actionlib.common.localization.MessageBundle;
	import actionlib.common.query.fromDisplay;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CheckBox extends TextButton
	{
		private var _checked:Boolean;
		private var _checkSprite:Sprite;

		public function CheckBox(content:Sprite, onClick:Function = null, bundle:MessageBundle = null)
		{
			super(content, onClick, bundle);
			refresh();
		}

		private function refresh():void
		{
			_checkSprite.visible = _checked;
		}

		override protected function assignStates():void
		{
			var children:Array = fromDisplay(this).select();

			_field = children.pop();
			_checkSprite = children.pop();
			_upState = children.pop();
			_overState = (children.length > 0) ? children.pop() : _upState;
			_downState = (children.length > 0) ? children.pop() : _overState;
		}


		override protected function onClick(event:MouseEvent):void
		{
			checked = !checked;
			clickEvent.dispatch();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get checked():Boolean
		{
			return _checked;
		}

		public function set checked(value:Boolean):void
		{
			_checked = value;
			refresh();
		}
	}
}