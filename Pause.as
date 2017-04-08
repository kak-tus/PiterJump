package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Pause extends MovieClip
	{
		public function Pause()
		{
			add_listeners();
			resize();
			to_pause();
		}

		public function resize():void
		{
			scaleX = Data.scaleX;
			scaleY = Data.scaleY;
			x = Data.width - 20 * scaleX;
			y = 20 * scaleY;
		}

		private function to_pause():void
		{
			(getChildAt(0) as MovieClip).gotoAndStop(1);
		}

		private function to_play():void
		{
			(getChildAt(0) as MovieClip).gotoAndStop(2);
		}

		private function add_listeners():void
		{
			addEventListener(MouseEvent.CLICK, go_pause);
		}

		public function remove_listeners():void
		{
			removeEventListener(MouseEvent.CLICK, go_pause);
		}

		private function go_pause(e:MouseEvent):void
		{
			var ev:MenuEvent;

			if ((getChildAt(0) as MovieClip).currentFrame == 1)
			{
				to_play();
				ev = new MenuEvent(MenuEvent.ON_PAUSE, true);
			}
			else
			{
				to_pause();
				ev = new MenuEvent(MenuEvent.ON_RESUME, true);
			}

			dispatchEvent(ev);
		}
	}
}
