package view.windows.modals.system {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Branch;
	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.type.TextHeading;
	import view.ui.ModalCheckbox;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class Merge extends Alert {

		private static var _view		:MergeMC = new MergeMC();
		private static var _check		:ModalCheckbox = new ModalCheckbox(true);
		private static var _branchA		:Branch;
		private static var _branchB		:Branch;
		private static var _heading		:TextHeading = new TextHeading();			

		public function Merge()
		{
			addChild(_view);
			super.title = 'Confirm Merge';
			super.drawBackground(550, 300);
			addOkButton();
			addNoButton();
			addChild(_heading);
			_check.y = 261; addChild(_check);
			AppModel.proxies.editor.addEventListener(AppEvent.MERGE_COMPLETE, onMergeComplete);
		}
		
		public function setBranches(a:Branch, b:Branch):void
		{
			_branchA = a; _branchB = b; 
			var m:String = 'Would you like to merge the contents of '+a.name+' into '+b.name+'?\n';
				m+= 'Doing this will update '+b.name+' with the changes you made in '+a.name;
			_heading.text = m;
			_check.label = 'Delete branch '+a.name+' after merging';
			_view.branchA.x = 10; _view.branchB.x = 311;
			setBranchDetails(_view.branchA, a);
			setBranchDetails(_view.branchB, b);
		}

		private function setBranchDetails(mc:MergeBranchItemMC, b:Branch):void
		{
			mc.name_txt.text = b.name;
			mc.desc_txt.text = 'last updated : '+b.lastCommit.date;
			var a:Avatar = Avatars.getAvatar(b.lastCommit.email);
				a.x = a.y = 11;
			mc.addChild(a); 
		}
		
		override protected function onOkButton(e:Event):void
		{
			setTimeout(onTweenComplete, 1500, e);
			TweenLite.to(_view.branchA, 1, {x:161});
			TweenLite.to(_view.branchB, 1, {x:161});
		}
		
		private function onTweenComplete(e:Event):void
		{
			AppModel.proxies.editor.merge(_branchA, _branchB);
		}

		private function onMergeComplete(e:AppEvent):void
		{
			super.onOkButton(e);
			dispatchEvent(new UIEvent(UIEvent.CONFIRM, true));
		}

		override protected function onNoButton(e:UIEvent):void
		{
			super.onNoButton(e);
			dispatchEvent(new UIEvent(UIEvent.CONFIRM, false));
		}
		
	}
	
}
