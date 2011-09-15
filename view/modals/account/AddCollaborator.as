package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.modals.collab.BeanstalkCollab;
	import view.modals.collab.GitHubCollab;
	import view.ui.TextHeading;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class AddCollaborator extends AccountView {

		private var _collab			:*;
		private var _okBtn			:OkButton = new OkButton();	
		private var _backBtn		:BackButton = new BackButton();	
		private var _heading		:TextHeading = new TextHeading();

		public function AddCollaborator()
		{
			_heading.y = 0;
			addMybuttons();
			addChild(_heading);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_collab) removeChild(_collab);
			if (super.account.type == HostingAccount.GITHUB){
				_collab = new GitHubCollab(new Form1Wide());
				_heading.text = 'Please enter the GitHub user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';
			}	else if (super.account.type == HostingAccount.BEANSTALK) {
				_collab = new BeanstalkCollab();
				_heading.text = 'Fill in below to create a new user to collaborate with on "'+AppModel.bookmark.label+'"';
			}
			_collab.y = 35;
			_collab.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollabAdded);
			addChild(_collab);
		}	
		
		private function onCollabAdded(e:AppEvent):void
		{
			trace("AddCollaborator.onCollabAdded(e)!!");
		}
		
		private function addMybuttons():void
		{
			_okBtn.y = _backBtn.y = 120; 
			_okBtn.x = 518; _backBtn.x = 414; 
			addChild(_okBtn);  addChild(_backBtn); 
			_okBtn.addEventListener(MouseEvent.CLICK, onNextButton);	
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);	
			super.addButtons([_backBtn, _okBtn]);
		}
		
		private function onNextButton(e:MouseEvent):void
		{
			_collab.addCollaborator(super.repository);
		}			
		
		private function onBackBtnClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}		
		
	}
	
}
