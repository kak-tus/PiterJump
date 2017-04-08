package  {
	import flash.display.MovieClip;
	
	public class Replay extends MovieClip {
		public function Replay() {
			resize();
		}
		
		public function resize():void {
			scaleX = Data.scaleX;
			scaleY = Data.scaleY;
			x = Data.width - ( width / scaleX + 20 + 20 ) * scaleX;
			y = 20 * scaleY;
		}
	}
	
}
