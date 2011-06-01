package view.modals {

	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ModalWindow extends Sprite {
		
		private var _height			:Number;
		private var _inputs			:Vector.<TextField>;
		private var _heightOffset	:uint = 50;

		public function ModalWindow()
		{		
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override public function set height(n:Number):void
		{
		// masked lists seem to blow out the height and screw up positioning..	
			_height = n;
		}			
		
		protected function set cancel(btn:Sprite):void
		{
			stroke();
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.CLICK, onCancelClick);
		}
		
		protected function addButtons(a:Array):void
		{			for (var i : int = 0; i < a.length; i++) a[i].buttonMode = true;
		}
		
		protected function addInputs(v:Vector.<TextField>):void
		{
			_inputs = v;
			for (var i : int = 0; i < v.length; i++) {
				v[i].tabIndex = i;
				v[i].selectable = true;
			}
		}
		
	// private methods //	

		private function stroke():void 
		{
			graphics.lineStyle(2, 0xCCCCCC);
			graphics.drawRect(-3, -3, this.width+6, this.height+6);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			var w:uint = stage.stageWidth;
			var h:uint = stage.stageHeight;
			this.x = w/2 - this.width / 2;
			this.y = (h-_heightOffset)/2 - this.height / 2 + _heightOffset;			
			if (_inputs) {
				var txt:TextField = _inputs[0];
				txt.stage.focus = txt;
				txt.setSelection(0, txt.text.length);
			}
		}		
		
		private function onCancelClick(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}
				
	}
	
}
