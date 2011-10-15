package view.history.combos {

	import events.UIEvent;
	import view.btns.ButtonIcon;
	import view.graphics.Box;
	import view.graphics.GradientBox;
	import view.graphics.SolidBox;
	import view.type.TextHeading;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ComboItem extends Sprite {

		public static const ITEM_HEIGHT		:uint = 30;
		
		private var _text			:TextHeading;
		private var _icon			:ButtonIcon;
		private var _kill			:ComboItemKillButton;
		private var _over			:SolidBox = new SolidBox(Box.WHITE);
		private var _bkgd			:GradientBox = new GradientBox(true);
	
		public function ComboItem(s:String, i:Class, x:uint, k:Boolean = false)
		{
			_over.alpha = 0;
			addChild(_bkgd);		
			addChild(_over);
			setText(s, x); addIcon(i, x); if (k) addKill();
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		override public function get width():Number
		{
			return _text.x + _text.width;
		}		
		
		public function draw(w:uint):void
		{
			_over.draw(w, ITEM_HEIGHT);
			_bkgd.draw(w, ITEM_HEIGHT);
			if (_kill)	_kill.x = w - 17;
		}
		
		private function setText(s:String, x:uint):void
		{
			_text = new TextHeading(s);
			_text.color = 0x555555;
			_text.y = 9;
			_text.x = x + 15;
			addChild(_text);				
		}
		
		private function addIcon(i:Class, x:uint):void
		{
			_icon = new ButtonIcon(new i());
			_icon.y = 16; _icon.x = x;
			addChild(_icon);
		}
		
		private function addKill():void
		{
			_kill = new ComboItemKillButton();
			addChild(_kill);
		}

		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:1});
		}

		private function onRollOut(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:0});
		}

		private function onMouseClick(e:MouseEvent):void
		{
			if (e.target == _kill) {
				dispatchEvent(new UIEvent(UIEvent.COMBO_OPTION_KILL, parent.getChildIndex(this)));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.COMBO_OPTION_CLICK, parent.getChildIndex(this)));
			}
		}			
		
	}
	
}
