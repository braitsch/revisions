package view.modals.upload {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.ui.Form;
	import flash.events.Event;
	
	public class ConfirmDetails extends WizardWindow {

		private static var _form		:Form;
		private static var _data		:Object;
		private static var _service		:String;

		public function ConfirmDetails()
		{
			super.addBackButton();
			super.nextButton = new OkButton();
			super.addHeading('Please confirm before we upload your bookmark:');
			AppModel.engine.addEventListener(AppEvent.BKMK_ADDED_TO_ACCOUNT, onBkmkAddedToAcct);
		}
		
		public function set service(s:String):void
		{
			_service = s; attachForm();
		}
		
		public function set data(o:Object):void
		{
			_data = o;
			_form.setField(0, AppModel.bookmark.label);
			_form.setField(1, o.repo);
			if (_service == HostingAccount.GITHUB){
				_form.setField(2, o.desc == '(optional)' ? '' : o.desc);
				_form.setField(3, o.url);
			}	else if (_service == HostingAccount.BEANSTALK){
				_form.setField(2, o.url);
			}					
		}
		
		private function attachForm():void
		{
			if (_form) removeChild(_form);
			if (_service == HostingAccount.GITHUB){
				attachGHForm();
			}	else if (_service == HostingAccount.BEANSTALK){
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
		// capture here the newly created repo id from beanstalk	
			super.onNextButton(e);
		}		
		
		override protected function onNextButton(e:Event):void
		{
			var api:ApiProxy = _service == HostingAccount.GITHUB ? Hosts.github.api : Hosts.beanstalk.api; 
			var o:Object = {	bkmk	:	AppModel.bookmark, 
								acct	:	api,
								name	:	_form.getField(0),
								desc	:	_service == HostingAccount.GITHUB ? _form.getField(2) : '',
								publik	:	_data.selected == false	};
			AppModel.proxies.remote.addBkmkToAccount(o);
		}			
		
	}
	
}
