package view.modals.collab {

	import view.ui.Form;
	
	public class BeanstalkCollab extends Collaborator {

		private var _form 		:Form = new Form(new Form4());

		public function BeanstalkCollab()
		{
			_form.labels = ['First Name', 'Last Name', 'Login', 'Password'];
			super.form = _form;			
		}

	}
	
}
