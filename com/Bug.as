package com{
	import flash.display.*;

	public class Bug extends MovieClip{	 	
	
		public function Bug():void{
			flight_mov.visible = false;
		}
		
		public function fly():void{
			flight_mov.visible = true;
		}
		
		public function land():void{
			flight_mov.visible = false;
		}		
	}
}