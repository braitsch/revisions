package view.windows.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.remote.repo.SendProxy;
	import model.remote.HostingAccount;
	import view.ui.Form;
	import flash.events.Event;
	
	public class ConfirmDetails extends WizardWindow {

		private static var _form		:Form;
		private static var _send		:SendProxy = new SendProxy();

		public function ConfirmDetails()
		{
			super.addBackButton();
			super.addNextButton('OK');
			super.addHeading('Please confirm before we upload your bookmark:');
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
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
			_form = new Form(530);
			_form.labelWidth = 95;
			_form.fields = [{label:'Bookmark', enabled:false}, {label:'Repository', enabled:false}, 
				{label:'Description', enabled:false}, {label:'Account URL', enabled:false}];
		}
		
		private function attachBSForm():void
		{
			_form = new Form(530);
			_form.labelWidth = 95;
			_form.fields = [{label:'Bookmark', enabled:false}, {label:'Repository', enabled:false}, {label:'Account URL', enabled:false}];			
		}
		
		override protected function onNextButton(e:Event):void
		{
			var o:Object = {	acct	:	super.account,
								name	:	_form.getField(1),
								desc	:	super.account.type == HostingAccount.GITHUB ? _form.getField(2) : '',
								publik	:	super.repoPrivate == false	};
			_send.uploadBookmark(o);
			AppModel.engine.addEventListener(AppEvent.BKMK_ADDED_TO_ACCOUNT, onBkmkAddedToAccount);
		}

		private function onBkmkAddedToAccount(e:AppEvent):void
		{
			super.onNextButton(e);
		}
		
	}
	
}
