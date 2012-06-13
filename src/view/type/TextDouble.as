package view.type {

	import flash.display.Sprite;
	public class TextDouble extends Sprite {
		
		private var _line1	:TextHeading = new TextHeading();
		private var _line2	:TextHeading = new TextHeading();

		public function TextDouble()
		{
			_line1.y = 0;
			_line1.size = 12;
			_line1.color = 0x555555;
			_line2.y = 15;
			_line2.size = 9;
			_line2.color = 0x777777;
			_line1.x =_line2.x = 0;
			_line1.multiline = _line2.multiline = false;
			addChild(_line1);
			addChild(_line2);
		}

		public function set line1(s:String):void
		{
			_line1.text = s;
		}
		
		public function set line2(s:String):void
		{
			_line2.text = s;
		}
		
		public function set maxWidth(n:uint):void
		{
			_line1.maxWidth = n;
			_line2.maxWidth = n;
		}
		
	}
	
}
