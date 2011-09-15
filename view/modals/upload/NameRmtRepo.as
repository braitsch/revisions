package view.modals.upload {

	import events.UIEvent;
	import events.AppEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.system.Message;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.events.Event;

	public class NameRmtRepo extends WizardWindow {

		private static var _form		:Form;
		private static var _preview		:Form = new Form(new Form1());
		private static var _private		:ModalCheckbox = new ModalCheckbox(false);

		public function NameRmtRepo()
		{
			super.addHeading();
			super.addBackButton();
			super.nextButton = new NextButton();
			
			_preview.labels = ['URL Preview'];
			_preview.enabled = [];
			addChild(_preview);
			
			_private.y = 235;
			_private.label = 'Make repository private';
			addChild(_private);
			
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		private function attachForm():void
		{
			if (_form) removeChild(_form);
			if (super.service == HostingAccount.GITHUB){
				attachGHForm();
			}	else if (super.service == HostingAccount.BEANSTALK){
				attachBSForm();
			}
			_preview.y = 90 + _form.height + 10;
			_form.y = 90; addChild(_form);
			_form.getInput(0).addEventListener(Event.CHANGE, onNameChange);
			super.heading = 'What would you like to call your bookmark inside your '+super.service+' account?';			
		}
		
		private function attachGHForm():void
		{
			_form = new Form(new Form2());
			_form.labels = ['Name', 'Description'];
			_form.enabled = [1, 2];
			_private.visible = true;
		}

		private function attachBSForm():void
		{
			_form = new Form(new Form1());
			_form.labels = ['Name'];
			_form.enabled = [1];
			_private.visible = false;			
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			attachForm();
			_form.setField(0, AppModel.bookmark.label.toLowerCase());
			if (super.service == HostingAccount.GITHUB) _form.setField(1, '(optional)');
			generatePreviewURL();
			super.onAddedToStage(e);
		}
		
		private function onNameChange(e:Event):void
		{
			generatePreviewURL();
		}		
		
		private function generatePreviewURL():void
		{
			if (super.service == HostingAccount.GITHUB){
				_preview.setField(0, 'https://github.com/'+Hosts.github.loggedIn.acct+'/');
			} 	else if (super.service == HostingAccount.BEANSTALK){
				_preview.setField(0, 'https://'+Hosts.beanstalk.loggedIn.acct+'.beanstalkapp.com/');
			}
			_preview.getInput(0).text += _form.getField(0).replace(/\s/g, '-') + '.git';
		}
		
		override protected function onNextButton(e:Event):void
		{
			if (validate()){
				super.repoName = _form.getField(0).replace(/\s/g, '-');
				super.repoDesc = super.service == HostingAccount.GITHUB ? _form.getField(1) : '';
				super.repoURL = _preview.getField(0);
				super.repoPrivate = _private.selected;
				super.dispatchNext();
			}
		}
		
		private function validate():Boolean
		{	
			var m:Message;
			if (_form.getField(0).search(/^\d/g) != -1){
				m = new Message('The name of your bookmark online must begin with a letter.');
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			}	else if (checkForDuplicate() == true){
				m = new Message('Remote repository already exists.');
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
			var n:String = _form.getField(0).replace(/\s/, '-').toLowerCase();
			if (AppModel.bookmark.getRemoteByProp('name', super.service.toLowerCase()+'-'+n)){
				return true;
			}	else{
				return false;
			}
		}		
		
	}
	
}
