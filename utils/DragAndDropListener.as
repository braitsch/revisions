package utils{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;

	public class DragAndDropListener extends Sprite {

		private var _file	:File;
		private var _target	:InteractiveObject;

		public function set target($do:InteractiveObject):void 
		{
			_target = $do;
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onNativeDragEnter);
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onNativeDragDrop);
		}
		
		public function get file():File
		{
			return _file;
		}

		private function onNativeDragEnter(e:NativeDragEvent):void 
		{
			if(e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)){
				NativeDragManager.acceptDragDrop(_target); 		
			}
		}		
		
		private function onNativeDragDrop(e:NativeDragEvent):void 
		{
			NativeDragManager.dropAction = NativeDragActions.COPY;
			var a:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
		// support for only one file for now //	
			_file = a[0];
			dispatchEvent(new NativeDragEvent(NativeDragEvent.NATIVE_DRAG_COMPLETE));
		}

//		private function getFileContents($f:File):String 
//		{
//			var stream:FileStream = new FileStream();
//				stream.open($f, FileMode.READ);
//			var data:String = stream.readUTFBytes(stream.bytesAvailable);
//				stream.close();
//			return data;
//		}
		
	}
	
}
