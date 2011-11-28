package actionlib.motion.properties
{
	public class ScaleProperty implements ITweenProperty
	{
		protected var _target:Object;
		protected var _startValue:Number;
		protected var _endValue:Number;

		public function initialize(target:Object, endValue:Object):void
		{
			_target = target;
			_startValue = currentScale;
			_endValue = Number(endValue);
		}

		public function applyTween(position:Number):void
		{
			_target.scaleX = _target.scaleY = _startValue + position * (_endValue - _startValue);
		}

		public function applyComplete():void
		{
			_target.scaleX = _target.scaleY = _endValue;
		}
		
		private function get currentScale():Number
		{
			return 0.5 * (_target.scaleX + _target.scaleY);
		}

	}
}
