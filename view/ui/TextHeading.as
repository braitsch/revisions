package view.ui {

	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	public class TextHeading extends Sprite {

		private var _fmt		:TextFormat = new TextFormat();
		private var _txt		:TextHeadingMC = new TextHeadingMC();

		public function TextHeading(txt:String = '', size:uint = 12, color:uint = 0x666666)
		{
			this.x = 10; this.y = 70;
			this.mouseChildren = this.mouseEnabled = false;
			this.size  = size;
			this.color = color;
			this.text  = txt;
			this.autoSize = TextFieldAutoSize.LEFT;
			addChild(_txt);
		}

		public function set text(s:String):void
		{
			_txt.label_txt.text = s;
		}
		
		public function set size(n:uint):void
		{
			_fmt.size = n;
			_txt.label_txt.setTextFormat(_fmt);
		}
		
		public function set color(n:uint):void
		{
			_fmt.color = n;
			_txt.label_txt.setTextFormat(_fmt);
		}
		
		public function set autoSize(s:String):void
		{
			_txt.label_txt.autoSize = s;
		}
		
	}
	
}

