package
{
	import flash.display.MovieClip;

	public class LevelsPreviewLQ extends MovieClip
	{
		public static var current:LevelsPreviewLQ;

		public function LevelsPreviewLQ()
		{
		}

		public static function init():void
		{
			current = new LevelsPreviewLQ();
		}
	}

}
