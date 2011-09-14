package view.modals.account {


	import events.UIEvent;
	import flash.events.MouseEvent;
	public class AddCollaborator extends AccountView {

		private var _backBtn		:BackButton = new BackButton();	

		public function AddCollaborator()
		{
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, 300, 200);
			addBackButton();
		}
		
		private function addBackButton():void
		{
			_backBtn.x = 516; _backBtn.y = 312; addChild(_backBtn); 
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);	
			super.addButtons([_backBtn]);
		}
		
		private function onBackBtnClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}		
		
	}
	
}
