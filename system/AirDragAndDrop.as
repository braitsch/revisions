package system {

	import events.UIEvent;
	import model.AppModel;
	import view.windows.modals.system.Message;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.NativeDragEvent;

	public class AirDragAndDrop extends Sprite {

		private var _target	:InteractiveObject;

		public function set target($do:InteractiveObject):void 
		{
			_target = $do;
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onNativeDragEnter);
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onNativeDragDrop);
		}
		
		private function onNativeDragEnter(e:NativeDragEvent):void 
		{
			if (e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)){
				NativeDragManager.acceptDragDrop(_target); 		
			}
		}		
		
		private function onNativeDragDrop(e:NativeDragEvent):void 
		{
			if (AppModel.proxies.status.locked) return;
			NativeApplication.nativeApplication.activate();			
			NativeDragManager.dropAction = NativeDragActions.COPY;
			var a:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (a.length == 1){
				_target.dispatchEvent(new UIEvent(UIEvent.DRAG_AND_DROP, a[0]));
			}	else{
				AppModel.alert(new Message('Please add only one file at a time.'));
			}
		}

	}
	
}
