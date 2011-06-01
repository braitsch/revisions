package view.history {

	import view.Scroller;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class HistoryHeader extends Sprite {

		private static var _pound		:Bitmap = new Bitmap(new labelPound());
		private static var _created		:Bitmap = new Bitmap(new labelCreated());
		private static var _details		:Bitmap = new Bitmap(new labelDetails());
		private static var _actions		:Bitmap = new Bitmap(new labelActions());
		private static var _pattern		:Shape = new Shape();
		private static var _columns		:Sprite = new Sprite();
		private static var _scroller	:Scroller = new Scroller();
		private static var _hrule		:Sprite = new Sprite();

		public function HistoryHeader()
		{
			addChild(_pattern);
			addChild(_pound);
			addChild(_created);
			addChild(_details);
			addChild(_actions);
			addChild(_columns);
	//TODO not sure yet about having the scroller in here...		
			addChild(_scroller);
			addChild(_hrule);
			_pound.x = 15;
			_created.x = 70;
			_details.x = 174;
			_actions.x = 526;
			_hrule.y = 32;
			_pound.y = _created.y = _details.y = _actions.y = 13;
			_hrule.filters = [new DropShadowFilter(1, 90, 0, .5, 4, 4, 1, 3)];
			attachColumns();
		}

		private function attachColumns():void
		{
			for (var i:int = 0; i < 3; i++) {
				var s:Sprite = new Sprite();
					s.addChild(new Bitmap(new VerticalBar()));
				_columns.addChild(s);
			}
			_columns.getChildAt(0).x = 37;
			_columns.getChildAt(1).x = 153;
		}

		public function resize(w:uint, h:uint):void
		{
			_pattern.graphics.beginBitmapFill(new DkGreyPattern());
			_pattern.graphics.drawRect(0, 0, w, 32);
			_pattern.graphics.endFill();			
			_actions.x = w-80;
			_columns.getChildAt(2).x = w-109;
			_scroller.x = w - 5;
			_scroller.draw(h);
			drawHRule(w);
			drawColumns(h);
		}

		private function drawColumns(h:uint):void
		{
			for (var i:int = 0; i < 3; i++) {
				var c:Sprite = _columns.getChildAt(i) as Sprite;
				c.graphics.clear();
				c.graphics.beginFill(0x717171);
				c.graphics.drawRect(0, 0, 2, h);
				c.graphics.beginFill(0xffffff);
				c.graphics.drawRect(2, 0, 1, h);
				c.graphics.beginFill(0x717171);
				c.graphics.drawRect(3, 0, 2, h);			
				c.graphics.endFill();			
			}
		}
		
		private function drawHRule(w:uint):void
		{
			_hrule.graphics.clear();
			_hrule.graphics.beginFill(0x000000);
			_hrule.graphics.drawRect(0, 0, w, 1);
			_hrule.graphics.beginFill(0xb3b3b3);
			_hrule.graphics.drawRect(0, 1, w, 1);
			_hrule.graphics.endFill();			
		}
		
	}
	
}
