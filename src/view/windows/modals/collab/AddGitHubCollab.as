package view.windows.modals.collab {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.vo.Collaborator;
	import view.ui.Form;
	import view.windows.modals.system.Message;
	import flash.display.Sprite;
	
	public class AddGitHubCollab extends Sprite {

		private var _form 			:Form;
		private var _collab			:Collaborator = new Collaborator();
		
		public function AddGitHubCollab(w:uint)
		{
			_form = new Form(w);
			_form.fields = [{label:'Username'}];
			addChild(_form);
		}
		
		public function addCollaborator():void
		{
			_collab.userName = _form.getField(0);
			_collab.firstName = '"'+_form.getField(0)+'"';
			var m:String = validate();
			if (m){
				AppModel.alert(new Message(m));
			}	else{
				Hosts.github.api.addCollaborator(_collab);
				AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorAdded);
			}				
		}

		private function onCollaboratorAdded(e:AppEvent):void
		{
			dispatchEvent(new AppEvent(AppEvent.COLLABORATOR_ADDED, _collab));
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorAdded);			
		}
		
		private function validate():String
		{
			if (_form.getField(0) == '') return 'Field cannot be blank';
			return null;
		}
		
	}
	
}
