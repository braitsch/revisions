package view.modals.collab {

	import model.remote.Hosts;
	import model.vo.Collaborator;
	import model.vo.Repository;
	import view.ui.Form;
	import flash.display.Sprite;
	
	public class GitHubCollab extends Sprite {

		private var _form 			:Form;
		private var _collab			:Collaborator = new Collaborator();
		private var _repository		:Repository;		
		
		public function GitHubCollab(f:Sprite)
		{
			_form = new Form(f);
			_form.labels = ['Username'];
			_form.enabled = [1];
			addChild(_form);
		}
		
		public function get collab():Collaborator { return _collab; }		
		
		public function addCollaborator(r:Repository):void
		{
			_repository = r;
			_collab.userName = _form.getField(0);
			_collab.fullName = '"'+_form.getField(0)+'"';
			Hosts.github.api.addCollaborator(_collab, _repository);
		}
		
	}
	
}
