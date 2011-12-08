package actionlib.engine.components
{
	import actionlib.engine.core.Component;

	import flash.geom.Point;

	public class Position extends Component
	{
		static public function fromPoint(point:Object):Position
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
		
		public function toString():String
		{
			return "[Position: (" + x + "; " + y + ")]"
		}
		
	}

}