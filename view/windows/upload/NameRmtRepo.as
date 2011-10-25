package view.windows.upload {

	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import view.windows.modals.system.Message;
	import flash.events.Event;

	public class NameRmtRepo extends WizardWindow {

		private static var _form		:Form;
		private static var _preview		:Form = new Form(530);
		private static var _private		:ModalCheckbox = new ModalCheckbox(false);

		public function NameRmtRepo()
		{
			super.addHeading();
			super.addBackButton();
			super.addNextButton();
			
			_preview.labelWidth = 100;
			_preview.fields = [{label:'URL Preview', enabled:false}];
			addChild(_preview);
			
			_private.y = 255;
			_private.label = 'Make repository private';
			addChild(_private);
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		private function attachForm():void
		{
			if (_form) removeChild(_form);
			if (super.account.acctType == HostingAccount.GITHUB) {
				attachGHForm();
			}	else if (super.account.acctType == HostingAccount.BEANSTALK){
				attachBSForm();
			}
			_preview.y = 90 + _form.height + 15;
			_form.y = 90; addChild(_form);
			_form.getInput(0).addEventListener(Event.CHANGE, onNameChange);
			super.heading = 'What would you like to call your bookmark inside your '+super.account.acctType+' account?';			
		}
		
		private function attachGHForm():void
		{
			_form = new Form(530);
			_form.labelWidth = 100;
			_form.fields = [{label:'Name'}, {label:'Description'}];
			_private.visible = true;
		}

		private function attachBSForm():void
		{
			_form = new Form(530);
			_form.labelWidth = 100;
			_form.fields = [{label:'Name'}];
			_private.visible = false;			
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			attachForm();
			_form.setField(0, AppModel.bookmark.label.toLowerCase());
			if (super.account.acctType == HostingAccount.GITHUB) _form.setField(1, '(optional)');
			generatePreviewURL();
			super.onAddedToStage(e);
		}
		
		private function onNameChange(e:Event):void
		{
			generatePreviewURL();
		}		
		
		private function generatePreviewURL():void
		{
			if (super.account.acctType == HostingAccount.GITHUB){
				_preview.setField(0, 'https://github.com/'+Hosts.github.account.acctName+'/');
			} 	else if (super.account.acctType == HostingAccount.BEANSTALK){
				_preview.setField(0, 'https://'+Hosts.beanstalk.account.acctName+'.beanstalkapp.com/');
			}
			_preview.getInput(0).text += _form.getField(0).replace(/\s/g, '-') + '.git';
		}
		
		override protected function onNextButton(e:Event):void
		{
			if (validate()){
				super.repoName = _form.getField(0).replace(/\s/g, '-');
				super.repoDesc = super.account.acctType == HostingAccount.GITHUB ? _form.getField(1) : '';
				super.repoURL = _preview.getField(0);
				super.repoPrivate = _private.selected;
				super.onNextButton(e);
			}
		}
		
		private function validate():Boolean
		{	
			if (_form.getField(0).search(/^\d/g) != -1){
				AppModel.alert(new Message('The name of your bookmark online must begin with a letter.'));
				return false;
			}	else if (checkForDuplicate() == true){
				AppModel.alert(new Message('Remote repository already exists.'));
				return false;
			} 	else if (_form.validate() == false){
				return false;
			}	else{
				return true;
			}
		}
		
		private function checkForDuplicate():Boolean
		{
			var n:String = _form.getField(0).replace(/\s/, '-').toLowerCase();
			if (AppModel.bookmark.getRemoteByProp('name', super.account.acctType.toLowerCase()+'-'+n)){
				return true;
			}	else{
				return false;
			}
		}		
		
	}
	
}
