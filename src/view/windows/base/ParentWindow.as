package view.windows.base {

	import events.UIEvent;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class ParentWindow extends ChildWindow {

		private var _bkgd					:Shape = new Shape();
		private var _badge					:PageBadge;
		private var _closeButton			:ModalCloseButton;
		
		private static var _glow			:GlowFilter = new GlowFilter(0x000000, .5, 20, 20, 2, 2);		

		public function ParentWindow()
		{
			_bkgd.filters = [_glow];		
		}
	
		public function resize(w:Number, h:Number):void
		{
			this.x = int((w/2) - (this.width / 2));
			this.y = int((h/2) - (this.height / 2));
		}
		
		protected function set title(s:String):void
		{
			if (_badge == null){
				_badge = new PageBadge();
				_badge.x = 10;
				addChild(_badge);
			}
			_badge.label_txt.text = s;
		}		
		
		override protected function onAddedToStage(e:Event):void 
		{
			super.onAddedToStage(e);
			resize(stage.stageWidth, stage.stageHeight);
		}
		
		protected function addCloseButton():void
		{
			_closeButton = new ModalCloseButton();
			_closeButton.y = 6;
			_closeButton.over.alpha = 0;
			_closeButton.buttonMode = true;
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_closeButton.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_closeButton.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);			
			addChild(_closeButton);
		}
		
		protected function drawBackground(w:uint, h:uint):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginFill(0xFFFFFF);
			_bkgd.graphics.drawRect(0, 0, w, h);
			_bkgd.graphics.endFill();
			_bkgd.graphics.beginBitmapFill(new LtGreyPattern());
			_bkgd.graphics.drawRect(4, 4, w-8, h-8);
			_bkgd.graphics.endFill();
			if (_closeButton) _closeButton.x = w - 6;
			addChildAt(_bkgd, 0);
		}		
		
		protected function onCloseClick(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
		private function onButtonRollOut(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .3, {alpha:0});
		}

		private function onButtonRollOver(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .5, {alpha:1});
		}		
		
	}
	
}
