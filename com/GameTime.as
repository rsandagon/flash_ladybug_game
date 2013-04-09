package com{
    import flash.display.MovieClip;
	import flash.text.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;

    public class GameTime extends MovieClip {
            private var delay:uint = 1000;
			private var repeat:Number = 10;
            private var myTimer:Timer; // = new Timer(delay,repeat);
            
        public function GameTime() {   
           
		}

		public function initTime(t:Number):void{
			repeat = t;
			
			myTimer = new Timer(delay,repeat);
			
			time_txt.text = repeat.toString();
			myTimer.reset();
			myTimer.start();
			
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}
		
		public function startTime():void{			
			myTimer.start();
		}
		
		public function stopTime():void{			
			myTimer.stop();
		}
		
		public function resetTime():void{			
			myTimer.stop();
		    myTimer.reset();	
		}
		
        private function timerHandler(e:TimerEvent):void{
            repeat--;
			time_txt.text = repeat.toString();			
        }

        private function completeHandler(e:TimerEvent):void {
			 time_txt.text = '--'; 
			 myTimer.stop();
			 myTimer.reset();
			 dispatchEvent(new Event("TimesUp"));
        }
    }
}
