package view.history.combos {

	import view.btns.ButtonIcon;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;

	public class ComboItemKillButton extends ButtonIcon {

		private var _tweening	:Boolean;

		public function ComboItemKillButton()
		{
			y = 16;
			mouseChildren = false;
			super(new SwitcherDelete());
			addEventListener(MouseEvent.ROLL_OVER, onKillOver);
		}

		private function onKillOver(e:MouseEvent):void
		{
			if (_tweening == false ) {
				_tweening = true;
				TweenLite.to(this, .3, {rotation:'90', onComplete:function():void{ _tweening = false; }});
			}
		}
		
	}
	
}
