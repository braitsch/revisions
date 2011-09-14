package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.remote.Hosts;
	import model.vo.Repository;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class CollaboratorView extends AccountView {

		private var _text			:TextLinkMC = new TextLinkMC();
		private var _item			:CollaboratorItem; // item queued for removal //
		private var _view			:CollaboratorViewMC = new CollaboratorViewMC();
		private var _collabs		:Sprite = new Sprite();
		private var _repository		:Repository;
		private var _backBtn		:BackButton = new BackButton();		

		public function CollaboratorView()
		{
			addChild(_view);
			addChild(_text);
			addChild(_collabs);
			addBackButton();
			_collabs.x = 5; _collabs.y = 43;
			_text.x = 10; _text.y = 17;
			_text.buttonMode = true;
			_text.grey.autoSize = TextFieldAutoSize.LEFT;
			_text.blue.autoSize = TextFieldAutoSize.LEFT;
			_text.addEventListener(MouseEvent.CLICK, onAddCollaborator);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UIEvent.KILL_COLLABORATOR, onKillCollaborator);
		}

		public function set repository(r:Repository):void
		{
			_repository	= r;
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			drawText();
			attachCollaborators();
		}		

		private function attachCollaborators():void
		{
			while(_collabs.numChildren) _collabs.removeChildAt(0);
			var n:uint = _repository.collaborators.length <= 12 ? _repository.collaborators.length : 12; 
			for (var i:int = 0; i < n; i++) {
				var k:CollaboratorItem = new CollaboratorItem(_repository.collaborators[i]);
					k.x = 190 * (i % 3);
					k.y = Math.floor(i/3) * 57;
				_collabs.addChild(k);
			}
		}

		private function drawText():void
		{
			var n:uint = _repository.collaborators.length;
			var s:String = n > 1 ? 's' : '';
			_view.main_txt.text = 'Collaborators on '+_repository.repoName;
			_text.grey.text = 'You currently have '+n+' collaborator'+s+' on this repository.';
			_text.blue.text = 'Why not add another?';
			_text.blue.x = _text.grey.x + _text.grey.width;			
		}
		
		private function onAddCollaborator(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ADD_COLLABORATOR, _repository));
		}	
		
		private function onKillCollaborator(e:UIEvent):void
		{
			_item = e.target as CollaboratorItem;
			Hosts.github.api.killCollaborator(_repository, _item.collaborator);
			Hosts.github.api.addEventListener(AppEvent.COLLABORATOR_REMOVED, onCollaboratorRemoved);
		}

		private function onCollaboratorRemoved(e:AppEvent = null):void
		{
			TweenLite.to(_item, .5, {alpha:0, onComplete:function():void{
				var n:uint = _collabs.getChildIndex(_item);
				_collabs.removeChild(_item); collapseLayout(n);
				_repository.killCollaborator(_item.collaborator);
			}});
			Hosts.github.api.removeEventListener(AppEvent.COLLABORATOR_REMOVED, onCollaboratorRemoved);
		}
		
		private function collapseLayout(n:uint):void
		{
			drawText();
			for (var i:int = n; i < _collabs.numChildren; i++) {
				var k:CollaboratorItem = _collabs.getChildAt(i) as CollaboratorItem;
				if (k.x != 0){
					TweenLite.to(k, .3, {x:'-190'}); 
				}	else{
					TweenLite.to(k, .3, {x:-190, onComplete:moveUpOnLevel, onCompleteParams:[k]});
				}
			}			
		}
		
		private function moveUpOnLevel(k:CollaboratorItem):void
		{
			k.y -= 57; k.x = 600; TweenLite.to(k, .3, {x:380});
		}
		
		private function addBackButton():void
		{
			_backBtn.x = 516; _backBtn.y = 312; addChild(_backBtn); 
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);	
			super.addButtons([_backBtn]);
		}
		
		private function onBackBtnClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}
			
	}
	
}
