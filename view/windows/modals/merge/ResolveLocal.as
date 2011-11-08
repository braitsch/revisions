package view.windows.modals.merge {

	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Branch;
	import system.BashMethods;
	import view.type.TextHeading;
	import flash.events.Event;

	public class ResolveLocal extends ResolveConflict {

		private static var _heading		:TextHeading = new TextHeading();

		public function ResolveLocal(x:Array, mergeBranch:Branch)
		{
			setHeading();
			var a:Array = x[0].split('-#-');
			var b:Array = x[1].split('-#-');
			super.setCommitObjects(a, b);
			super.commitA.heading = 'Latest version on branch - '+AppModel.branch.name;
			super.commitB.heading = 'Latest version on branch - '+mergeBranch.name;
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
				trace('super.commitA.selected');
				AppProxies.merge.syncLocal(BashMethods.MERGE_OURS);
			}	else if (super.commitB.selected){
				trace('super.commitB.selected');
				AppProxies.merge.syncLocal(BashMethods.MERGE_THEIRS);
			}
		}		
			
	}
	
}
