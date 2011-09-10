package view.modals.collab {

	import events.AppEvent;
	import model.remote.Hosts;
	import view.ui.Form;
	
	public class GitHubCollab extends CollabView {

		private var _form 		:Form = new Form(new Form1());
		
		public function GitHubCollab()
		{
			_form.labels = ['Username'];
			_form.enabled = [1];
			addChild(_form);
		}
		
		override public function addCollaborator():void
		{
			super.collab.userName = _form.getField(0);
			super.collab.fullName = '"'+_form.getField(0)+'"';
			Hosts.github.api.addCollaborator(super.collab);
			Hosts.github.api.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);
		}
		
		private function onCollaboratorAdded(e:AppEvent):void
		{
			dispatchEvent(new AppEvent(AppEvent.COLLABORATOR_ADDED, super.collab));
			Hosts.github.api.removeEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);				
		}			

	}
	
}
