package view.history.switcher {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Branch;
	import view.graphics.GradientBox;
	import view.type.TextHeading;
	import view.windows.modals.system.Confirm;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	public class SwitcherOption extends SwitcherItem {

		private var _branch		:Branch;
		private var _text		:TextHeading = new TextHeading();
		private var _bkgd		:GradientBox = new GradientBox(true);
		private var _kill		:Sprite = new Sprite();
		private var _icon		:Bitmap = new Bitmap(new SwitcherItemLT());
		private var _tweening	:Boolean;
	
		public function SwitcherOption(b:Branch)
		{
			_branch	= b;
			_text = new TextHeading(_branch.name);
			_text.color = 0x555555;
			super(_bkgd, _icon, _text);
			addKillButton();
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		private function addKillButton():void
		{
			var b:SwitcherDelete = new SwitcherDelete();
			var c:ColorTransform = new ColorTransform();
				c.color = 0x999999;
			_kill.y = 16;			
			_kill.addChild(b);
			_kill.mouseChildren = false;
			_kill.transform.colorTransform = c;
			_kill.addEventListener(MouseEvent.ROLL_OVER, onKillOver);
			addChild(_kill);
		}

		private function onKillOver(e:MouseEvent):void
		{
			if (_tweening == false ) {
				_tweening = true;
				TweenLite.to(_kill, .3, {rotation:'90', onComplete:function():void{ _tweening = false; }});
			}
		}

		override public function draw(w:uint):void
		{
			super.draw(w);
			_kill.x = w - 17;
		}	
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (e.target == _kill){
				onDeleteBranch();
			}	else{
				onChangeBranch();
			}
		}

		private function onChangeBranch():void
		{
			if (AppModel.branch.isModified){
				AppModel.alert('Please save your changes before moving to a new branch.');					
			}	else{
				AppModel.proxies.editor.changeBranch(_branch);
			}			
		}
		
		private function onDeleteBranch():void
		{
			var k:Confirm = new Confirm('Delete branch "'+_branch.name+'"? Warning this cannot be undone.');
				k.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, k));			
		}		
		
		private function onConfirm(e:UIEvent):void
		{
			if (e.data as Boolean == true) {
				AppModel.proxies.editor.killBranch(_branch);
			}
		}		
		
	}
	
}
