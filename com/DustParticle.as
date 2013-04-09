/*****************
Author: Rsandagon
URL: Rsandagon.com
Date:20 January 2010

This is for dust magic in your games
*****************/

package com{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
 	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.BlendMode;
 
	public class DustParticle extends Sprite{
		//	Set Variables
		var dust_particle:Sprite;
		var target:MovieClip;
		
		var initX:Number;
		var initY:Number;
		
		var targetX:Number;
		var	targetY:Number
		
		var endX:Number = 0;
		var endY:Number = 0;
		
		var timeRand:Number;
		var bezier1x:Number;
		var bezier1y:Number;
		var bezier3x:Number;
		var bezier3y:Number;
			
		//	Set Dustparticle
		function DustParticle():void{
			dust_particle = this as Sprite;
			CurveModifiers.init(); 		
		}
		
		//	Changes Target 
		public function changeTarget(tX,tY):void{
			targetX = tX;
			targetY = tY;
			Tweener.addTween(dust_particle, {alpha:0, time:0.2, transition:"linear",onComplete:startDustIn});
		}		
		
		//	Changes end Target: OPTIONAL
		public function setEndTarget(eX:Number,eY:Number):void{
			endX = eX;
			endY = eY;
		}
		
		public function startDustIn():void{
			this.alpha=1
			initX = targetX - ((30*0.5)-30*Math.random());
			initY = targetY + (30*0.5)*Math.random();			
						
			//	remove this if you want to assign end X			
			endX = initX;
			endY = initY - 100;
			
			//	randomize time
			timeRand = 1 + Math.random()*3;
			
			//	set dust properties
			dust_particle.x = initX;
			dust_particle.y = initY;
			
			//	set Bezier
			dust_particle.blendMode = BlendMode.ADD;
			bezier1x = initX - Math.random()*10;
			bezier1y = initY - Math.random()*50;
			
			bezier3x = endX + Math.random()*10;
			bezier3y = endY + Math.random()*10;
			
			moveDust();			
		}
		
		//	move dust particle
		private function moveDust(){
			Tweener.addTween(dust_particle, {x:endX, y:endY, _bezier:[{x:bezier1x, y:bezier1y}, {x:bezier3x, y:bezier3y}], time:timeRand, transition:"linear",onComplete:disappear});			
		}
		
		//	remove dust particle from view
		private function disappear():void{
			Tweener.addTween(dust_particle, {alpha:0, time:0.2, transition:"linear"});
		}				
	}
}