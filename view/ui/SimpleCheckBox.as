package view.ui {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class SimpleCheckBox extends Sprite {

		private var _view:SimpleCheckBoxMC = new SimpleCheckBoxMC();
		private var _padding:uint = 4;

		public function SimpleCheckBox($on:Boolean = false, $label:String = '')
		{
			addChild(_view);
			_view.label_txt.autoSize = 'left';
			_view.label_txt.text = $label;
			_view.label_txt.visible = $label!='';
			_view.label_txt.mouseEnabled = false;
			_view.check.visible = $on;
			
			buttonMode = true;
			graphics.beginFill(0xff0000, 0);
			graphics.drawRect(-_padding, -_padding, _view.width+_padding, _view.height+_padding);
			addEventListener(MouseEvent.CLICK, onCheckToggle);
		}
		
		public function get selected():Boolean
		{
			return _view.check.visible;	
		}

		private function onCheckToggle(e:MouseEvent):void 
		{
			_view.check.visible = !_view.check.visible;			
		}
		
	}
	
}
