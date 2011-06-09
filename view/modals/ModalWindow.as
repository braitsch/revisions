package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import com.greensock.TweenLite;
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
		{			for (var i:int=0; i < a.length; i++) {
				a[i].buttonMode = true;
				a[i].mouseChildren = false;
		//TODO fix this once we get rid of all the old style buttons		
				if (a[i].hasOwnProperty('over')){
					a[i]['over'].alpha = 0;
					a[i].addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
					a[i].addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
				}
			}
		// tack on the close button //	
			_closeButton.y = 10;
			_closeButton.x = this.width - 10;
			_closeButton.over.alpha = 0;
			_closeButton.buttonMode = true;
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_closeButton.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_closeButton.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);			
			addChild(_closeButton);			
		}

		private function onButtonRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		private function onButtonRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}
		
		protected function addInputs(v:Vector.<TLFTextField>):void
		{
			_inputs = v;
			for (var i:int=0; i < v.length; i++) v[i].tabIndex = i;
		}
		
		protected function addCheckboxes(a:Array):void
		{
			for (var i:int=0; i < a.length; i++) {
				a[i].buttonMode = true;
				a[i].cross.visible = false;
				a[i].cross.mouseEnabled = false;
			}
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
				txt.setSelection(0, txt.length);
			}
		}

		private function onCloseClick(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}

	}
	
}
