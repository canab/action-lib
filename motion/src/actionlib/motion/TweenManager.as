package actionlib.motion
{
	import actionlib.motion.easing.Quad;
	import actionlib.motion.filter.FilterProperty;
	import actionlib.motion.properties.ScaleProperty;
	import actionlib.motion.properties.VolumeProperty;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	use namespace motion_internal;

	/**
	 * Class provides tween animation.
	 * Can be used by static interface
	 *
	 * @example
	 * <code>TweenManager.tween(...)</code>
	 * or as several instances of TweenManager
	 *
	 * @example
	 * <code>var manager:TweenManager = new TweenManager()
	 * manager.tween(...)</code>
	 * 
	 * @see actionlib.motion.tween()
	 */
	public class TweenManager
	{
		private static var _instance:TweenManager;

		motion_internal static var specialProperties:Object = {};

		motion_internal static function get instance():TweenManager
		{
			if (!_instance)
				_instance = new TweenManager();

			return _instance;
		}

		registerSpecialProperty("$scale", ScaleProperty);
		registerSpecialProperty("$filter", FilterProperty);
		registerSpecialProperty("$volume", VolumeProperty);

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// public interface
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		/**
		 * Add custom behaviour for some property name
		 * @param name property name
		 * @param propertyClass class, should implement ITweenProperty and have no constructor without parameters.
		 * @see package actionlib.motion.properties
		 */
		public static function registerSpecialProperty(name:String, propertyClass:Class):void
		{
			specialProperties[name] = propertyClass;
		}

		/**
		 * Create new tween
		 * @param target
		 * target object
		 * @param duration
		 * Tween time in milliseconds. If omitted defaultDuration value will be used.
		 * 
		 * @see #defaultDuration
		 */
		public static function tween(target:Object, duration:int):Tweener
		{
			return instance.tween(target, duration);
		}

		public static function pauseAll():void
		{
			instance.pauseAll();
		}

		public static function resumeAll():void
		{
			instance.resumeAll();
		}

		public static function removeAll():void
		{
			instance.removeAll();
		}

		public static function removeTweensOf(target:Object):void
		{
			instance.removeTweensOf(target);
		}

		public static function get defaultDuration():Number
		{
			return instance.defaultDuration;
		}

		public static function set defaultDuration(value:Number):void
		{
			instance.defaultDuration = value;
		}

		public static function get defaultEasing():Function
		{
			return instance.defaultEasing;
		}

		public static function set defaultEasing(value:Function):void
		{
			instance.defaultEasing = value;
		}

		public static function get tweensCount():int
		{
			return instance.tweensCount;
		}


		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _head:Tweener = null;
		private var _dispatcher:Shape = new Shape();
		private var _paused:Boolean = false;
		private var _isDispatcherActive:Boolean = false;
		private var _pauseTime:Number;
		private var _targetsTweenMap:Dictionary = new Dictionary();

		private var _currentTime:Number;
		private var _defaultDuration:int = 500;
		private var _defaultEasing:Function = Quad.easeOut;
		private var _tweensCount:int = 0;

		public function TweenManager()
		{
			super();
		}

		/**
		 * Create new tween
		 * @param target
		 * target object
		 * @param duration
		 * Tween time in milliseconds. If omitted defaultDuration value will be used.
		 *
		 * @see #defaultDuration
		 */
		public function tween(target:Object, duration:int = -1):Tweener
		{
			var tweener:Tweener = new Tweener(this, target, duration);
			addTween(tweener);
			updateDispatcher();
			return tweener;
		}

		public function pauseAll():void
		{
			if (!_paused)
			{
				_paused = true;
				_pauseTime = getTimer();
				updateDispatcher();
			}
		}

		public function resumeAll():void
		{
			if (_paused)
			{
				_paused = false;
				addTime(getTimer() - _pauseTime);
				updateDispatcher();
			}
		}

		public function removeAll():void
		{
			for(var tweener:Tweener = _head; tweener; tweener = tweener.next)
			{
				tweener.removed = true;
			}
		}

		public function removeTweensOf(target:Object):void
		{
			var tweeners:Array = _targetsTweenMap[target] || [];

			for each (var tweener:Tweener in tweeners)
			{
				tweener.removed = true;
			}
		}

		public function get defaultDuration():Number
		{
			return _defaultDuration;
		}

		public function set defaultDuration(value:Number):void
		{
			_defaultDuration = value;
		}

		public function get defaultEasing():Function
		{
			return _defaultEasing;
		}

		public function set defaultEasing(value:Function):void
		{
			_defaultEasing = value;
		}

		public function get tweensCount():int
		{
			return _tweensCount;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private function addTween(tweener:Tweener):void
		{
			_tweensCount++;
			insertIntoList(tweener);
			addToMap(tweener);
		}

		private function insertIntoList(tweener:Tweener):void
		{
			tweener.next = _head;
			tweener.prev = null;

			if (_head)
				_head.prev = tweener;

			_head = tweener;
		}

		private function addToMap(tweener:Tweener):void
		{
			var tweens:Array = _targetsTweenMap[tweener.target];

			if (!tweens)
				tweens = _targetsTweenMap[tweener.target] = [];

			tweens.push(tweener);
		}

		private function removeTween(tweener:Tweener):void
		{
			_tweensCount--;

			deleteFromList(tweener);
			removeFromMap(tweener);
		}

		private function deleteFromList(tweener:Tweener):void
		{
			var prevTweener:Tweener = tweener.prev;
			var nextTweener:Tweener = tweener.next;

			if (prevTweener)
				prevTweener.next = nextTweener;

			if (nextTweener)
				nextTweener.prev = prevTweener;

			if (tweener == _head)
				_head = nextTweener;
		}

		private function removeFromMap(tweener:Tweener):void
		{
			var tweens:Array = _targetsTweenMap[tweener.target];

			var index:int = tweens.indexOf(tweener);
			if (index >= 0)
				tweens.splice(index, 1);

			if (tweens.length == 0)
				delete _targetsTweenMap[tweener.target];
		}

		private function processTweens(event:Event):void
		{
			_currentTime = getTimer();
			
			var tweener:Tweener = _head;

			while (tweener)
			{
				var nextTweener:Tweener = tweener.next;

				if (tweener.removed)
				{
					removeTween(tweener);
				}
				else
				{
					if (!tweener.initialized)
					{
						tweener.initialize(_currentTime);
						overrideProperties(tweener);
					}

					tweener.doStep(_currentTime);

					if (tweener.completed)
						finishTween(tweener);
				}

				tweener = nextTweener;
			}

			updateDispatcher();
		}

		private function overrideProperties(sourceTweener:Tweener):void
		{
			var targetTweeners:Array = _targetsTweenMap[sourceTweener.target];
			var sourceProps:Object = sourceTweener.properties;

			for each (var targetTweener:Tweener in targetTweeners)
			{
				if (targetTweener == sourceTweener)
					continue;

				if (targetTweener.completed || targetTweener.removed)
					continue;

				// do not override pauses & remove empty tweens (pauses)
				if (targetTweener.numProperties == 0)
					continue;

				targetTweener.overrideProperties(sourceProps);

				if (targetTweener.numProperties == 0)
					targetTweener.removed = true;
				else
					overrideChain(targetTweener, sourceProps);
			}
		}

		private function overrideChain(targetTweener:Tweener, sourceProps:Object):void
		{
			var tweener:Tweener = targetTweener;
			var chain:Tweener = tweener.chain;

			while (chain)
			{
				// do not override pauses
				if (chain.numProperties == 0 || chain.removed)
				{
					tweener = chain;
					chain = tweener.chain;
					continue;
				}

				chain.overrideProperties(sourceProps);

				if (chain.numProperties == 0)
				{
					tweener.chain = null;
					break;
				}

				tweener = chain;
				chain = tweener.chain;
			}
		}

		private function finishTween(tweener:Tweener):void
		{
			if (tweener.chain)
				addTween(tweener.chain);

			removeTween(tweener);
		}

		private function addTime(time:Number):void
		{
			for (var tweener:Tweener = _head; tweener; tweener = tweener.next)
			{
				tweener.addTime(time);
			}
		}

		private function updateDispatcher():void
		{
			if (_isDispatcherActive && (_paused || !_head))
			{
				_isDispatcherActive = false;
				_dispatcher.removeEventListener(Event.ENTER_FRAME, processTweens);
			}
			else if (!_isDispatcherActive && !_paused && _head)
			{
				_isDispatcherActive = true;
				_dispatcher.addEventListener(Event.ENTER_FRAME, processTweens);
			}
		}

		/**
		 * Low performance!
		 * @return multiline text
		 */
		public static function getDebugInfo():String
		{
            return instance.getDebugInfo();
		}

		/**
		 * Low performance!
		 * @return multiline text
		 */
		public function getDebugInfo():String
		{
			var dictSize:int = 0;
			//noinspection JSUnusedLocalSymbols
			for each (var item:Object in _targetsTweenMap)
			{
				dictSize++;
			}

			var listSize:int = 0;
			for (var tweener:Tweener = _head; tweener; tweener = tweener.next)
			{
				listSize++;
			}

			var text:String = ""
		        + "tweeners: " + TweenManager.tweensCount + "\n"
				+ "dictSize: " + dictSize + "\n"
				+ "listSize: " + listSize + "\n"
				+ "active  : " + _isDispatcherActive;

			return text;
		}

	}
}
