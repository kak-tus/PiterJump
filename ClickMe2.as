package
{
	
	import flash.display.MovieClip;
	
	public class ClickMe2 extends MovieClip
	{
		
		public function ClickMe2()
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
