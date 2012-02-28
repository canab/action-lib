package actionlib.engine.components
{
	import actionlib.common.utils.MathUtil;
	import actionlib.engine.core.Component;

	public class Rotation extends Component
	{
		public static function fromDegrees(value:Number):Rotation
		{
			return new Rotation(value * MathUtil.TO_RADIANS);
		}

		public var value:Number;
		
		private var _radToDegree:Number = 180.0 / Math.PI;
		
		public function Rotation(value:Number = 0) 
		{
			this.value = value;
		}
		
		public function get degrees():Number
		{
			return value * _radToDegree;
		}
	}

}