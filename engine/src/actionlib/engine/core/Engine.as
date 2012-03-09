package actionlib.engine.core
{
	import actionlib.common.display.StageReference;
	import actionlib.common.events.EventSender;
	import actionlib.common.logging.Logger;
	import actionlib.motion.TweenManager;
	import actionlib.motion.Tweener;

	public class Engine extends ComponentGroup
	{
		public var context:Object;

		internal var nameManager:NameManager = new NameManager();
		internal var processManager:ProcessManager = new ProcessManager();

		private var _resumeEvent:EventSender = new EventSender(this);
		private var _pauseEvent:EventSender = new EventSender(this);

		private var _logger:Logger = new Logger(this);
		private var _tweenManager:TweenManager = new TweenManager();
		private var _paused:Boolean = false;

		public function Engine(context:Object = null)
		{
			this.context = context;
		}

		//-- initialization --//

		public function start():void
		{
			initialize(this);
			processManager.start();
			_logger.debug("initialized");
		}

		public function stop():void
		{
			dispose();
			processManager.stop();
			_tweenManager.removeAll();
			_logger.debug("disposed");
		}

		//-- state --//

		public function pause():void
		{
			assertIsReady();

			if (_paused)
				return;

			processManager.stop();
			tweenManager.pauseAll();

			_paused = true;
			_logger.debug("paused");
			_pauseEvent.dispatch();
		}

		public function resume():void
		{
			assertIsReady();

			if (!_paused)
				return;

			processManager.start();
			_paused = false;
			_tweenManager.resumeAll();
			_logger.debug("resumed");
			_resumeEvent.dispatch();
		}


		//-- processing --//


		public function doStepsForce(stepsCount:int = 1):void
		{
			assertIsReady();

			for (var i:int = 0; i < stepsCount; i++)
			{
				processManager.doStep();
			}
		}

		public function tween(target:Object, duration:Number = -1):Tweener
		{
			return _tweenManager.tween(target, duration);
		}


		//-- get/set --//


		public function get paused():Boolean { return _paused; }

		public function set paused(value:Boolean):void
		{
			if (value)
				pause();
			else
				resume();
		}

		public function get pauseEvent():EventSender { return _pauseEvent; }

		public function get resumeEvent():EventSender { return _resumeEvent; }

		public function get tweenManager():TweenManager { return _tweenManager; }
	}

}