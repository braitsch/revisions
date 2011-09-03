package view.ui {

	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BasicButton extends Sprite {
		
		private var _btn:Sprite;

		public function BasicButton(b:Sprite)
		{
			_btn = b;
			addChild(_btn);
		}

		public function set enabled(b:Boolean):void
		{
			if (b){
				_btn.alpha = 1;
				_btn.buttonMode = true;
				_btn.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				_btn.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			}	else{
				_btn.alpha = .5;
				_btn.buttonMode = false;
				_btn.removeEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				_btn.removeEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			}
		}
		
		public function get enabled():Boolean
		{
			return _btn.alpha == 1;
		}
		
		protected function onButtonRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		protected function onButtonRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}		
		
	}
	
}
