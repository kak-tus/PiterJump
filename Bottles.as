package
{
	import flash.display.MovieClip;

	public class Bottles extends MovieClip
	{
		public static var current:Bottles;
		private var bottles:Array = new Array();

		public static function init()
		{
			current = new Bottles();
		}

		public function Bottles()
		{
			add(5);
			resize();
		}

		public function add(count:int = 1):void
		{
			for (var i:int = 1; i <= count; i++)
			{
				var btl:Bottle = new Bottle();
				btl.y = 10;

				if (bottles.length > 0)
				{
					btl.x = (bottles[bottles.length - 1] as Bottle).x + btl.width + 10;
				}
				else
				{
					btl.x = 10;
				}

				bottles.push(btl);
				addChild(btl);
			}
			resize();
		}

		public function resize():void
		{
			for (var i:int = 0; i < bottles.length; i++)
			{
				(bottles[i] as Bottle).resize();
			}

			x = int(Data.width / 2 - width / 2);
		}

		public function remove(count:int = 1):void
		{
			for (var i:int = 1; i <= count; i++)
			{
				if (bottles.length <= 0)
				{
					return;
				}

				removeChild(bottles[bottles.length - 1]);
				bottles.pop();
			}
			resize();
		}

		public function count():int
		{
			return bottles.length;
		}
	}

}