package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.events.MouseEvent;

	public class BackButton extends MovieClip
	{
		public function BackButton()
		{
			add_listeners();
			resize();
		}

		public function resize():void
		{
			x = 20 * Data.scaleX;
			y = 20 * Data.scaleX;
			scaleX = Data.scaleX;
			scaleY = Data.scaleY;
		}

		private function add_listeners():void
		{
			addEventListener(MouseEvent.CLICK, go_back);
		}

		public function remove_listeners():void
		{
			removeEventListener(MouseEvent.CLICK, go_back);
		}

		private function go_back(e:MouseEvent):void
		{
			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_LEVELSPREVIEW, true);
			dispatchEvent(ev);
		}
	}
}