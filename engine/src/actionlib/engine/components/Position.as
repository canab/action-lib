package actionlib.engine.components
{
	import actionlib.engine.core.Component;

	import flash.display.DisplayObject;

	import flash.geom.Point;

	public class Position extends Component
	{
		public static function fromDisplayObject(object:DisplayObject):Position
		{
			return new Position(object.x, object.y);
		}

		public static function fromPoint(point:Point):Position
		{
			return new Position(point.x, point.y);
		}

		public var x:Number;
		public var y:Number;
		
		public function Position(x:Number = 0, y:Number = 0) 
		{
			this.x = x;
			this.y = y;
		}
		
		public function toPoint():Point
		{
			return new Point(x, y);
		}
		
		override public function toString():String
		{
			return "Position[" + x + ", " + y + "]";
		}
		
	}

}