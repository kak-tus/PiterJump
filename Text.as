package  {
	import flash.display.MovieClip;
	
	public dynamic class Text extends MovieClip {
		
		
		public function Text() {
			set_text();
		}

		public function set_text( _name:String = undefined ):void {
			if ( !_name ) {
				_name = this.name;
			}

			// дефолтное имя элемента
			if ( _name.indexOf( "instance" ) != -1 ) {
				_name = this.parent.name;
			}
			
			if ( _name.indexOf( "instance" ) != -1 ) {
				_name = this.parent.parent.name;
			}
			
			( this.getChildByName( "text" ) as TextField ).text = Languages.current_language[ _name ];
		}
		
	}
	
}
