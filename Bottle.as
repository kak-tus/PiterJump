package  {
	
	import flash.display.MovieClip;
	
	
	public class Bottle extends MovieClip {
		public function Bottle() {
			resize();
		}
		
		public function resize():void {
			scaleX = Data.video_scaleX;
			scaleY = Data.video_scaleY;
		}
	}
	
}
