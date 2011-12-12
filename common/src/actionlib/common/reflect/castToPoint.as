package actionlib.common.reflect
{
	import actionlib.common.utils.*;
	import flash.geom.Point;

	public function castToPoint(object:Object):Point
	{
		return new Point(object.x, object.y);
	}
}
