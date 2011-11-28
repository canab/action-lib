package actionlib.gui.controls
{
	import actionlib.common.events.EventSender;
	import actionlib.common.utils.ArrayUtil;

	public class RadioGroup
	{
		private var _buttons:Array = [];
		private var _selectedButton:PushButton = null;

		private var _clickEvent:EventSender = new EventSender(this);

		public function RadioGroup(buttons:Array = null)
		{
			if (buttons)
				initialize(buttons);
		}

		private function initialize(buttons:Array):void
		{
			for each (var button:PushButton in buttons)
			{
				addButton(button);
			}
		}

		public function addButton(button:PushButton):void
		{
			button.allowToggle = true;
			button.clickEvent.addListener(onButtonClick);

			_buttons.push(button);

			if (_buttons.length == 1)
				setSelection(button);
		}

		public function removeButton(button:PushButton):void
		{
			button.clickEvent.removeListener(onButtonClick);
			ArrayUtil.removeItem(_buttons, button);

			if (selectedButton == button)
				selectedButton = null;
		}

		private function onButtonClick(sender:PushButton):void
		{
			if (sender != selectedButton)
			{
				selectedButton = sender;
				_clickEvent.dispatch();
			}
			else
			{
				sender.toggled = true;
			}
		}

		private function setSelection(value:PushButton):void
		{
			if (_selectedButton)
				_selectedButton.toggled = false;

			_selectedButton = value;

			if (_selectedButton)
				_selectedButton.toggled = true;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get buttons():Array
		{
			return _buttons;
		}

		public function get selectedButton():PushButton
		{
			return _selectedButton;
		}

		public function set selectedButton(value:PushButton):void
		{
			if (_selectedButton != value)
				setSelection(value);
		}

		public function get selectedIndex():int
		{
			return _buttons.indexOf(_selectedButton);
		}

		public function set selectedIndex(value:int):void
		{
			selectedButton = _buttons[value];
		}

		public function get clickEvent():EventSender
		{
			return _clickEvent;
		}
	}

}