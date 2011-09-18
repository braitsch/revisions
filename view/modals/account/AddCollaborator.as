package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.modals.collab.AddBeanstalkCollab;
	import view.modals.collab.AddGitHubCollab;
	import view.ui.TextHeading;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class AddCollaborator extends AccountView {

		private var _view			:*;
		private var _okBtn			:OkButton = new OkButton();	
		private var _backBtn		:BackButton = new BackButton();	
		private var _heading		:TextHeading = new TextHeading();

		public function AddCollaborator()
		{
			_heading.y = 5;
			addMybuttons();
			addChild(_heading);
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_view) removeChild(_view);
			if (super.account.type == HostingAccount.GITHUB){
				addGHCollab();
			}	else if (super.account.type == HostingAccount.BEANSTALK) {
				addBSCollab();
			}			
			_view.y = 35;
			addChild(_view);
		}
		
		private function addGHCollab():void
		{
			_view = new AddGitHubCollab(new Form1Wide());
			_heading.text = 'Please enter the GitHub user you\'d like to collaborate with on "'+super.account.repository.repoName+'"';
			_okBtn.y = _backBtn.y = 120;
		}
		
		private function addBSCollab():void
		{
			_view = new AddBeanstalkCollab();
			_heading.text = 'Fill in below to create a new user to collaborate with on "'+super.account.repository.repoName+'"';
			_okBtn.y = _backBtn.y = 192;
		}		
		
		private function addMybuttons():void
		{
			_okBtn.x = 518; _backBtn.x = 414; 
			_okBtn.addEventListener(MouseEvent.CLICK, onNextButton);	
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);	
			super.addButtons([_backBtn, _okBtn]);
			addChild(_okBtn);  addChild(_backBtn);
		}
		
		private function onNextButton(e:Event):void
		{
			_view.addCollaborator();
			AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);
		}
		
		private function onCollabAdded(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);
		}					
		
		private function onBackBtnClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}		
		
	}
	
}
