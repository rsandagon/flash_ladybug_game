package com{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	
	public class preloader extends MovieClip{
		public var obj:MovieClip;
		
		//	This adds the preloader functionality in the MovieClip
		function preloader():void {
			obj = this;
			obj.addEventListener(Event.ENTER_FRAME, preloaderProgress);
		}
		
		//	This handles the ENTER_FRAME event
		function preloaderProgress(e:Event):void{
			var pbl = obj.loaderInfo.bytesLoaded;
			var pbt = obj.loaderInfo.bytesTotal;
			preload_txt.text = Number((pbl/pbt)*100).toPrecision(3);
			preload_txt.appendText("%");

			if (Number((pbl/pbt)*100) == 100) {
				obj.removeEventListener(Event.ENTER_FRAME, preloaderProgress);
				var par:MovieClip = obj.parent as MovieClip
				
				//	The parent movieClip, which is the Stage should move
				par.nextFrame();
			}
		}
	}
}