package
{
	
	import flash.display.MovieClip;
	
	public class ClickMe extends MovieClip
	{
		
		public function ClickMe()
		{
			resize();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function resize():void
		{
			x = Data.width / 2 - width / 2;
			y = Data.height / 2 + height / 2;
			scaleX = Data.scaleX;
			scaleY = Data.scaleY;
		}
	}

}
