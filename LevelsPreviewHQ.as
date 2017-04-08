package
{
	import flash.display.MovieClip;

	public class LevelsPreviewHQ extends MovieClip
	{
		public static var current:LevelsPreviewHQ;

		public function LevelsPreviewHQ()
		{
		}

		public static function init():void
		{
			current = new LevelsPreviewHQ();
		}
	}

}
