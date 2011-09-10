package view.ui {

	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	public class TextHeading extends Sprite {

		private var _txt		:TextHeadingMC = new TextHeadingMC();

		public function TextHeading()
		{
			_txt.x = 10; _txt.y = 70;
			_txt.label_txt.autoSize = TextFieldAutoSize.LEFT;
			addChild(_txt);
		}
		
		public function set text(s:String):void
		{
			_txt.label_txt.text = s;	
		}
		
	}
	
}
