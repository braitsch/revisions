package view.history.switcher {

	import model.AppModel;
	import view.btns.ButtonIcon;
	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;

	public class SwitcherHeading extends Sprite {

		private static var _text		:TextHeading = new TextHeading();
		private static var _icon		:ButtonIcon = new ButtonIcon(new OptionsArrow());
		private static var _bkgd		:GradientBox = new GradientBox(false);
	
		public function SwitcherHeading()
		{
			_icon.y = 19; _icon.x = 20;
			_text.y = 12; _text.x = 35;
			addChild(_bkgd); addChild(_icon); addChild(_text);
		}
		
		public function setText():void
		{
			_text.text = AppModel.branch.name;
		}
		
		override public function get width():Number
		{
			return _text.x + _text.width;
		}			
	
		public function draw(w:uint):void
		{
			_bkgd.draw(w, 32);
			_bkgd.graphics.lineStyle(1, 0xcfcfcf, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			_bkgd.graphics.lineTo(0, 32);
			_bkgd.graphics.moveTo(w-1, 0);
			_bkgd.graphics.lineTo(w-1, 32);
			_bkgd.graphics.lineStyle(1, 0x000000, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			_bkgd.graphics.moveTo(0, 32);
			_bkgd.graphics.lineTo(w-1, 32);
			_bkgd.graphics.endFill();		
		}
		
	}
	
}
