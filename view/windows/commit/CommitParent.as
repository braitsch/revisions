package view.windows.commit {

	import events.UIEvent;
	import model.vo.Commit;
	import view.Box;
	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.type.TextDouble;
	import view.windows.base.ParentWindow;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CommitParent extends ParentWindow {

		private static var _mask		:Shape = new Shape();
		private static var _view		:Sprite = new Sprite();		
		private static var _text		:TextDouble = new TextDouble();
		private static var _summary		:Sprite = new Sprite();
		private static var _branch		:CommitBranch = new CommitBranch();
		private static var _options		:CommitOptions = new CommitOptions();
		private static var _tweening	:Boolean;

		public function CommitParent()
		{
			drawMask(554, 300);
			attachSummary();
			super.addCloseButton();	
			super.drawBackground(554, 300);
			addEventListener(UIEvent.WIZARD_NEXT, onWizardNext);
			addEventListener(UIEvent.WIZARD_PREV, onWizardPrev);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onWizardNext(e:UIEvent):void
		{
			super.title = 'Create Branch';
			if (_tweening) return; _tweening = true;
			TweenLite.to(_options, .5, {x:-this.width, onComplete:function():void{
				_view.removeChild(_options); _tweening = false; }});	
			_view.addChild(_branch); _branch.x = this.width; TweenLite.to(_branch, .5, {x:0});
		}		
		
		private function onWizardPrev(e:UIEvent):void
		{
			super.title = 'Version Options';
			if (_tweening) return; _tweening = true;
			TweenLite.to(_branch, .5, {x:this.width, onComplete:function():void{
				_view.removeChild(_branch); _tweening = false; }});	
			_view.addChild(_options); _options.x = -this.width; TweenLite.to(_options, .5, {x:0});
		}		

		public function set commit(o:Commit):void
		{
			attachAvatar(o);
			_text.line1 = o.note;
			_text.line2 = 'Saved '+o.date;
			_text.maxWidth = 300;
			_branch.commit = _options.commit = o;
		}		

		private function attachSummary():void
		{
			_text.x = 47; _text.y = 9;
			var w:Shape = new Shape();
				w.graphics.beginBitmapFill(new PageBadgeWhite());
				w.graphics.drawRect(0, 0, 378, 50);
				w.graphics.endFill();
			_summary.addChild(w);
			_summary.addChild(_text);
			_summary.x = 166;
			addChild(_summary);
		}
		
		private function attachAvatar(o:Commit):void
		{
			if (_summary.numChildren == 3) _summary.removeChildAt(2);
			var a:Avatar = Avatars.getAvatar(o.email);
				a.drawBackground(Box.LT_GREY, 2);
				a.x = a.y = 8;
			_summary.addChild(a);			
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			super.title = 'Version Options';
			_options.x = 0; _view.addChild(_options);
		}

		private function onRemovedFromStage(e:Event):void
		{
			if (_branch.stage) _view.removeChild(_branch);
			if (_options.stage) _view.removeChild(_options);
		}			
		
		private function drawMask(w:uint, h:uint):void
		{
			_mask.x = 0;
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(4, 0, w-8, h-4);
			_mask.graphics.endFill();
			_view.mask = _mask;
			addChild(_view);
			addChild(_mask);
		}	
		
	}
	
}
