package view.windows.base {

	import events.UIEvent;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class ParentWindow extends ChildWindow {

		private var _bkgd			:Shape = new Shape();
		private var _heightOffset	:uint = 50;
		private var _closeButton	:ModalCloseButton;
		private static var _glow	:GlowFilter = new GlowFilter(0x000000, .5, 20, 20, 2, 2);		

		public function ParentWindow()
		{
			addChild(_bkgd);
			_bkgd.filters = [_glow];			
		}
	
		public function resize(w:Number, h:Number):void
		{
			this.x = uint(w / 2 - this.width / 2);
			this.y = uint((h - _heightOffset) / 2 - this.height / 2 + _heightOffset);
		}
		
		override protected function onAddedToStage(e:Event):void 
		{
			super.onAddedToStage(e);
			resize(stage.stageWidth, stage.stageHeight);
		}	
		
		protected function addCloseButton():void
		{
			_closeButton = new ModalCloseButton();
			_closeButton.over.alpha = 0;
			_closeButton.y = 6;
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
		}		
		
		protected function onCloseClick(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
