package actionlib.engine.scene
{
	import actionlib.engine.core.ComponentBase;
	import actionlib.engine.core.Entity;

	import flash.display.Sprite;

	public class VectorScene extends Entity
	{
		private var _root:Sprite;

		public function VectorScene(root:Sprite = null)
		{
			_root = root || new Sprite();
			_root.mouseEnabled = false;
		}

		override public function addComponent(component:ComponentBase):void
		{
			if (component is VectorLayer)
				_root.addChild(VectorLayer(component).content);

			super.addComponent(component);
		}

		override public function removeComponent(component:ComponentBase):void
		{
			if (component is VectorLayer)
				_root.removeChild(VectorLayer(component).content);

			super.removeComponent(component);
		}
	}
}
