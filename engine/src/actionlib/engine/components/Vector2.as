package actionlib.engine.components
{
	import flash.geom.Point;

	public class Vector2 extends Point
	{
		public static function fromPoint(point:Point):Vector2
		{
			return new Vector2(point.x, point.y);
		}

		public static function fromPolar(length:Number, angle:Number):Vector2
		{
			return fromPoint(Point.polar(length, angle));
		}


		//-- instance --//


		public function Vector2(x:Number = 0, y:Number = 0)
		{
			this.x = x;
			this.y = y;
		}

		public function mult(value:Number):Vector2
		{
			return new Vector2(x * value, y * value);
		}

		public function multScalar(a:Point, b:Point):Number
		{
			return a.x* b.x + a.y * b.y;
		}

		public function unitVector():Vector2
		{
			var length:Number = this.length;
			var result:Vector2 = new Vector2(x, y);

			if (length)
			{
				result.x /= length;
				result.y /= length;
			}

			return result;
		}

		public function vectorProjectionOnto(value:Vector2):Vector2
		{
			return value
					.unitVector()
					.multSelf(scalarProjectionOnto(value));
		}

		public function scalarProjectionOnto(v:Vector2):Number
		{
			return (x * v.x + y * v.y) / v.length;
		}

		//-- self modification --//

		public function addSelf(value:Vector2):Vector2
		{
			x += value.x;
			y += value.y;
			return this;
		}

		public function subtractSelf(value:Vector2):Vector2
		{
			x -= value.x;
			y -= value.y;
			return this;
		}

		public function multSelf(value:Number):Vector2
		{
			x *= value;
			y *= value;
			return this;
		}


		//-- get/set --//

		public function get lengthSquared():Number
		{
			return x * x + y * y;
		}

		public function copy():Vector2
		{
			return new Vector2(x, y);
		}

		override public function toString():String
		{
			return 'Vector2(' + x + ', ' + y + ')';
		}
	}

}