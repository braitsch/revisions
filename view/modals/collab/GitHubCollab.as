package view.modals.collab {

	import view.ui.Form;
	import flash.display.Sprite;
	
	public class GitHubCollab extends Sprite {

		private var _form 		:Form = new Form(new Form1());

		public function GitHubCollab()
		{
			_form.labels = ['UserName'];
		}
		
		public function addCollaborator():void
		{
	//		Hosts.github.api.addCollaborator(_repository, _fullName);
	//		Hosts.github.api.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);						
		}
		
//		private function onCollaboratorAdded(e:AppEvent):void
//		{
//			var m:String = 'Awesome! I just added "'+_fullName+'" to your Beanstalk repository "'+_repository+'" ';
//				m+='and just sent them an email so they\'re in the know. \nRock on now & get back to work!';
//			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
//			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
//			Hosts.github.api.removeEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);				
//		}			

	}
	
}
