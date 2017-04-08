package
{
	import flash.display.*;
	import flash.events.*;

	public class DownloadError extends MovieClip
	{
		public function DownloadError(_message:String, no_listeners:Boolean = false)
		{
			set_size();

			if (!no_listeners)
			{
				addEventListener(MouseEvent.CLICK, close_alert);
				addEventListener(KeyboardEvent.KEY_DOWN, close_alert);
			}
		}

		public function resize():void
		{
			set_size();
		}

		private function set_size():void
		{
			bg.width = Data.width;
			bg.height = Data.height;
			win.x = int(Data.width / 2 - win.width / 2);
			win.y = int(Data.height / 2 - win.height / 2);
			win.scaleX = Data.scaleX;
			win.scaleY = Data.scaleY;
		}

		private function close_alert(e:Event):void
		{
			this.parent.removeChild(this);
		}
	}
}