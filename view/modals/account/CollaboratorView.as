package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.vo.Collaborator;
	import view.ui.TextHeading;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CollaboratorView extends AccountView {

		private var _item			:Sprite;
		private var _view			:CollaboratorViewMC = new CollaboratorViewMC();
		private var _line1			:TextHeading = new TextHeading();
		private var _line2			:TextHeading = new TextHeading();		
		private var _pool			:Vector.<Collaborator>;
		private var _collabs		:Sprite = new Sprite();

		public function CollaboratorView()
		{
			_collabs.y = 43;
			addChild(_view);
			addChild(_collabs);
			registerButtons();
			addTextHeadings();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UIEvent.RADIO_SELECTED, onRadioSelected);
			addEventListener(UIEvent.KILL_COLLABORATOR, onKillCollaborator);
		}

		override protected function onAddedToStage(e:Event):void
		{
			attachCollaborators();
		}		

		private function attachCollaborators():void
		{
			while(_collabs.numChildren) _collabs.removeChildAt(0);
			if (super.account.type == HostingAccount.GITHUB){
				attachGHCollabs();		
			}	else if (super.account.type == HostingAccount.BEANSTALK){
				attachBSCollabs();
			}
		}
		
		private function attachGHCollabs():void
		{
			_pool = super.account.repository.collaborators;
			var n:uint = _pool.length <= 15 ? _pool.length : 15;
			for (var i:int = 0; i < n; i++) {
				var k:CollaboratorGH = new CollaboratorGH(_pool[i]);
					k.x = 199.5 * (i % 3);
					k.y = Math.floor(i/3) * 57;
				_collabs.addChild(k);
			}
			writeGHText();			
		}
		
		private function attachBSCollabs():void
		{
			_pool = super.account.collaborators;
			var n:uint = _pool.length <= 15 ? _pool.length : 15;
		// force account owner to the top of the list //
			for (var m:int = 0; m < _pool.length; m++) if (_pool[m].owner == true) break;
			_pool.unshift(_pool[m]); _pool.splice(m+1, 1);
			for (var i:int = 0; i < n; i++) {
				var k:CollaboratorBS = new CollaboratorBS(_pool[i], super.account.repository.id);
					k.y = i * 41;
				_collabs.addChild(k);
			}
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
		
		private function onRadioSelected(e:UIEvent):void
		{
			writeBSText();
		}
		
		private function writeGHText():void
		{
			var s:String = _pool.length > 1 ? 's' : '';
			_line2.text = 'You currently have '+_pool.length+' collaborator'+s+' on this repository.';
		}
		
		private function writeBSText():void
		{
			var n:uint = 0;
			for (var i:int = 0; i < _collabs.numChildren; i++) {
				var k:CollaboratorBS = _collabs.getChildAt(i) as CollaboratorBS;
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
