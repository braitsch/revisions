package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.events.Event;

	public class NameRmtRepo extends WizardWindow {

		private static var _form		:Form;
		private static var _name		:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;	
		private static var _desc		:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;	
		private static var _url			:TLFTextField = new FINorm().getChildAt(0) as TLFTextField; 
		private static var _service		:String;
		private static var _preview		:Form = new Form(new Form1());
		private static var _private		:ModalCheckbox = new ModalCheckbox(false);

		public function NameRmtRepo()
		{
			addChild(_preview);
			
			_url.x = 120; _url.y = 16; 
			_preview.addChild(_url);
			_preview.labels = ['URL Preview'];
			_preview.deactivateFields(['field1']);
			_name.addEventListener(Event.CHANGE, onNameChange);
			
			_private.y = 235;
			_private.label = 'Make repository private';
			addChild(_private);
			
			super.addHeading();
			super.addBackButton();
			super.nextButton = new NextButton();
		}

		public function set service(s:String):void
		{
			_service = s; attachForm();
		}
		
		private function attachForm():void
		{
			if (_form) removeChild(_form);
			if (_service == HostingAccount.GITHUB){
				attachGHForm();
			}	else if (_service == HostingAccount.BEANSTALK){
				attachBSForm();
			}
			_preview.y = 90 + _form.height + 10;
			_form.y = 90; addChild(_form);
			_form.addEventListener(UIEvent.ENTER_KEY, onNextButton);
			super.heading = 'What would you like to call your bookmark inside your '+_service+' account?';			
		}
		
		private function attachGHForm():void
		{
			_form = new Form(new Form2());
			_form.inputs = [_name, _desc];
			_form.labels = ['Name', 'Description'];
			_private.visible = true;			
		}

		private function attachBSForm():void
		{
			_form = new Form(new Form1());
			_form.inputs = [_name];
			_form.labels = ['Name'];
			_private.visible = false;			
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			_name.text = AppModel.bookmark.label.toLowerCase();
			_desc.text = '(optional)';
			generatePreviewURL();
			super.onAddedToStage(e);
		}
		
		private function onNameChange(e:Event):void
		{
			generatePreviewURL();
		}		
		
		private function generatePreviewURL():void
		{
			if (_service == HostingAccount.GITHUB){
				_url.text = 'https://github.com/'+Hosts.github.loggedIn.acct+'/';
			} 	else if (_service == HostingAccount.BEANSTALK){
				_url.text = 'https://'+Hosts.beanstalk.loggedIn.acct+'.beanstalkapp.com/';
			}
			_url.text += _form.fields[0].replace(/\s/g, '-');
		}
		
		override public function onEnterKey():void { onNextButton(); }
		override protected function onNextButton(e:Event = null):void
		{
			if (validate()){
				super.dispatchNext(e, {repo:_name.text.replace(/\s/g, '-'), desc:_desc.text, url:_url.text, selected:_private.selected});
			}
		}
		
		private function validate():Boolean
		{	
			var m:String;
			if (_name.text.search(/^\d/g) != -1){
				m= 'The name of your bookmark online must begin with a letter.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			}	else if (checkForDuplicate() == true){
				m = 'Remote repository already exists.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			} 	else if (_form.validate() == false){
				return false;
			}	else{
				return true;
			}
		}
		
		private function checkForDuplicate():Boolean
		{
			var n:String = _name.text.replace(/\s/, '-').toLowerCase();
			if (AppModel.bookmark.getRemoteByProp('name', _service.toLowerCase()+'-'+n)){
				return true;
			}	else{
				return false;
			}
		}		
		
	}
	
}
