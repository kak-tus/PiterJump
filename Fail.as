package
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Fail extends MovieClip implements IRemoveListeners
	{

		public function Fail()
		{
			resize();
			add_listeners();
		}

		public function resize():void
		{
			x = Data.width / 2 - width / 2;
			y = Data.height / 2 - height / 2;
			scaleX = Data.scaleX;
			scaleY = Data.scaleY;
		}

		private function add_listeners():void
		{
			main.main_stage.addEventListener(MouseEvent.CLICK, to_menu);
		}

		public function remove_listeners():void
		{
			main.main_stage.removeEventListener(MouseEvent.CLICK, to_menu);
		}

		public function to_menu(e:MouseEvent):void
		{
			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_LEVELSPREVIEW, true);
			dispatchEvent(ev);
		}
	}

}
