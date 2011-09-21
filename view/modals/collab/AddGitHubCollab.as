package view.modals.collab {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.vo.Collaborator;
	import view.modals.system.Message;
	import view.ui.Form;
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
		
		public function get collab():Collaborator { return _collab; }		
		
		public function addCollaborator():void
		{
			_collab.userName = _form.getField(0);
			_collab.firstName = '"'+_form.getField(0)+'"';
			var m:String = validate();
			if (m == null){
				Hosts.github.api.addCollaborator(_collab);
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			}				
		}
		
		private function validate():String
		{
			if (_form.getField(0) == '') return 'Field cannot be blank';
			return null;
		}
		
	}
	
}
