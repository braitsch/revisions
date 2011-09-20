package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.ui.Form;
	import flash.events.Event;
	
	public class ConfirmDetails extends WizardWindow {

		private static var _form		:Form;

		public function ConfirmDetails()
		{
			super.addBackButton();
			super.nextButton = new OkButton();
			super.addHeading('Please confirm before we upload your bookmark:');
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
			AppModel.engine.addEventListener(AppEvent.BKMK_ADDED_TO_ACCOUNT, onBkmkAddedToAcct);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			attachForm(); setFields();
		}		
		
		private function setFields():void
		{
			_form.setField(0, AppModel.bookmark.label);
			_form.setField(1, super.repoName);
			if (super.account.type == HostingAccount.GITHUB){
				_form.setField(2, super.repoDesc == '(optional)' ? '' : super.repoDesc);
				_form.setField(3, super.repoURL);
			}	else if (super.account.type == HostingAccount.BEANSTALK){
				_form.setField(2, super.repoURL);
			}					
		}
		
		private function attachForm():void
		{
			if (_form) removeChild(_form);
			if (super.account.type == HostingAccount.GITHUB){
				attachGHForm();
			}	else if (super.account.type == HostingAccount.BEANSTALK){
				attachBSForm();
			}			
			_form.y = 90; addChildAt(_form, 0); 
		}
		
		private function attachGHForm():void
		{
			_form = new Form(new Form4());
			_form.labels = ['Bookmark', 'Repository', 'Description', 'Account URL'];
			_form.enabled = [];
		}
		
		private function attachBSForm():void
		{
			_form = new Form(new Form3());
			_form.labels = ['Bookmark', 'Repository', 'Account URL'];
			_form.enabled = [];
		}
		
		private function onBkmkAddedToAcct(e:AppEvent):void
		{
			super.onNextButton(e);
		}		
		
		override protected function onNextButton(e:Event):void
		{
			var o:Object = {	acct	:	super.account,
								name	:	_form.getField(1),
								desc	:	super.account.type == HostingAccount.GITHUB ? _form.getField(2) : '',
								publik	:	super.repoPrivate == false	};
			AppModel.proxies.remote.addBkmkToAccount(o);
		}			
		
	}
	
}
