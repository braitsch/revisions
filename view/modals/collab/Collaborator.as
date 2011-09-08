package view.modals.collab {

	import view.ui.Form;
	import flash.display.Sprite;

	public class Collaborator extends Sprite {

		private var _form		:Form;

		public function set form(f:Form):void
		{
			_form = f;
			addChild(_form);
		}
		
		public function validate():Boolean
		{
			return _form.validate();
		}

		public function get form():Form
		{
			return _form;
		}
		
	}
	
}
