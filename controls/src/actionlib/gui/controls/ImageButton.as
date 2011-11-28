package actionlib.gui.controls
{
	import actionlib.common.localization.MessageBundle;
	import actionlib.common.query.fromDisplay;

	import flash.display.Sprite;

	public class ImageButton extends PushButton
	{
		private var _image:Sprite;

		public function ImageButton(content:Sprite, onClick:Function = null, bundle:MessageBundle = null)
		{
			super(content, onClick, bundle);
		}

		override protected function assignStates():void
		{
			var children:Array = fromDisplay(this).select();

			_image = children.pop();
			_upState = children.pop();
			_overState = (children.length > 0) ? children.pop() : _upState;
			_downState = (children.length > 0) ? children.pop() : _overState;
		}

		public function get image():Sprite
		{
			return _image;
		}
	}
}
