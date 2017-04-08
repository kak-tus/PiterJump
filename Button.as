package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.*;
	
	public dynamic class Button extends MovieClip {
		private var progress:ButtonProgress;
		private var progress_max:int;
		
		public function Button() {
			addEventListener( MouseEvent.CLICK, click );
			
			mouseChildren = false;
			
			progress = getChildByName( "progress" ) as ButtonProgress;
			if ( progress ) {
				progress_max = progress.width - 10;
			}
		}

		private function click( e:MouseEvent ):void {
			var ev:MenuEvent = new MenuEvent( MenuEvent.ON_BUTTON, true );
			ev.item = this.name;
			ev.parent = this.parent;
			ev.obj = this;
			dispatchEvent( ev );
		}
		
		public function start_download():void {
			progress.width = 10;
			progress.visible = true;
		}
		
		public function stop_download():void {
			progress.width = 10;
			progress.visible = false;
		}
		
		public function download_progress( current:uint, maximum:uint ):void {
			progress.width = int( progress_max * current / maximum ) + 10;
		}
		
		public function set_text( _name:String ):void {
			( getChildByName( "text_instance" ) as Text ).set_text( _name );
		}
	}
	
}
