package view.history.switcher {

	import model.AppModel;
	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class SwitcherHeading extends Sprite {

		private static var _text		:TextHeading = new TextHeading();
		private static var _bkgd		:GradientBox = new GradientBox(false, false);
		private static var _icon		:Bitmap = new Bitmap(new OpenOptionsArrow());
	
		public function SwitcherHeading()
		{
			_text.y = 12; _text.x = 30;
			_icon.y = 10; _icon.x = 7;
			addChild(_bkgd); addChild(_icon); addChild(_text);
		}
	
		public function draw():void
		{
			_text.text = AppModel.branch.name;
			_bkgd.draw(_text.x + _text.width + 20, 32);
			graphics.clear();
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 32, width, 1);
			graphics.endFill();		
		}
		
	}
	
}
