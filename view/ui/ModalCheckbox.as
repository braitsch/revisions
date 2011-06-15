package view.ui {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class ModalCheckbox extends Sprite {

		private var _view:ModalCheckboxMC;

		public function ModalCheckbox(v:ModalCheckboxMC, on:Boolean)
		{
			_view = v;
			_view.buttonMode = true;
			_view.cross.visible = on;
			_view.label_txt.autoSize = 'left';
			_view.label_txt.mouseEnabled = false;
			_view.addEventListener(MouseEvent.CLICK, onToggle);
		}
		
		public function set label(s:String):void
		{
			_view.label_txt.text = s;
			_view.graphics.clear();
			_view.graphics.beginFill(0xff0000, .2);
			_view.graphics.drawRect(2, 2, _view.width-4, _view.height-4);
			_view.graphics.endFill();				
		}
		
		public function set selected(b:Boolean):void
		{
			_view.cross.visible = b;
		}
		
		public function get selected():Boolean
		{
			return _view.cross.visible;	
		}

		private function onToggle(e:MouseEvent):void 
		{
			_view.cross.visible = !_view.cross.visible;			
		}
		
	}
	
}
