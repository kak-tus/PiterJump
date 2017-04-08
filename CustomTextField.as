package 
{
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author acp
	 */
	public class CustomTextField extends TextField {
		public function create ( _x:int, _y:int, _w:int, _h:int ) {
			var tf:CustomTextField = new CustomTextField();
			tf.x = _x;
			tf.y = _y;
			tf.width = _w;
			tf.height = _h;
		}
	}
	
}