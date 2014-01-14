package view.btns {

	import flash.display.Sprite;
	import flash.text.TextFormat;
	public class FormButton extends Sprite {
		
		private var _btn		:DrawButton;
		private var _format		:TextFormat = new TextFormat();	
		
		public function FormButton(label:String, blue:Boolean = false)
		{
			if (blue){
				_format.size = 11;
				drawFlatBlueButton(label);
			}	else{
				_btn = new DrawButton(120, 30, label, 11);
				addChild(_btn);
			}
		}
		
		public function set enabled(b:Boolean):void
		{
			if (_btn){
				_btn.enabled = b;
			}	else{
				this.alpha = b ? 1 : .5;
				this.buttonMode = b;
			}
		}
		
		public function get enabled():Boolean
		{
			if (_btn){
				return _btn.enabled;	
			}	else{
				return this.alpha == 1;
			}
		}

		private function drawFlatBlueButton(s:String):void
		{
//			var b:Bitmap = new Bitmap(new FormButtonBlue());
//			addChild(b);
//			addLabel(s);
//			buttonMode = true;
//			this.filters = [DrawButton.GLOW];
		}
		
//		private function addLabel(s:String):void
//		{
//			var bl:ButtonLabel = new ButtonLabel();
//			bl.label.autoSize = TextFieldAutoSize.CENTER;
//			bl.label.mouseChildren = bl.label.mouseEnabled = false;
//			bl.label.setTextFormat(_format);
//			bl.label.filters = [DrawButton.GLOW];
//			bl.label.text = s;
//			bl.label.x = 60 - bl.label.width / 2;
//			bl.label.y = 15 - bl.label.height / 2 + 1; 
//			addChild(bl.label);
//		}
		
	}
	
}
