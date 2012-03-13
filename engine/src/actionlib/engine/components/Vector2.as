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

		public function addVector(value:Point):Vector2
		{
			return new Vector2(x + value.x, y + value.y);
		}

		public function subtractVector(value:Point):Vector2
		{
			return new Vector2(x - value.x, y - value.y);
		}

		public function scale(value:Number):Vector2
		{
			return new Vector2(x * value, y * value);
		}

		public function getNormalized():Vector2
		{
			return copy().normalizeSelf();
		}

		public function vectorProjectionTo(value:Vector2):Vector2
		{
			return value
					.getNormalized()
					.scaleSelf(scalarProjectionTo(value));
		}

		public function scalarProjectionTo(v:Vector2):Number
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

		public function scaleSelf(value:Number):Vector2
		{
			x *= value;
			y *= value;
			return this;
		}

		public function normalizeSelf():Vector2
		{
			var length:Number = this.length;

			if (length)
			{
				x /= length;
				y /= length;
			}

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