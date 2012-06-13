package view.windows.modals.merge {

	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.type.TextDouble;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class CommitItem extends Sprite {
		
		private var _text		:TextDouble = new TextDouble();
		private var _avatar		:Sprite;
		private var _heading	:TextHeading = new TextHeading();
		private var _bkgd		:Bitmap = new Bitmap(new ResolveCommitBkgd());
		private var _glow		:Bitmap = new Bitmap(new ResolveCommitGlow());
		
		public function CommitItem()
		{
			addChild(_glow);
			addChild(_bkgd);
			addChild(_text);
			addChild(_heading);
			buttonMode = true;
			_heading.y = -20;
			_glow.x = _glow.y = -9; 
			_text.x = 60; _text.y = 12;
		}
		
		public function set heading(s:String):void
		{
			_heading.text = s;	
		}
		
		public function setText(s1:String, s2:String):void
		{
			_text.line1 = s1;	
			_text.line2 = s2;
			_text.maxWidth = 460;
		}
		
		public function set selected(b:Boolean):void
		{
			_glow.visible = b;
		}
		
		public function get selected():Boolean
		{
			return _glow.visible;
		}
		
		public function attachAvatar(k:String):void
		{
			if (_avatar) removeChild(_avatar);
			var a:Avatar = Avatars.getAvatar(k);
				a.x = 2; a.y = 2;
			var b:SolidBox = new SolidBox(Box.LT_GREY);
				b.draw(34, 34);
			_avatar = new Sprite();
			_avatar.x = 14; _avatar.y = 8;
			_avatar.addChild(b); 
			_avatar.addChild(a); 
			addChild(_avatar);			
		}		
		
	}
	
}