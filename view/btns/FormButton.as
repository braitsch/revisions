package view.btns {
	import flash.events.Event;


	public class FormButton extends DrawButton {

		public function FormButton(label:String, x:uint = 0, y:uint = 0)
		{
			super(120, 30, label, 11);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			
		}
		
	}
	
}
