package view.modals {

	import flash.events.KeyboardEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import com.greensock.TweenLite;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class ModalWindow extends Sprite {
		
		private var _inputs			:Vector.<TLFTextField>;
		private var _heightOffset	:uint = 50;
		private var _closeButton	:ModalCloseButton;
	
		public function ModalWindow()
		{		
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.filters = [new GlowFilter(0x000000, .5, 20, 20, 2, 2)];
		}
		
	// override this in any windows that should listen for the enter key //	
		public function onEnterKey():void { }
		
		public function resize(w:Number, h:Number):void
		{
			this.x = w / 2 - this.width / 2;
			this.y = (h - _heightOffset) / 2 - this.height / 2 + _heightOffset;			
		}
		
		protected function addButtons(a:Array):void
		{			for (var i:int=0; i < a.length; i++) {
				a[i].buttonMode = true;
				a[i].mouseChildren = false;
				a[i]['over'].alpha = 0;
				a[i].addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				a[i].addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			}
		}
		
		protected function addCloseButton():void
		{
			_closeButton = new ModalCloseButton();
			_closeButton.y = 10;
			_closeButton.x = this.width - 10;
			_closeButton.over.alpha = 0;
			_closeButton.buttonMode = true;
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_closeButton.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_closeButton.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);			
			addChild(_closeButton);				
		}
		
		protected function enableButton(b:Sprite, on:Boolean):void
		{
			if (on){
				b.alpha = 1;
				b.buttonMode = true;
				b.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				b.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			}	else{
				b.alpha = .5;
				b.buttonMode = false;
				b.removeEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				b.removeEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);				
			}
		}
		
		protected function addInputs(v:Vector.<TLFTextField>):void
		{
			_inputs = v;
			for (var i:int=0; i < v.length; i++) v[i].tabIndex = i;
		}
		
		protected function onCloseClick(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}		
		
		private function onAddedToStage(e:Event):void 
		{
			resize(stage.stageWidth, stage.stageHeight);	
			if (_inputs) {
				var txt:TLFTextField = _inputs[0];
				txt.setSelection(0, txt.length);
				txt.textFlow.interactionManager.setFocus();
				for (var i:int = 0; i < _inputs.length; i++) {
					InteractiveObject(_inputs[i].getChildAt(1)).tabIndex = i;
					InteractiveObject(_inputs[i].getChildAt(1)).addEventListener(KeyboardEvent.KEY_UP, onKeyUpEvent);
				}
			}
		}

		private function onKeyUpEvent(e:KeyboardEvent):void
		{
		//TODO this is fucking bullshit. need to move back to classic textfields	
			if (e.keyCode == 13) onEnterKey();			
		}
		
		private function onButtonRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		private function onButtonRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}

	}
	
}
