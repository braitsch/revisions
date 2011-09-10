package view.modals.upload {

	import events.UIEvent;
	import model.vo.Collab;
	import model.vo.UploadObj;
	import flash.events.Event;

	public class OnCollabAdded extends WizardWindow {

		public function OnCollabAdded()
		{
			super.addHeading();
			super.nextButton = new OkButton();
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}

		override protected function onAddedToStage(e:Event):void
		{
			var o:UploadObj = super.obj; var c:Collab = o.collaborator;
			var m:String = 'Awesome, I just added '+c.fullName+' to "'+o.repoName+'" on your '+o.service+' ';
				m+=	'account and sent them an email to let them know!';	
			super.heading = m;
		}	
		
		override protected function dispatchNext(e:Event = null):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}		
		
	}
	
}
