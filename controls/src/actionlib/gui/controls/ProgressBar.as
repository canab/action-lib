package actionlib.gui.controls
{
	import actionlib.common.utils.MathUtil;

	import flash.display.Sprite;

	public class ProgressBar extends ControlBase
	{
		static public const LINE_NAME:String = 'mcLine';

		private var _line:Sprite;
		private var _lineStartX:Number;
		private var _lineEndX:Number;

		private var _value:Number;

		public function ProgressBar(content:Sprite)
		{
			_line = content[LINE_NAME];

			wrapTarget(content);
			initialize();
		}

		private function initialize():void
		{
			_lineEndX = _line.x;
			_lineStartX = _line.x - _line.width;

			value = 0;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			if (_value != value)
			{
				_value = MathUtil.claimRange(value, 0, 1);
				_line.x = _lineStartX + value * (_lineEndX - _lineStartX);
			}
		}
	}

}