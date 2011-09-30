package view.history {

	import model.AppModel;
	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class HistoryTitle extends Sprite {

		private static var _text		:TextHeading = new TextHeading();
		private static var _bkgd		:GradientBox = new GradientBox(false);
		private static var _icon		:Bitmap = new Bitmap(new SmallClock());

		public function HistoryTitle()
		{
			this.visible = false;
			_icon.y = 10; _icon.x = 23;
			_text.y = 12; _text.x = 48;
			addChild(_bkgd); addChild(_icon); addChild(_text);			
		}
		
		public function draw():void
		{
			_text.text = 'History of '+AppModel.bookmark.label;
			_bkgd.draw(_text.x + _text.width + 15, 32);
			this.visible = true;
		}		
		
	}
	
}
