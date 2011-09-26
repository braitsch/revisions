package view.windows.account {


	import com.greensock.TweenLite;
	import events.AppEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import model.AppModel;
	import model.vo.Collaborator;
	import view.ui.TextHeading;
	import view.windows.modals.system.Confirm;
	public class CollaboratorViewBS extends AccountView {
	
		private var _item			:Sprite;
		private var _line2			:TextHeading = new TextHeading();		
		private var _pool			:Vector.<Collaborator>;
		private var _collab			:Collaborator;
		private var _collabs		:Sprite = new Sprite();

		public function CollaboratorViewBS()
		{
			_collabs.y = 43; _line2.y = 17;
			addChild(_collabs); addChild(_line2);
			addEventListener(UIEvent.RADIO_SELECTED, onRadioSelected);
			addEventListener(UIEvent.KILL_COLLABORATOR, onKillCollaborator);							
		}

		override protected function onAddedToStage(e:Event):void
		{
			while(_collabs.numChildren) _collabs.removeChildAt(0);
			_pool = super.account.collaborators;
			forceOwnerToTopOfList();
			var n:uint = _pool.length <= 8 ? _pool.length : 8;
			for (var i:int = 0; i < n; i++) {
				var k:CollaboratorItemBS = new CollaboratorItemBS(_pool[i], super.account.repository.id);
					k.y = i * 41;
				_collabs.addChild(k);
			}
			writeBSText();
		}
		
		private function forceOwnerToTopOfList():void
		{
			for (var i:int = 0; i < _pool.length; i++) if (_pool[i].owner == true) break;
			_pool.unshift(_pool[i]); _pool.splice(i+1, 1);			
		}
		
		private function writeBSText():void
		{
			var n:uint = 0;
			for (var i:int = 0; i < _collabs.numChildren; i++) {
				var k:CollaboratorItemBS = _collabs.getChildAt(i) as CollaboratorItemBS;
				if (k.hasWriteAccess()) n++;
			}
			var s:String;
			if (n == 1){
				s = 'Looks like you\'re the only one with write access';
			}	else if (n == 2){
				s = 'You have one other collaborator who has write access';
			}	else{
				s = 'You are collaboraring with '+(n-1)+' others who have write access';
			}
			_line2.text = s;
		}
		
		private function onRadioSelected(e:UIEvent):void
		{
			writeBSText();
		}
		
		private function onKillCollaborator(e:UIEvent):void
		{
			_item = e.target as Sprite;
			_collab = e.data as Collaborator;
			var m:String = 'You are about to remove "'+_collab.firstName+' '+_collab.lastName+'" from your Beanstalk account. ';
				m+='In addition to removing them from your account this action will also disconnect from all repositories they previously had access to. ';
				m+='Would you like to continue?';
			var k:Confirm = new Confirm(m);
				k.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, k));			
		}

		private function onConfirm(e:UIEvent):void
		{
			if (e.data as Boolean == true) {
				super.proxy.killCollaborator(_collab);
				AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorRemoved);
			}
		}

		private function onCollaboratorRemoved(e:AppEvent):void
		{
			TweenLite.to(_item, .5, {alpha:0, onComplete:collapseLayout});
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorRemoved);
		}
		
		private function collapseLayout():void
		{
			var n:uint = _collabs.getChildIndex(_item); _collabs.removeChild(_item);
			for (var i:int = n; i < _collabs.numChildren; i++) {
				TweenLite.to(_collabs.getChildAt(i), .3, {y:i * 41});
			}
			writeBSText();
		}								
		
	}
	
}
