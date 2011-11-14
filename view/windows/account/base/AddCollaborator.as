package view.windows.account.base {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.type.TextHeading;
	import flash.events.Event;
	public class AddCollaborator extends AccountPage {

		private var _heading		:TextHeading = new TextHeading();

		public function AddCollaborator()
		{
			_heading.y = 5;
			addChild(_heading);
			super.addOkButton('Add Collaborator', 443);
			super.addNoButton('Go Back', 313);
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
			addEventListener(UIEvent.NO_BUTTON, onPrevButton);
		}
		
		protected function set heading(s:String):void
		{
			_heading.text = s;
		}
		
		protected function onNextButton(e:Event):void
		{
			AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);
		}
		
		private function onPrevButton(e:UIEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}	
		
		private function onCollabAdded(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);
		}				
		
	}
	
}
