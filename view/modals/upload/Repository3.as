package view.modals.upload {

	import model.AppModel;
	import fl.text.TLFTextField;
	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.modals.base.ModalWindowBasic;
	import view.ui.Form;
	import flash.events.MouseEvent;

	public class Repository3 extends ModalWindowBasic {

		private static var _view		:NameRepositoryMC = new NameRepositoryMC();
		private static var _form		:Form;
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
			if (_form) removeChild(_form);
			var n:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;
			var d:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;
				n.text = AppModel.bookmark.label; d.text = '(optional)';
			if (s == HostingAccount.GITHUB){
				_form = new Form(new Form2());
				_form.inputs = [n, d];
				_form.labels = ['Name', 'Description'];
			}	else if (s == HostingAccount.BEANSTALK){
				_form = new Form(new Form1());
				_form.inputs = [n];
				_form.labels = ['Name'];
			}
			super.setHeading(_view, 'What would you like to call your bookmark inside your '+s+' account?');
			_form.y = 90;
			addChild(_form);
		}
		
		private function onBackButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}			
		
	}
	
}
