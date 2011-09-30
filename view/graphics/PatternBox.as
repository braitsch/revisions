package view.graphics {


	import flash.display.BitmapData;
	public class PatternBox extends Box {

		private var _pattern:BitmapData;

		public function PatternBox(p:BitmapData)
		{
			_pattern = p;	
		}
		
		override public function draw(w:uint, h:uint):void
		{
			super.draw(w, h);
			graphics.clear();
			graphics.beginBitmapFill(_pattern);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}		
		
	}
	
}
