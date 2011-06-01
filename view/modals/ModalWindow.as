package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class ModalWindow extends Sprite {
		
		private var _height			:Number;
		private var _inputs			:Vector.<TLFTextField>;
		private var _heightOffset	:uint = 50;
		private var _closeButton	:ModalCloseButton = new ModalCloseButton();

		public function ModalWindow()
		{		
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.filters = [new GlowFilter(0x000000, .5, 20, 20, 2, 2)];
		}
		
		override public function set height(n:Number):void
		{
		// masked lists seem to blow out the height and screw up positioning..	
			_height = n;
		}			
		
		protected function addButtons(a:Array):void
		{			for (var i : int = 0; i < a.length; i++) {
				a[i].buttonMode = true;
				a[i].mouseChildren = false;
				if (a[i].numChildren == 3){
					var label:Bitmap = a[i].getChildAt(2) as Bitmap;
					label.x = -(label.width/2) + 2;
					label.y = -(label.height/2) + 2;
				}
			}
		// tack on the close button //	
			_closeButton.y = 10;
			_closeButton.x = this.width - 10;
			_closeButton.buttonMode = true;
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			addChild(_closeButton);			
		}
		
		protected function addInputs(v:Vector.<TLFTextField>):void
		{
			_inputs = v;
			for (var i : int = 0; i < v.length; i++) v[i].tabIndex = i;
		}
		
	// private methods //	

		private function onAddedToStage(e:Event):void 
		{
			var w:uint = stage.stageWidth;
			var h:uint = stage.stageHeight;
			this.x = w/2 - this.width / 2;
			this.y = (h-_heightOffset)/2 - this.height / 2 + _heightOffset;			
			if (_inputs) {
				var txt:TLFTextField = _inputs[0];
				txt.stage.focus = txt;
				txt.setSelection(0, txt.text.length);
			}
		}		
		
		private function onCloseClick(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}
				
	}
	
}
