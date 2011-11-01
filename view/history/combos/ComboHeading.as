package view.history.combos {

	import events.UIEvent;
	import view.btns.ButtonIcon;
	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ComboHeading extends Sprite {

		private var _icon		:ButtonIcon;
		private var _text		:TextHeading = new TextHeading();
		private var _bkgd		:GradientBox = new GradientBox(false);
	
		public function ComboHeading()
		{
			_text.y = 12;
			addChild(_bkgd); addChild(_text);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}

		public function setText(s:String):void
		{
			_text.text = s;
		}
		
		public function setIcon(i:Class, x:uint):void
		{
			if (_icon) removeChild(_icon);
			_icon = new ButtonIcon(new i());
			_icon.y = 19; _icon.x = x;
			_text.x = _icon.x + 15;
			addChild(_icon);
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
		
		private function onRollOver(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMBO_HEADING_OVER, parent));
		}		

		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMBO_HEADING_CLICK));
		}
		
	}
	
}
