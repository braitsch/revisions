package view.modals {
	import commands.UICommand;

	import utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ModalWindow extends Sprite {
		
		private var _height		:Number;
		private var _inputs		:Vector.<TextField>;

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
		
		protected function isValidTarget(s:String, t:TextField):Boolean
		{
			if (StringUtils.hasTrailingWhiteSpace(s)){
				t.text = 'TARGET HAS TRAILING WHITE SPACE - IGNORED';
				return false;
			}	else{	
				return true;
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
			this.x = stage.stageWidth / 2 - this.width / 2;
			this.y = stage.stageHeight / 2 - (_height || this.height) / 2;
			
			if (_inputs) {
				var txt:TextField = _inputs[0];
				txt.stage.focus = txt;
				txt.setSelection(0, txt.text.length);
			}
		}		
		
		private function onCancelClick(e:MouseEvent):void 
		{
			dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));
		}
				
	}
	
}
