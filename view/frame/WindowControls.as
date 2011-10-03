package view.frame {

	import flash.display.NativeWindowDisplayState;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	public class WindowControls extends Sprite {

		private static var _btns		:WindowControlsMC = new WindowControlsMC();

		public function WindowControls()
		{
			addChild(_btns);
			addEventListener(MouseEvent.CLICK, onButtonClick);
			_btns.filters = [new DropShadowFilter(2, 90, 0xffffff, .2, 1, 2)];
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch(e.target.name){
				case 'close' : 	
					this.stage.nativeWindow.close();
				break;
				case 'minimize' : 
					this.stage.nativeWindow.minimize();
				break;
				case 'maximize' :
					if (this.stage.nativeWindow.displayState != NativeWindowDisplayState.NORMAL){
						this.stage.nativeWindow.restore();
					}	else{
						this.stage.nativeWindow.maximize();
					}
				break;								
			}
		}
		
	}
	
}
