package actionlib.engine.components
{
	import actionlib.common.utils.MathUtil;

	public class Rotation
	{
		public static function fromDegrees(value:Number):Rotation
		{
			return new Rotation(value * MathUtil.TO_RADIANS);
		}


		//-- instance --//


		public var value:Number;
		
		public function Rotation(value:Number = 0)
		{
			this.value = value;
		}
		
		public function get degrees():Number
		{
			return value * MathUtil.TO_DEGREES;
		}

		public function toString():String
		{
			return "Rotation[" + value + "]";
		}
	}

}