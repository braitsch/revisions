	package view.type {

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextHeading extends Sprite {

		private var _fmt			:TextFormat = new TextFormat();
		private var _txt			:TextHeadingMC = new TextHeadingMC();
		private var _str			:String;

		public function TextHeading(txt:String = '')
		{
			_fmt.leading = 1;
			_txt.label_txt.y = -3; // correct for the leading adjusment //
			_txt.label_txt.autoSize = TextFieldAutoSize.LEFT;
			this.x = 10; this.y = 70;
			this.text = txt;
			this.mouseChildren = this.mouseEnabled = false;
			addChild(_txt);
		}
		
		public function set text(s:String):void
		{
			_txt.label_txt.text = _str = s;
			_txt.label_txt.setTextFormat(_fmt);
		}
		
		public function set multiline(b:Boolean):void
		{
			_txt.label_txt.wordWrap = false;
			_txt.label_txt.multiline = false;	
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
		
		public function set letterSpacing(n:Number):void
		{
			_fmt.letterSpacing = n;
			_txt.label_txt.setTextFormat(_fmt);
		}
		
		public function set maxWidth(w:uint):void
		{
			_txt.label_txt.text = _str;
			if (_txt.label_txt.width > w){
				var p:Point = _txt.label_txt.localToGlobal(new Point(w, 0));
				var k:uint = _txt.label_txt.getCharIndexAtPoint(p.x, p.y);
				_txt.label_txt.text = _txt.label_txt.text.substr(0, k)+'...';
			}
		}
		
	}
	
}

