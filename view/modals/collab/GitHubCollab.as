package view.modals.collab {

	import view.ui.Form;
	
	public class GitHubCollab extends Collaborator {

		private var _form 		:Form = new Form(new Form1());

		public function GitHubCollab()
		{
			_form.labels = ['UserName'];
			super.form = _form;
		}

	}
	
}
