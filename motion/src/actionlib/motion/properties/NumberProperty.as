package actionlib.motion.properties
{
	public class NumberProperty implements ITweenProperty
	{
		protected var _target:Object;
		protected var _propName:String;
		protected var _startValue:Number;
		protected var _endValue:Number;

		public function NumberProperty(propName:String)
		{
			_propName = propName;
		}

		public function initialize(target:Object, endValue:Object):void
		{
			_target = target;
			_startValue = _target[_propName];
			_endValue = Number(endValue);
		}

		public function applyTween(position:Number):void
		{
			_target[_propName] = _startValue + position * (_endValue - _startValue)
		}

		public function applyComplete():void
		{
			_target[_propName] = _endValue;
		}
	}
}
