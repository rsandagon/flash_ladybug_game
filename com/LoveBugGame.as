/*****************
Author: Rsandagon
URL: Rsandagon.com
Date:20 January 2010

Main Love Bug Game Class
*****************/

package com{
	import caurina.transitions.Tweener;
	import flash.text.*;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import com.Bug;
	
	public class LoveBugGame extends MovieClip{
		//	Set Stage Motion Flag
		var moveScreen:Boolean = true;
		//	Set Bug
		var bug:mainChar_mov = new mainChar_mov();
		//	Set Score
		var score:uint=0;
		//	Set Particle
		var ParticleArray:Array = new Array();
		var numParticles:uint = 30;	
		
		//	Set Heart Particle
		var HeartArray:Array = new Array();
		var numHearts:uint = 20;	
		
		//	XML variables
		private var _imageList:XMLList;
		private var _enemyList:XMLList;
		private var _timeList:XMLList;
		private var _passingList:XMLList;
		private var _XML_URL:String = "config.xml";
		private var _currentLevel:uint = 1;
		private var _numLevels:uint;
		private var enemyArray:Array = new Array();;
		private var _pass:String;
		private var _fail:String;
		private var _instruction:String;
		
		//image loader
		private var loader:Loader;
		
		//	time variables
		private var timeLimit:Number;
		
		function LoveBugGame():void{
			//	XML LOADING
			var uloader:URLLoader = new URLLoader();
			uloader.addEventListener(Event.COMPLETE, xmlHandler);
			uloader.addEventListener(IOErrorEvent.IO_ERROR, xmlHandler);
			uloader.load(new URLRequest(_XML_URL));		
			
			
			//stop
			stop();
		}
		
		//	Initialize Game 
		private function setGame():void{
			//	Bug setup
			bug.x = stage.stageWidth*0.5;
			bug.y = stage.stageHeight*0.5;
			content_mov.addChild(bug);
			
			//	add Particle Dust
			initDust();
			
			//	add Particle Hearts
			initHeart();
			
			//	Event Listeners			
			content_mov.addEventListener(Event.ENTER_FRAME,moveContent)
			content_mov.addEventListener(MouseEvent.CLICK,moveCharacter);
			
			//	Timer Listener
			gametimer_mov.addEventListener("TimesUp",gameOver)
		}
		
		//	Set XML LOADING
		private function xmlHandler(event:*):void {
			event.currentTarget.removeEventListener(Event.COMPLETE, xmlHandler);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, xmlHandler);
			if (event is IOErrorEvent) {
				trace(event)
			} else {
				var xml:XML = new XML(event.currentTarget.data);
				_imageList = xml..image;
				_enemyList = xml..enemy;
				_timeList = xml..time;
				_passingList = xml..passing;
				_instruction = xml.configuration.@instruction;
				_pass = xml.configuration.@pass_comment;
				_fail= xml.configuration.@fail_comment;				
								
				_numLevels = _imageList.length();
				
				//	Load instruction
				setMessage(true,_instruction,true);
				
				loadImage();
				
				
			}
		}
		
		//	load Background
		private function loadImage():void {
			//	bug setup
			bug.x = stage.stageWidth*0.5;
			bug.y = stage.stageHeight*0.5;
		
			try{
				content_mov.bg.removeChild(loader);
			}catch(e){};
			
			//	Alert
			Tweener.addTween(alert_mov,{alpha:0,time:1});
			
			// pause game
			moveScreen = false;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageProgressHandler);
			loader.load(new URLRequest(_imageList[_currentLevel-1].toString()));
			
			content_mov.visible = false;
			
			alert_mov.visible = true;
			alert_mov.alpha = 1;			
			alert_mov.alert_txt.text = "Loading Background";
		}
		
		//	Image progress
		private function imageProgressHandler(ev:ProgressEvent):void{
			var pr:uint = uint(ev.bytesLoaded/ev.bytesTotal);
			//var num:Number = Number(pr).toFixed(3)
			trace(pr)
			alert_mov.alert_txt.text = pr*100 + "%";
		}
		
		//	Image loading listener
		private function imageHandler(event:*):void {
			event.currentTarget.removeEventListener(Event.COMPLETE, imageHandler);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, imageHandler);
			if (event is IOErrorEvent) {
				trace(event)
			} else {
				content_mov.bg.addChild(loader);
				
				// enable game
				moveScreen = true;
				
				//	if level 1 the initialize game
				if(_currentLevel==1){
					setGame();
				}
				
				//	set time
				setTime();
				
				//	set enemy
				setEnemy();
				
				//	set score
				score = 0;
				setScore();
				
				//	remove alert
				alert_mov.alpha = 0;
				alert_mov.visible = false;
				content_mov.visible = true;
			}
		}
		
		//	Sets message box for instruction, pass and fail remarks!
		//	bol>visibilty, mes> Message, fade> Fadeout
		private function setMessage(bol:Boolean,mes:String='',fade:Boolean=true):void{
			message_mov.visible = bol;
			moveScreen = false;			
			message_mov.icon_mov.visible = false;
			
			//	attempts stop if gametimer is starting
			try{
				gametimer_mov.stopTime();
			}catch(e){
				//not initiated yet
			}
			
			
			if(bol){
				message_mov.visible = true;
				message_mov.alpha = 1;
				message_mov.alert_txt.text = mes;
				message_mov.scaleX = 0.2;
				message_mov.scaleY = 0.2;
				
				Tweener.addTween(message_mov,{time:0.2,scaleX:1,scaleY:1,transition:"easeInQuintElastic"});
				
				if(fade){
					Tweener.addTween(message_mov,{alpha:0,time:5,transition:"easeInQuint",onComplete:removeMessage});
				}
			}
		}
		
		
		//	Set Time
		private function setTime():void{
			gametimer_mov.initTime(Number(_timeList[_currentLevel-1].toString()));
		}
		
		//	Set Enemy
		private function setEnemy():void{
			
			removeEnemy();
			
			var numEnemy:uint = uint(_enemyList[_currentLevel-1].toString());
			enemyArray = new Array();
			while(numEnemy--){
				var enemy:ladyBug_mov = new ladyBug_mov();
				enemyArray.push(enemy)
				
				enemy.x = 50 + (content_mov.width-100)*Math.random();
				enemy.y = 50 + (content_mov.height-100)*Math.random();			
				content_mov.addChild(enemy);

			}
		}
		
		//	Set score
		private function setScore():void{
			score_txt.text = score + "/" +_passingList[_currentLevel-1].toString();			
			if(score == Number(_passingList[_currentLevel-1].toString())){
				
				//	pause screen
				moveScreen = false;				
				
				//	add level
				_currentLevel++;				
				
				//	pause time
				gametimer_mov.stopTime();
				
				
				
				if(_currentLevel > _numLevels){
					setMessage(true,_pass,false);
					message_mov.icon_mov.visible = true;
					message_mov.icon_mov.gotoAndStop('_pass');
					
					//	Replay Button
					var btn = new playAgain_btn();
					btn.x = stage.stageWidth - btn.width*1.5;
					btn.y = stage.stageHeight - btn.height*1.5;
					addChild(btn);
					btn.addEventListener(MouseEvent.MOUSE_DOWN,replayGame);
					
				}else{
					alert_mov.visible = true;
					alert_mov.alpha = 1;
					alert_mov.scaleX = 0.2;
					alert_mov.scaleY = 0.2;
					Tweener.addTween(alert_mov,{time:0.2,scaleX:1,scaleY:1,transition:"easeInQuintElastic"});
					
					alert_mov.alert_txt.text = "Level " + _currentLevel;
					Tweener.addTween(alert_mov,{alpha:0,time:3,transition:"easeInQuint",onComplete:moveLevel});
				}
			};
		}
		
		//	Replay Game
		private function replayGame(m:MouseEvent):void{
			m.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN,replayGame);
			m.currentTarget.parent.removeChild(m.currentTarget);
			
			
			//	reset variables
			_currentLevel = 1;			
			removeMessage();
			moveLevel();			
			gametimer_mov.resetTime();
		}
		
		//	Remove Message
		private function removeMessage():void{
			//	disappear
			message_mov.visible = false;
			
			//	move screen
			moveScreen = true;
			
			//	start time again
			gametimer_mov.startTime();
			
		}
		
		//	Remove Enemy
		private function removeEnemy():void{
			for(var i:uint=0;i<enemyArray.length;i++){
				try{
					content_mov.removeChild(enemyArray[i]);
				}catch(e){}
			}
		}
		
		//	Move Level
		private function moveLevel():void{
			//Stop time
			
			
			alert_mov.visible = false;
			loadImage();			
		}
		
		//	gameOver
		private function gameOver(ev:Event):void{
			moveScreen = false;
			setMessage(true,_fail,false);
			message_mov.icon_mov.visible = true;
				message_mov.icon_mov.gotoAndStop('_fail');
			
			//	Replay Button
			var btn = new playAgain_btn();
			btn.x = stage.stageWidth - btn.width*1.5;
			btn.y = stage.stageHeight - btn.height*1.5;
			addChild(btn);
			btn.addEventListener(MouseEvent.MOUSE_DOWN,replayGame);
		}
		
		//	Initialize dust magic
		private function initDust(){			
			for(var i:uint=1;i<=numParticles;i++){
				var p:particle = new particle();		
				p.alpha = 0;
				p.setEndTarget(0,0);
				
				content_mov.addChild(p);
				ParticleArray.push(p);
			}
		}				
		
		//	Initialize dust magic
		private function initHeart(){			
			for(var i:uint=1;i<=numHearts;i++){
				var p:heart = new heart();		
				p.alpha = 0;
				p.setEndTarget(0,0);
				
				content_mov.addChild(p);
				HeartArray.push(p);
			}
		}	
		
		
		//	Move Content based on mouse x position
		private function moveContent(me:Event):void{
			
			if(moveScreen){				
				var my:Number = mouseX;
				var sw:Number = stage.stageWidth;
				var pr:Number = my/sw;
		
				var mx:Number = mouseY;
				var sh:Number = stage.stageHeight;
				var py:Number = mx/sh;
				
				
				//	0 to content_mov.width;
				var posx:Number = -pr*(content_mov.width - sw);
				var posy:Number = -py*(content_mov.height - sh);
				
				var halfPosX:Number = posx - (posx - content_mov.x)*0.8;
				var halfPosY:Number = posy - (posy - content_mov.y)*0.8;
				
				//	content motion
				content_mov.x = halfPosX;		
				content_mov.y = halfPosY;		
			}
		}
		
		//	Move Bug
		private function moveCharacter(e:Event):void{
			if(moveScreen){
				
				for(var i:uint=0;i<numParticles;i++){
					var p:particle = ParticleArray[i];
					p.changeTarget(content_mov.mouseX,content_mov.mouseY);
				}

				
				var rotY = content_mov.mouseY -  bug.y;
				var rotX = content_mov.mouseX -  bug.x;
				var rot = Math.atan2(rotY,rotX);
				var angle = rot * 180/Math.PI
				
				Tweener.addTween(bug,{transition:"easeInCubic",scaleX:1.2,scaleY:1.2,rotation:angle,time:0.2});
				Tweener.addTween(bug,{transition:"easeInCubic",x:content_mov.mouseX,y:content_mov.mouseY,time:1,onComplete:landBug});
				bug.fly();
			}
		}
		
		//	Land Bug
		private function landBug():void{
			Tweener.addTween(bug,{transition:"easeInCubic",scaleX:1,scaleY:1,time:0.2,onComplete:checkBug});
		}
		
		//	Check bug landing
		private function checkBug():void{
			bug.land();			
			checkCollision();
		}
		
		//	Check bug collisions
		private function checkCollision():void{		
			var cnt:uint = enemyArray.length;
			while(cnt--){	
				var en = enemyArray[cnt]
				if(bug.hitTestObject(en)){
					score++;
					setScore();
					Tweener.addTween(en,{transition:"easeInCubicElastic",alpha:0,scaleX:0.2,scaleY:0.2,time:0.5});
					
					for(var i:uint=0;i<numHearts;i++){
					var p:heart = HeartArray[i];
					p.changeTarget(en.x,en.y);
				}
					
				}			
			}
		}
	}	
}