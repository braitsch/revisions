package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import view.ui.TextHeading;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CollaboratorView extends AccountView {

		private var _view			:CollaboratorViewMC = new CollaboratorViewMC();
		private var _item			:CollaboratorItem; // item queued for removal //
		private var _line1			:TextHeading = new TextHeading();
		private var _line2			:TextHeading = new TextHeading();		
		private var _collabs		:Sprite = new Sprite();

		public function CollaboratorView()
		{
			addChild(_view);
			addChild(_collabs);
			registerButtons();
			addTextHeadings();
			_collabs.y = 43;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UIEvent.KILL_COLLABORATOR, onKillCollaborator);
		}

		override protected function onAddedToStage(e:Event):void
		{
			drawText();
			attachCollaborators();
		}		

		private function attachCollaborators():void
		{
			while(_collabs.numChildren) _collabs.removeChildAt(0);
			var n:uint = super.repository.collaborators.length <= 15 ? super.repository.collaborators.length : 15;
			for (var i:int = 0; i < n; i++) {
				var k:CollaboratorItem = new CollaboratorItem(super.repository.collaborators[i]);
					k.x = 199.5 * (i % 3);
					k.y = Math.floor(i/3) * 57;
				_collabs.addChild(k);
			}
		}

		private function drawText():void
		{
			var n:uint = super.repository.collaborators.length;
			var s:String = n > 1 ? 's' : '';
			_line2.text = 'You currently have '+n+' collaborator'+s+' on this repository.';
		}
		
		private function onKillCollaborator(e:UIEvent):void
		{
			_item = e.target as CollaboratorItem;
			super.proxy.killCollaborator(super.repository, _item.collaborator);
			super.proxy.addEventListener(AppEvent.COLLABORATOR_REMOVED, onCollaboratorRemoved);
		}

		private function onCollaboratorRemoved(e:AppEvent = null):void
		{
			TweenLite.to(_item, .5, {alpha:0, onComplete:collapseLayout});
			super.proxy.removeEventListener(AppEvent.COLLABORATOR_REMOVED, onCollaboratorRemoved);
		}
		
		private function collapseLayout():void
		{
			var n:uint = _collabs.getChildIndex(_item); _collabs.removeChild(_item);
			for (var i:int = n; i < _collabs.numChildren; i++) {
				var k:CollaboratorItem = _collabs.getChildAt(i) as CollaboratorItem;
				if (k.x != 0){
					TweenLite.to(k, .3, {x:'-199.5'}); 
				}	else{
					TweenLite.to(k, .3, {x:-199.5, onComplete:moveUpOnLevel, onCompleteParams:[k]});
				}
			}			
			super.repository.killCollaborator(_item.collaborator); drawText();
		}
		
		private function moveUpOnLevel(k:CollaboratorItem):void
		{
			k.y -= 57; k.x = 600; TweenLite.to(k, .3, {x:399});
		}
		
		private function registerButtons():void
		{
			_view.back.addEventListener(MouseEvent.CLICK, onBackBtnClick);	
			_view.addCollab.addEventListener(MouseEvent.CLICK, onAddCollaborator);
			super.addButtons([_view.back, _view.addCollab]);
		}
		
		private function addTextHeadings():void
		{
			addChild(_line1);
			addChild(_line2);
			_line1.y = 0; _line2.y = 17;
			_line1.text = 'These are your collaborators.';
		}			
		
		private function onAddCollaborator(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
		}			
		
		private function onBackBtnClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}
			
	}
	
}
