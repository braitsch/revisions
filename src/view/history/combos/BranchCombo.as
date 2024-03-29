package view.history.combos {

	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Branch;
	import view.windows.modals.system.Confirm;
	import view.windows.modals.system.Message;

	public class BranchCombo extends ComboGroup {

		private static var _branch	:Branch;

		public function BranchCombo()
		{
			super.allowOptionDelete();
			super.optionIcon = BranchIcon;
			super.headingIcon = BranchIcon;
			addEventListener(UIEvent.COMBO_OPTION_KILL, onBranchDelete);
			addEventListener(UIEvent.COMBO_OPTION_CLICK, onBranchSelection);
		}

		public function draw():void
		{
			super.headingText = 'On Branch : '+AppModel.branch.name;
			var a:Vector.<String> = new Vector.<String>();
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			for (var i:int = 0; i < b.length; i++) if (b[i] != AppModel.branch) a.push('Switch To : '+b[i].name);
			super.options = a;
		}
		
		private function onBranchSelection(e:UIEvent):void
		{
			if (AppModel.branch.isModified){
				AppModel.alert(new Message('Please save your changes before moving to a new branch.'));					
			}	else{
				AppProxies.editor.changeBranch(AppModel.bookmark.branches[e.data]);
			}				
		}	
		
		private function onBranchDelete(e:UIEvent):void
		{
			_branch = AppModel.bookmark.branches[e.data];
			var k:Confirm = new Confirm('Delete branch "'+_branch.name+'"?\nWarning this cannot be undone.');
				k.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.alert(k);	
		}			
		
		private function onConfirm(e:UIEvent):void
		{
			if (e.data as Boolean == true) AppProxies.editor.killBranch(_branch);
		}	
		
	}
	
}
