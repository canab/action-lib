package actionlib.engine.components
{

	public class Direction8
	{
		public static const UP:int         = 0;
		public static const RIGHT_UP:int   = 1;
		public static const RIGHT:int      = 2;
		public static const RIGHT_DOWN:int = 3;
		public static const DOWN:int       = 4;
		public static const LEFT_DOWN:int  = 5;
		public static const LEFT:int       = 6;
		public static const LEFT_UP:int    = 7;
		
		public static function getRightDirection(direction:int):int
		{
			if (direction == LEFT_UP)
				return RIGHT_UP;
			else if (direction == LEFT)
				return RIGHT;
			else if (direction == LEFT_DOWN)
				return RIGHT_DOWN;
			else
				return direction;
		}

		public static function calculateFromPoints(sourcePoint:Object, destPoint:Object):int
		{
			return calculateFromCoords(destPoint.x - sourcePoint.x, destPoint.y - sourcePoint.y);
		}

		public static function calculateFromCoords(xDiff:Number, yDiff:Number):int
		{
			var angle:Number = (Math.atan2(yDiff, xDiff)) / Math.PI * 180 + 90;

			if (angle < 0)
				angle += 360;

			return Math.round(angle / 45.0) % 8;
		}


		//-- instance --//


		public var value:int = DOWN;

		public function Direction8(newValue:int = DOWN)
		{
			this.value = newValue;
		}

		public function toString():String
		{
			return "Direction8[" + value + "]";
		}
	}

}