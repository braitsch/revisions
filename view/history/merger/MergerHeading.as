package view.history.merger {

	import model.AppModel;
	import view.btns.ButtonIcon;
	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MergerHeading extends Sprite {

		private static var _text		:TextHeading = new TextHeading();
		private static var _bkgd		:GradientBox = new GradientBox(false);
		private static var _icon		:ButtonIcon = new ButtonIcon(new OptionsArrow());
	
		public function MergerHeading()
		{
			_icon.y = 19; _icon.x = 20;
			_text.y = 12; _text.x = 35;
			_text.text = 'Open Merge View';
			addChild(_bkgd); addChild(_icon); addChild(_text);
			draw(this.width + 15);
			addEventListener(MouseEvent.CLICK, onMouseClick);
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
		
		private function onMouseClick(e:MouseEvent):void
		{
			AppModel.alert('Coming Soon.');	
		}		
		
	}
	
}
