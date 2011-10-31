package view.windows.modals.system {

	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.type.TextDouble;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class ResolveCommit extends Sprite {
		
		private var _bkgd		:Bitmap = new Bitmap(new ResolveCommitBkgd());
		private var _text		:TextDouble = new TextDouble();
		private var _avatar		:Sprite;
		private var _heading	:TextHeading = new TextHeading();
		
		public function ResolveCommit()
		{
			addChild(_bkgd);
			addChild(_text);
			addChild(_heading);
			_heading.y = -16;
			_text.x = 60; _text.y = 12;
			buttonMode = true;
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
		//	TweenMax.to(this, .5, {glowFilter:{color:b ? 0x91e600 : 0x000000, alpha:.5, blurX:20, blurY:20}});
		}
		
		public function attachAvatar(k:String):void
		{
			if (_avatar) removeChild(_avatar);
			var a:Avatar = Avatars.getAvatar(k);
				a.x = 2; a.y = 2;
			var b:SolidBox = new SolidBox(Box.LT_GREY);
				b.draw(34, 34);
			_avatar = new Sprite();
			_avatar.x = 14; _avatar.y = 9;
			_avatar.addChild(b); 
			_avatar.addChild(a); 
			addChild(_avatar);			
		}		
		
	}
	
}