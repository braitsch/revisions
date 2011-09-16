package view.ui {

	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class AccountRadio extends Sprite {

		private var _view	:AccountRadioMC = new AccountRadioMC();

		public function AccountRadio(on:Boolean)
		{
			_view.buttonMode = true;
			_view.mouseChildren = false;
			_view.check.visible = on;
			_view.label.autoSize = 'left';
			_view.label.mouseEnabled = false;
			_view.addEventListener(MouseEvent.CLICK, onRadioSelected);
			addChild(_view);
		}
		
		public function set label(s:String):void
		{
			_view.label.text = s;
			_view.graphics.clear();
			_view.graphics.beginFill(0xff0000, 0);
			_view.graphics.drawRect(2, 2, _view.width-4, _view.height-4);
			_view.graphics.endFill();
		}
		
		public function set selected(b:Boolean):void
		{
			_view.check.visible = b;
		}
		
		public function get selected():Boolean
		{
			return _view.check.visible;	
		}
		
		private function onRadioSelected(e:MouseEvent):void 
		{
			if (this.selected == false){
				_view.check.visible = true;
				dispatchEvent(new UIEvent(UIEvent.RADIO_SELECTED));
			}
		}
		
	}
	
}
