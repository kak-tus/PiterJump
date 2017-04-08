package 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class CustomButton extends ButtonAlpha
	{
		public function CustomButton( _txt:String, _x:int , _y:int, _w:int, _h:int) {
			( ( getChildByName( "text" ) as MovieClip ).getChildByName( "text" ) as TextField ).text = _txt;
		}
	}
	
}