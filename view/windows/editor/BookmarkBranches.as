package view.windows.editor {

	import com.greensock.TweenLite;
	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import model.AppModel;
	import system.StringUtils;
	import view.ui.TextHeading;
	import view.windows.base.ChildWindow;
	import view.windows.modals.system.Merge;

	public class BookmarkBranches extends ChildWindow {

		private static var _mask		:Shape = new Shape();
		private static var _merge		:Merge = new Merge();
		private static var _heading		:TextHeading = new TextHeading();
		private static var _branchName	:TextHeading = new TextHeading();
		private static var _branches	:Sprite = new Sprite();
		private static var _bitmap		:Bitmap;
		private static var _dragTarget	:BranchItem;
		private static var _mergeTarget	:BranchItem;
		private static var _mouseDownX	:Number;
		private static var _mouseDownY	:Number;
		
		public function BookmarkBranches()
		{
			setupTexts();
			addEventListeners();
			setupBranchesAndMask();
		}

		private function addEventListeners():void
		{
			_merge.addEventListener(UIEvent.CONFIRM, onConfirm);
			_branches.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RECEIVED, onBranchChanged);
			AppModel.proxies.editor.addEventListener(AppEvent.BRANCH_RENAMED, onBranchRenamed);
		}

		private function setupTexts():void
		{
			_heading.text = 'These are your branches, you are currently on branch ';
			_branchName.color = 0x333333;
			_branchName.x = _heading.x + _heading.width;
			addChild(_heading);
			addChild(_branchName);
		}

		private function setupBranchesAndMask():void
		{
			_mask.x = _branches.x = 10;
			_mask.y = _branches.y = 100;
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(-2, 0, 584, 262);
			_mask.graphics.endFill();
			_branches.mask = _mask;			
			addChild(_branches);			
			addChild(_mask);
		}

		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			_branchName.text = StringUtils.capitalize(AppModel.bookmark.branch.name);
			while(_branches.numChildren) _branches.removeChildAt(0);
			for (var i:int = 0; i < AppModel.bookmark.branches.length; i++) _branches.addChild(new BranchItem(AppModel.bookmark.branches[i]));
			layoutBranches(0);
		}
		
		private function layoutBranches(n:Number):void
		{
			for (var i:int = 0; i < _branches.numChildren; i++) {
				var b:BranchItem = _branches.getChildAt(i) as BranchItem;
				TweenLite.to(b, n, {y:44 * i});
			}
		}
		
		private function onBranchChanged(e:AppEvent):void
		{
			for (var i:int = 0; i < _branches.numChildren; i++) {
				var b:BranchItem = _branches.getChildAt(i) as BranchItem;
				if (b.branch == AppModel.branch) {
					TweenLite.to(b, .3, {alpha:0, onComplete:switchPosition, onCompleteParams:[b]});
				}
			}
			_branchName.text = StringUtils.capitalize(AppModel.branch.name);
		}
		
		private function onBranchRenamed(e:AppEvent):void
		{
			_branchName.text = StringUtils.capitalize(AppModel.branch.name);
		}				
		
		private function switchPosition(k:BranchItem):void
		{
			_branches.setChildIndex(k, 0); k.y = 0;
			layoutBranches(.3);
			TweenLite.to(k, .3, {alpha:1, delay:.2});
		}
		
	// drag interactions //	
		
		private function onMouseDown(e:MouseEvent):void
		{
			return;
			var k:DisplayObjectContainer = e.target as DisplayObjectContainer;
			while ((k is BranchItem) == false) k = k.parent;
		//	if (BranchItem(k).isActiveBranch() == false){
				var p:Point = k.globalToLocal(new Point(e.stageX, e.stageY));
				_mouseDownX = p.x;
				_mouseDownY = p.y;
				drawBitmap(k as BranchItem);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		//	}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			_bitmap.x = mouseX - _mouseDownX;
			_bitmap.y = mouseY - _mouseDownY;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			inspectTarget(e.target as DisplayObject);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);	
			TweenLite.to(_bitmap, .3, {x:_dragTarget.x + _branches.x, y:_dragTarget.y + _branches.y, onComplete:killBitmap});
		}
		
		private function inspectTarget(k:DisplayObject):void
		{
			while (k.parent) {
				if (k.name == 'checkout') break;
				if (k is BranchItem){ promptToMerge(k as BranchItem); break; } 
				k = k.parent;
			}			
		}
		
		private function drawBitmap(k:BranchItem):void
		{
			_dragTarget = k;
			var bmd:BitmapData = new BitmapData(582, 42);
				bmd.draw(_dragTarget);
			_bitmap = new Bitmap(bmd);
			_bitmap.alpha =.8;
			_bitmap.x = mouseX - _mouseDownX;
			_bitmap.y = mouseY - _mouseDownY;			
			addChild(_bitmap);
		}
		
		private function killBitmap():void
		{
			removeChild(_bitmap); _bitmap = null;			
		}
		
	// merging //	
		
		private function promptToMerge(bi:BranchItem):void 
		{
			if (AppModel.branch.isModified){
				AppModel.alert('Please save your current changes before merging branches.');
			}	else if (bi != _dragTarget){
				_mergeTarget = bi;
				_merge.setBranches(_dragTarget.branch, _mergeTarget.branch);
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, _merge));
			}
		}

		private function onConfirm(e:UIEvent):void
		{
		//	trace("BookmarkBranches.onConfirm(e)", e.data);	
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
			var h:uint = _branches.height - 8; // offset padding on pngs //
			if (h <= _mask.height) return;
			_branches.y += e.delta;
		// 100 is the home yPos of the repos container sprite //
			var minY:int = 100 - h + _mask.height;
			if (_branches.y >= 100) {
				_branches.y = 100;
			}	else if (_branches.y < minY){
				_branches.y = minY;
			}
		}			
		
	}
	
}
