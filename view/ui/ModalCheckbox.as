package view.ui {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class ModalCheckbox extends Sprite {

		private var _view				:*;
		private static var _glowFilter	:GlowFilter = new GlowFilter(0x000000, .1, 2, 2, 3, 3);

		public function ModalCheckbox(on:Boolean, lg:Boolean = false)
		{
			if (lg){
				_view = new ModalCheckboxLG();
			}	else{
				_view = new ModalCheckboxMC();
				_view.x = 9;
			}
			addChild(_view);
			_view.buttonMode = true;
			_view.check.visible = on;
			_view.label_txt.autoSize = 'left';
			_view.label_txt.mouseEnabled = false;
			_view.label_txt.mouseChildren = false;
			_view.label_txt.filters = [_glowFilter];
			_view.addEventListener(MouseEvent.CLICK, onToggle);
		}
		
		public function set label(s:String):void
		{
			_view.label_txt.text = s;
			_view.graphics.clear();
			_view.graphics.beginFill(0xff0000, 0);
			_view.graphics.drawRect(-2, -2, _view.width-2, _view.height-2);
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
		
		override public function set visible(b:Boolean):void
		{
			_view.visible = b;	
		}

		private function onToggle(e:MouseEvent):void 
		{
			_view.check.visible = !_view.check.visible;			
		}
		
	}
	
}
