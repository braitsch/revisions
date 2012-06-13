package view.windows.account.github {

	import com.greensock.TweenLite;
	import events.AppEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import model.AppModel;
	import model.vo.Collaborator;
	import view.type.TextHeading;
	import view.windows.account.base.CollaboratorView;
	public class GHCollabView extends CollaboratorView {

		private var _item			:Sprite;
		private var _line2			:TextHeading = new TextHeading();		
		private var _pool			:Vector.<Collaborator>;
		private var _collabs		:Sprite = new Sprite();

		public function GHCollabView()
		{
			_collabs.y = 43;
			addChild(_collabs);
			_line2.y = 17;
			addChild(_line2);
			addEventListener(UIEvent.KILL_COLLABORATOR, onKillCollaborator);			
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			while(_collabs.numChildren) _collabs.removeChildAt(0);
			_pool = super.account.repository.collaborators;
			var n:uint = _pool.length <= 15 ? _pool.length : 15;
			for (var i:int = 0; i < n; i++) {
				var k:GHCollabItem = new GHCollabItem(_pool[i]);
					k.x = 199.5 * (i % 3);
					k.y = Math.floor(i/3) * 57;
				_collabs.addChild(k);
			}
			writeGHText();			
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
				var k:Sprite = _collabs.getChildAt(i) as Sprite;
				if (k.x != 0){
					TweenLite.to(k, .3, {x:'-199.5'}); 
				}	else{
					TweenLite.to(k, .3, {x:-199.5, onComplete:moveUpOnLevel, onCompleteParams:[k]});
				}
			}			
			writeGHText();
		}
		
		private function moveUpOnLevel(k:Sprite):void
		{
			k.y -= 57; k.x = 600; TweenLite.to(k, .3, {x:399});
		}
		
		private function writeGHText():void
		{
			var n:uint = super.account.repository.collaborators.length;
			var s:String = n > 1 ? 's' : '';
			_line2.text = 'You currently have '+n+' collaborator'+s+' on this repository.';
		}
		
	}
	
}
