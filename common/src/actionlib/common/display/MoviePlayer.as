package actionlib.common.display
{
	import actionlib.common.collections.WeakObjectMap;
	import actionlib.common.commands.AsincCommand;
	import actionlib.common.commands.ICancelableCommand;
	import actionlib.common.utils.DisplayUtil;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class MoviePlayer extends AsincCommand implements ICancelableCommand
	{
		static private const _players:WeakObjectMap = new WeakObjectMap(MovieClip, MoviePlayer);
		
		public var clip:MovieClip;
		public var toFrame:int;
		public var fromFrame:int;
		
		public function MoviePlayer(clip:MovieClip = null, fromFrame:int = 1, toFrame:int = 0)
		{
			this.clip = clip;
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
		}

		public function detachOnComplete():MoviePlayer
		{
			completeEvent.addListener(detachFromDisplay);
			return this;
		}

		private function detachFromDisplay():void
		{
			DisplayUtil.detachFromDisplay(clip);
		}
		
		public function play(fromFrame:int = 1, toFrame:int = 0):MoviePlayer
		{
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
			
			execute();
			
			return this;
		}
		
		public function playTo(toFrame:int):MoviePlayer
		{
			play(clip.currentFrame, toFrame);
			return this;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (clip.currentFrame == toFrame)
			{
				stopPlaying();
				dispatchComplete();
			}
			else if (clip.currentFrame < toFrame)
			{
				clip.nextFrame();
			}
			else
			{
				clip.prevFrame();
			}
		}
		
		override public function execute():void
		{
			var currentPlayer:MoviePlayer = _players[clip];
			if (currentPlayer)
				currentPlayer.cancel();
			
			_players[clip] = this;
			
			clip.gotoAndStop(fromFrame);
			clip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function cancel():void
		{
			stopPlaying();
		}
		
		private function stopPlaying():void 
		{
			clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_players.removeKey(clip);
		}
		
	}

}