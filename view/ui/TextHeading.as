package view.ui {

	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	public class TextHeading extends Sprite {

		private var _txt		:TextHeadingMC = new TextHeadingMC();

		public function TextHeading(s:String = '')
		{
			this.x = 10; 
			this.y = 70;
			this.mouseChildren = this.mouseEnabled = false;
			_txt.label_txt.autoSize = TextFieldAutoSize.LEFT;
			addChild(_txt);
			this.text = s;
		}
		
		public function set text(s:String):void
		{
			_txt.label_txt.text = s || '';	
		}
		
		public function set color(n:uint):void
		{
			_txt.label_txt.textColor = n;
		}
		
	}
	
}

