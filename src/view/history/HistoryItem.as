package view.history {

	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.type.TextDouble;
	import flash.display.Sprite;

	public class HistoryItem extends Sprite {

		private var _text			:TextDouble = new TextDouble();		
		private var _mask			:SolidBox = new SolidBox(0xff0000);

		public function HistoryItem()
		{
			buttonMode = true;
		}
		
		public function setWidth(w:uint):void 
		{ 
			_mask.draw(w - 70, 42);
		}		
		
		protected function setText(l1:String, l2:String):void
		{
			_text.x = 60; _text.y = 8;
			_text.line1 = l1;
			_text.line2 = l2;
			_text.mask = _mask;
			addChild(_text); addChild(_mask);
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
