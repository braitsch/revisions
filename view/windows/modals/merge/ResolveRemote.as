package view.windows.modals.merge {

	import model.proxies.AppProxies;
	import system.BashMethods;
	import view.type.TextHeading;
	import flash.events.Event;

	public class ResolveRemote extends ResolveConflict {

		private static var _heading		:TextHeading = new TextHeading();

		public function ResolveRemote(x:Array)
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
			var m:String = 'Hmm... I was unable to auto-merge your latest version with what\'s on the server.\n';
				m+='Please choose whose version should be the latest that everyone will sync from.';
			_heading.text = m;			
			addChild(_heading);
		}
		
		override protected function onOkButton(e:Event):void
		{
			super.onOkButton(e);
			if (super.commitA.selected){
				AppProxies.merge.syncRemote(BashMethods.MERGE_OURS);
			}	else if (super.commitB.selected){
				AppProxies.merge.syncRemote(BashMethods.MERGE_THEIRS);
			}
		}		
			
	}
	
}
