package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class ModalWindow extends ModalWindowBasic {

		private var _heightOffset	:uint = 50;
		private var _closeButton	:ModalCloseButton;
	
		public function ModalWindow()
		{		
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.filters = [new GlowFilter(0x000000, .5, 20, 20, 2, 2)];
		}
		
		public function resize(w:Number, h:Number):void
		{
			this.x = uint(w / 2 - this.width / 2);
			this.y = uint((h - _heightOffset) / 2 - this.height / 2 + _heightOffset);
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
		
		private function onAddedToStage(e:Event):void 
		{
			resize(stage.stageWidth, stage.stageHeight);	
			if (super.inputs) {
				var txt:TLFTextField = super.inputs[0];
				txt.setSelection(0, txt.length);
				txt.textFlow.interactionManager.setFocus();
				for (var i:int = 0; i < super.inputs.length; i++) InteractiveObject(super.inputs[i].getChildAt(1)).tabIndex = i;
			}
		}
		
	}
	
}
