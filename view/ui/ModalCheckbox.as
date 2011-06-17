package view.ui {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	public class ModalCheckbox extends Sprite {

		private var _view	:ModalCheckboxMC;
		private var _format	:TextFormat = new TextFormat();

		public function ModalCheckbox(v:ModalCheckboxMC, on:Boolean)
		{
			_view = v;
			_view.buttonMode = true;
			_view.cross.visible = on;
			_format.letterSpacing = .6;
			_view.label_txt.autoSize = 'left';
			_view.label_txt.mouseEnabled = false;
			_view.label_txt.defaultTextFormat = _format;
			_view.label_txt.filters = [new GlowFilter(0x000000, .2, 2, 2, 3, 3)];
			_view.addEventListener(MouseEvent.CLICK, onToggle);
		}
		
		public function set label(s:String):void
		{
			_view.label_txt.text = s;
			_view.graphics.clear();
			_view.graphics.beginFill(0xff0000, 0);
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
		
		override public function set visible(b:Boolean):void
		{
			_view.visible = b;	
		}

		private function onToggle(e:MouseEvent):void 
		{
			_view.cross.visible = !_view.cross.visible;			
		}
		
	}
	
}
