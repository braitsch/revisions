package view.modals.base {

	import events.UIEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ModalWindow extends ModalWindowBasic {

		private var _heightOffset	:uint = 50;
		private var _closeButton	:ModalCloseButton;
	
		public function resize(w:Number, h:Number):void
		{
			this.x = uint(w / 2 - this.width / 2);
			this.y = uint((h - _heightOffset) / 2 - this.height / 2 + _heightOffset);
		}
		
		override protected function onAddedToStage(e:Event):void 
		{
			resize(stage.stageWidth, stage.stageHeight);
		}	
		
		protected function addCloseButton(x:uint = 550):void
		{
			_closeButton = new ModalCloseButton();
			_closeButton.over.alpha = 0;
			_closeButton.y = 10;
			_closeButton.x = x - 10;
			_closeButton.buttonMode = true;
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_closeButton.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_closeButton.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);			
			addChild(_closeButton);				
		}
		
		protected function onCloseClick(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
