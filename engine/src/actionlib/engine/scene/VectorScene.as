package actionlib.engine.scene
{
	import actionlib.engine.core.Component;
	import actionlib.engine.core.Entity;

	import flash.display.Sprite;

	public class VectorScene extends Entity
	{
		private var _root:Sprite;

		public function VectorScene(root:Sprite)
		{
			_root = root;
			_root.mouseEnabled = false;
		}

		override public function addComponent(component:Component):void
		{
			if (component is VectorLayer)
				_root.addChild(VectorLayer(component).content);

			super.addComponent(component);
		}

		override public function removeComponent(component:Component):void
		{
			if (component is VectorLayer)
				_root.removeChild(VectorLayer(component).content);

			super.removeComponent(component);
		}
	}
}
