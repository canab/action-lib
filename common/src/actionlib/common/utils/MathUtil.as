package actionlib.common.utils
{
	import flash.geom.Point;

	public class MathUtil
	{
		private static var _PI:Number = Math.PI;
		private static var _2PI:Number = 2 * Math.PI;
		
		public function MathUtil()
		{
			super();
		}
		
		public static function distance2(p1:Point, p2:Point):Number
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			
			return dx*dx + dy*dy;
		}
		
		public static function claimRange(value:Number, min:Number, max:Number):Number
		{
			if (value < min)
				return min;
			else if (value > max)
				return max;
			else
				return value;
		}
		
		public static function randomInt(minValue:int, maxValue:int):int
		{
			return minValue + int(Math.random() * (maxValue - minValue + 1));
		}

		public static function radiansToDegrees(radians:Number):Number
		{
			return radians / _PI * 180;
		}

		/**
		 * returns angle from startPoint to endPoint in ranges [-PI...PI]
		 */
		public static function getAngle(startPoint:Point, endPoint:Point):Number
		{
			var dx:Number = endPoint.x - startPoint.x;
			var dy:Number = endPoint.y - startPoint.y;

			if (dx == 0)
				return (dy > 0) ? -_PI : _PI;
			else
				return Math.atan2(dy,  dx);
		}
		
		/**
		 * Normalize value to range [-PI...PI]
		 * @param	angle
		 * angle value in radians
		 * @return
		 * angle value in range [-PI...PI]
		 */
		public static function normalizeAngle(angle:Number):Number
		{
			angle %= _2PI;
			
			if (angle > _PI)
				angle -= _2PI;
			else if (angle < -_PI)
				angle += _2PI;
				
			return angle;
		}
		
		/**
		 * Calculates angle difference
		 * @param	angle1
		 * angle value in radians
		 * @param	angle2
		 * angle value in radians
		 * @return
		 * difference in range [-PI...PI]
		 */
		public static function angleDiff(angle1:Number, angle2:Number):Number
		{
			angle1 %= _2PI;
			angle2 %= _2PI;
			
			if (angle1 < 0)
				angle1 += _2PI;
			
			if (angle2 < 0)
				angle2 += _2PI;
			
			var diff:Number = angle2 - angle1;
			
			if (diff < -_PI)
				diff += _2PI;
			
			if (diff > _PI)
				diff -= _2PI;
			
			return diff;
		}
		
		public static function sign(num:Number):int
		{
			if (num > 0)
				return 1;
			else if (num < 0)
				return -1;
			else
				return 0;
		}
	}
}