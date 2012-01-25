package actionlib.gui.controls
{
	import actionlib.common.ui.Anchor;
	import actionlib.common.utils.ArrayUtil;
	import actionlib.gui.interfaces.ILayout;

	public class Container extends ControlBase
	{
		private var _controls:Array = [];
		private var _anchors:Array = [];
		private var _layout:ILayout;

		public function addAnchor(
			source:Object, sourceProp:String,
			target:Object, targetProp:String,
			multiplier:Number = 1.0):void
		{
			_anchors.push(new Anchor(source, sourceProp, target, targetProp, multiplier));
		}

		public function addControl(control:ControlBase):void
		{
			_controls.push(control);
			addChild(control);
			invalidate();
		}

		public function removeControl(control:ControlBase):void
		{
			ArrayUtil.removeItem(_controls, control);
			removeChild(control);
			invalidate();
		}

		public function addControls(controls:Object):void
		{
			for each (var control:ControlBase in controls)
			{
				addControl(control);
			}
		}

		public function removeAllControls():void
		{
			while (_controls.length > 0)
			{
				removeControl(_controls[0]);
			}
		}

		override public function applyLayout():void
		{
			super.applyLayout();

			for each (var anchor:Anchor in _anchors)
			{
				anchor.apply();
			}

			if (_layout)
				_layout.apply(this);
		}

		override protected function applyEnabled():void
		{
			for each (var control:ControlBase in _controls)
			{
				control.enabled = enabled;
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get controls():Array
		{
			return _controls.slice();
		}

		public function get layout():ILayout
		{
			return _layout;
		}

		public function set layout(value:ILayout):void
		{
			_layout = value;
			invalidate();
		}
	}

}