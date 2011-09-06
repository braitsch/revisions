package view.modals.upload {

	import fl.text.TLFTextField;
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
		private static var _bkmk		:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;	
		private static var _repo		:TLFTextField = new FINorm().getChildAt(0) as TLFTextField; 
		private static var _desc		:TLFTextField = new FINorm().getChildAt(0) as TLFTextField; 
		private static var _url			:TLFTextField = new FINorm().getChildAt(0) as TLFTextField; 

		public function ConfirmDetails()
		{
			super.addBackButton();
			super.nextButton = new OkButton();
			super.addHeading('Please confirm before we upload your bookmark:');
			
			_bkmk.x = _repo.x = _desc.x = _url.x = 120;
			_bkmk.y = 106; _repo.y = 106 + Form.LEADING;
			addChild(_bkmk); addChild(_repo); addChild(_desc); addChild(_url);
		}
		
		public function set service(s:String):void
		{
			_service = s; attachForm();
		}
		
		public function set data(o:Object):void
		{
			_data = o;
			_bkmk.text = AppModel.bookmark.label;
			_repo.text = o.repo; _url.text = o.url;
			_desc.text = o.desc == '(optional)' ? '' : o.desc;
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
			_form.deactivateFields(['field1', 'field2', 'field3', 'field4']);
			_desc.visible = true;
			_desc.y = 106 + Form.LEADING * 2; _url.y = 106 + Form.LEADING * 3;			
		}
		
		private function attachBSForm():void
		{
			_form = new Form(new Form3());
			_form.labels = ['Bookmark', 'Repository', 'Account URL'];
			_form.deactivateFields(['field1', 'field2', 'field3']);
			_desc.visible = false;
			_url.y = 106 + Form.LEADING * 2;			
		}
		
		override protected function onAddedToStage(e:Event):void
		{
		// required for pages that don't have input fields with auto-focus //	
			stage.focus = this;
			super.onAddedToStage(e);
		}
		
		override public function onEnterKey():void { onNextButton(); }		
		override protected function onNextButton(e:Event = null):void
		{
			var api:ApiProxy = _service == HostingAccount.GITHUB ? Hosts.github.api : Hosts.beanstalk.api; 
			var o:Object = {	bkmk	:	AppModel.bookmark, 
								acct	:	api,
								name	:	_repo.text,
								desc	:	_desc.text, 
								publik	:	_data.selected == false	};
			AppModel.proxies.remote.addBkmkToAccount(o);
		}			
		
	}
	
}
