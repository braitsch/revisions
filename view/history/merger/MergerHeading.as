package view.history.merger {

	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;

	public class MergerHeading extends Sprite {

		private static var _text		:TextHeading = new TextHeading();
		private static var _bkgd		:GradientBox = new GradientBox(false);
		private static var _icon		:Bitmap = new Bitmap(new OpenOptionsArrow());
	
		public function MergerHeading()
		{
			_icon.y = 10; _icon.x = 10;
			_text.y = 12; _text.x = 35;
			_text.text = 'Open Merge View';
			addChild(_bkgd); addChild(_icon); addChild(_text);
			draw(this.width + 15);
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
			_bkgd.graphics.lineTo(width-1, 32);
			_bkgd.graphics.endFill();		
		}
		
	}
	
}
