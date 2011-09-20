package view.modals.account {


	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Collaborator;
	import view.ui.TextHeading;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	public class CollaboratorViewBS extends AccountView {
	
		private var _item			:Sprite;
		private var _line2			:TextHeading = new TextHeading();		
		private var _pool			:Vector.<Collaborator>;
		private var _collabs		:Sprite = new Sprite();

		public function CollaboratorViewBS()
		{
			_collabs.y = 43; _line2.y = 17;
			addChild(_collabs); addChild(_line2);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
			super.proxy.killCollaborator(e.data as Collaborator);
			AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorRemoved);
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
