package view.modals.upload {

	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.ui.DrawButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class OnBkmkAdded extends WizardWindow {

		private static var _viewAcct		:DrawButton = new DrawButton(250, 36, 'Link To GitHub', 12);
		private static var _addCollab		:DrawButton = new DrawButton(250, 36, 'Add A Collaborator', 12);		

		public function OnBkmkAdded()
		{
			setButtons();
			super.addHeading();
		}

		private function setButtons():void
		{
			_viewAcct.x = _addCollab.x = 150;
			_viewAcct.y = 110; _addCollab.y = 170;
			addChild(_viewAcct); addChild(_addCollab);			
			addEventListener(MouseEvent.CLICK, onButtonSelection);
		}

		override protected function onAddedToStage(e:Event):void
		{
			_viewAcct.label = 'View My '+super.account.type+' Account';
			var m:String = 'You just pushed "'+AppModel.bookmark.label+'" up to a shiny new repository on '+super.account.type+'! ';
				m+='\nWhat would you like to do now?';
			super.heading = m;
		}

		private function onButtonSelection(e:MouseEvent):void
		{
			if (e.target == _viewAcct){
				if (super.account.type == HostingAccount.GITHUB){
					dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
				}	else if (super.account.type == HostingAccount.BEANSTALK){
					dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
				}
			}	else if (e.target == _addCollab){
				dispatchEvent(new UIEvent(UIEvent.ADD_COLLABORATOR));
			}
		}		
				
	}
	
}
