package view.history {

	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.type.TextDouble;
	import flash.display.Sprite;

	public class HistoryItem extends Sprite {

		private var _text			:TextDouble = new TextDouble();		

		public function HistoryItem()
		{
			buttonMode = true;
		}
		
		protected function setText(l1:String, l2:String):void
		{
			_text.x = 60; _text.y = 8;
			_text.line1 = l1;
			_text.line2 = l2;
		//	_text.line1.mouseEnabled = _text.line1.mouseChildren = false; 
		//	_text.line2.mouseEnabled = _text.line2.mouseChildren = false; 
			addChild(_text);			
		}
		
		protected function attachAvatar(k:String):void
		{
			var a:Avatar = Avatars.getAvatar(k);
			var b:SolidBox = new SolidBox(Box.LT_GREY);
				b.draw(34, 34);
			var s:Sprite = new Sprite();
			a.x = 2; a.y = 2;
			s.x = 14; s.y = 4;
			s.addChild(b); s.addChild(a); addChild(s);			
		}
		
	}
	
}
