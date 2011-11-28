package actionlib.gui.controls
{
	import actionlib.common.localization.MessageBundle;

	import flash.display.Sprite;

	public class LinkButton extends TextButton
	{

		public function LinkButton(content:Sprite, onClick:Function = null, bundle:MessageBundle = null)
		{
			super(content, onClick, bundle);
			content.hitArea = Sprite(_overState);
		}

		override protected function applyLocalization():void
		{
			super.applyLocalization();

			var left:int = _field.x + _field.getCharBoundaries(0).left;
			var right:int = _field.x + _field.getCharBoundaries(_field.text.length - 1).right;
			var width:int = right - left;

			_upState.width = width + 4;
			_upState.x = 0.5 * (left + right - _upState.width) + 1;

			_overState.width = width + 0.6 * _overState.height;
			_overState.x = 0.5 * (left + right - _overState.width);

			hitArea.x = _overState.x;
			hitArea.width = _overState.width;
		}


	}
}