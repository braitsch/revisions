package view.modals.upload {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.modals.base.ModalWindowBasic;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Repository3 extends ModalWindowBasic {

		private static var _view		:NameRepositoryMC = new NameRepositoryMC();
		private static var _form		:Sprite;
		private static var _backBtn		:BackButton = new BackButton();

		public function Repository3()
		{
			addChild(_view);
			addChild(_backBtn);
			super.addButtons([_backBtn]);
			_backBtn.x = 475; _backBtn.y = 260; 
			_backBtn.addEventListener(MouseEvent.CLICK, onBackButton);			
		}
		
		public function set service(s:String):void
		{
			if (s == HostingAccount.GITHUB){
				_form = new Form2();
			}	else if (s == HostingAccount.BEANSTALK){
				_form = new Form1(); 
			}
			_form.y = 90;
			addChild(_form);
			super.setHeading(_view, 'Name your '+s+' repository');
		}
		
		private function onBackButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}			
		
	}
	
}
