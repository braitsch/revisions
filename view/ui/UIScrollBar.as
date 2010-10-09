/**
 *  CLASS : UIScrollBar
 *  VERSION : 1.20 
 *  LAST UPDATED : 08/27/2010
 *  ACTIONSCRIPT VERSION : 3.0 
 *  AUTHOR : Stephen Braitsch : stephen@quietless.com
**/

package view.ui {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;	
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class UIScrollBar extends Sprite {

		private var _mask			:Shape = new Shape();
		private var _dragger		:Sprite;
		private var _target			:DisplayObject;
		
		private var _homeY			:int;		// home ypos of the target //
		private var _sWidth			:uint;		// width of the scrollbar //
		private var _sHeight		:uint;		// height of the scrollbar //
		private var _dWidth			:uint;		// width of the dragger //		private var _dHeight		:uint;		// height of the dragger //

		public function UIScrollBar($sWidth:uint, $sHeight:uint, $dWidth:uint, $dHeight:uint)
		{
			_sWidth = $sWidth; 
			_sHeight = $sHeight;
			_dWidth = $dWidth;			_dHeight = $dHeight;
			
			drawBackground();
			drawDragger(_dWidth, _dHeight);
		}
		
	// public setters //	
		
		public function set target($do:DisplayObject):void
		{
			_target = $do; 
			_mask.x = _target.x;
			_mask.y = _homeY = _target.y;
			_target.mask = _mask;			
			_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			_target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);				
		}
		
		public function set backgroundImage($b:Bitmap):void
		{
			this.graphics.clear();
			addChildAt($b, 0);
		}
	
		public function set backgroundColor($c:uint):void
		{
			drawBackground($c);
		}	
		
		public function set draggerImage($b:Bitmap):void
		{
			_dragger.removeChildAt(0);		
			_dragger.addChild($b);
		// probably need to redraw dragger padding based on size of new image.	
		}
		
		public function drawMask($w:uint, $h:uint):void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFF00FF, .2);
			_mask.graphics.drawRect(0, 0, $w, $h);
			_mask.graphics.endFill();
		}

		public function reset($hard:Boolean = true):void
		{
			TweenLite.to(_target, $hard ? 0 : .5, {y:_homeY, ease:Strong.easeOut, overwrite:false});
			TweenLite.to(_dragger, $hard ? 0 : .5, {y:0, ease:Strong.easeOut});				
		}
		
		public function adjustToNewListHeight():void 
		{
		// show & hide scrollbar based on list height //	
			if (_target.height <= _mask.height) {
				this.reset();
				this.visible = false;
			}	else{
				this.visible = true;
				var m:int = -(_target.height-_mask.height-_homeY);
				if (_target.y < m){
		// and reposition target & dragger to max scroll //	
					TweenLite.to(_target, .3, {y:m});
					TweenLite.to(_dragger, .3, {y:(_sHeight - _dHeight)});
				}	else{
					this.updateDraggerPosition();
				}
			}	
		}			
	
	// private methods //	
		
		private function drawDragger($w:uint, $h:uint):void
		{
		// dragger padding //	
			var p:uint = 4; 
			_dragger = new Sprite(); 
			_dragger.graphics.beginFill(0x0000FF, 0);
			_dragger.graphics.drawRect(-p, -p, $w+(p*2), $h+(p*2));
			_dragger.graphics.endFill();
		// draw the visual component you see //	
			var s:Shape = new Shape();
				s.graphics.beginFill(0x919191);
				s.graphics.drawRect(0, 0, $w, $h);
				s.graphics.endFill();		
			_dragger.addChild(s);
			_dragger.buttonMode = true;
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, onDraggerPress);			
			addChild(_dragger);		
		}
		
		private function drawBackground($c:uint = 0x333333):void
		{
			this.graphics.clear();
			this.graphics.beginFill($c, 1);
			this.graphics.drawRect(0, 0, _sWidth, _sHeight);
			this.graphics.endFill();
		}		
		
		private function onDraggerPress(e:MouseEvent):void
		{
			var max:uint = _sHeight - _dHeight;
			_dragger.startDrag(false, new Rectangle(0, 0, 0, max));
			stage.addEventListener(Event.ENTER_FRAME, trackDraggerPos);		
		}
		
		private function trackDraggerPos(e:Event):void
		{
			var p:Number = _dragger.y / (_sHeight-_dHeight);
			var y:int = _homeY + ((_mask.height-_target.height) * p);
			TweenLite.to(_target, .3, {y:y});				
		}
		
		private function onDraggerRelease(e:MouseEvent):void
		{
			_dragger.stopDrag();
			stage.removeEventListener(Event.ENTER_FRAME, trackDraggerPos);			
		}
		
		private function onAddedToStage(e:Event):void
		{
			_target.parent.addChild(_mask);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDraggerRelease);				
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDraggerRelease);				
		}		

		private function updateDraggerPosition():void 
		{
			var p:Number = (_homeY-_target.y) / (_target.height-_mask.height);
			TweenLite.to(_dragger, .3, {y:(_sHeight - _dHeight)*p});				
		}

	}
	
}

