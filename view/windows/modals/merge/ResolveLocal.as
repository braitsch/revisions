package view.windows.modals.merge {

	import model.proxies.AppProxies;
	import view.type.TextHeading;
	import flash.events.Event;

	public class ResolveLocal extends ResolveConflict {

		private static var _heading		:TextHeading = new TextHeading();

		public function ResolveLocal(x:Array)
		{
			setHeading();
			var a:Array = x[0].split('-#-');
			var b:Array = x[1].split('-#-');
			super.setCommitObjects(a, b);
			super.commitA.heading = 'Your latest version, authored by '+a[3];
			super.commitB.heading = 'Their latest version, authored by '+b[3];				
		}
		
		private function setHeading():void
		{
			var m:String = 'Hmm... I was unable to auto-sync these two branches due to how much they differ.';
				m+='Please choose which branch you would like to make priority.';
			_heading.text = m;			
			addChild(_heading);
		}
		
		override protected function onOkButton(e:Event):void
		{
			super.onOkButton(e);
			if (super.commitA.selected){
				AppProxies.merge.mergeOurs();
			}	else if (super.commitB.selected){
				AppProxies.merge.mergeTheirs();
			}
		}		
			
	}
	
}
