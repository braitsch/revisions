package model.db {

	import events.DataBaseEvent;
	import model.vo.Bookmark;
	import flash.data.SQLStatement;

	public class AppDatabase extends SQLLiteDataBase {
	
		private static var _open				:Vector.<SQLStatement>;		private static var _add					:Vector.<SQLStatement>;
		private static var _edit				:Vector.<SQLStatement>;		private static var _delete				:Vector.<SQLStatement>;		private static var _setActive			:Vector.<SQLStatement>;
		private static var _bookmarks			:Array;
		
		public function AppDatabase()
		{
			super('Revisions.db');
			super.addEventListener(DataBaseEvent.TRANSACTION_COMPLETE, onTransactionComplete);
		}

		// public methods //

		public function initialize():void 
		{
			_open = new Vector.<SQLStatement>();
			_open.push(AppSQLQuery.INIT_TABLE_BOOKMARKS);
			_open.push(AppSQLQuery.READ_BOOKMARKS);
			_open.push(AppSQLQuery.INIT_TABLE_ACCOUNTS);
			_open.push(AppSQLQuery.READ_ACCOUNTS);
			super.execute(_open, true);
		}

		public function addRepository(bkmk:Bookmark):void
		{
			_add = new Vector.<SQLStatement>();
			_add.push(AppSQLQuery.CLEAR_ACTIVE);				_add.push(AppSQLQuery.INSERT(bkmk));
			_add.push(AppSQLQuery.READ_BOOKMARKS);
			super.execute(_add, true);	
		}
		
		public function deleteRepository($label:String):void
		{
			var n:String = getNextActiveRepository($label);
			_delete = new Vector.<SQLStatement>();	
			_delete.push(AppSQLQuery.DELETE($label));									_delete.push(AppSQLQuery.SET_ACTIVE(n));
			_delete.push(AppSQLQuery.READ_BOOKMARKS);
			super.execute(_delete, true);
		}	

		public function editRepository($oldId:String, $newId:String, $path:String, $autosave:uint):void 
		{
			_edit = new Vector.<SQLStatement>();	
			_edit.push(AppSQLQuery.EDIT($oldId, $newId, $path, $autosave));						
			_edit.push(AppSQLQuery.READ_BOOKMARKS);
			super.execute(_edit, true);			
		}		
		
		public function setActiveBookmark(label:String):void
		{
			_setActive = new Vector.<SQLStatement>();
			_setActive.push(AppSQLQuery.CLEAR_ACTIVE);				_setActive.push(AppSQLQuery.SET_ACTIVE(label));	
			super.execute(_setActive, true);	
		}			
			//	private methods //	
		
		private function getNextActiveRepository($old:String):String 
		{
			if (_bookmarks.length == 1) return '';
			for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i].label == $old) break;
			if (i == _bookmarks.length - 1) {
				i --;
			}	else if (i == 0){
				i = 1;
			}	else{
				i ++;			}
			return _bookmarks[i].label;
		}		

		private function onTransactionComplete(e:DataBaseEvent):void 
		{
			switch(e.data.transaction as Vector.<SQLStatement>){
				case _open:	
			//		trace("AppDatabase.onTransactionComplete(e) : initDataBase", e.data.result);
					_bookmarks = e.data.result[1].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.DATABASE_READ, _bookmarks));
				break;				case _add:	
			//		trace("AppDatabase.onTransactionComplete(e) : addRepository");					_bookmarks = e.data.result[2].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_ADDED, _bookmarks));
				break;				case _edit:				//		trace("AppDatabase.onTransactionComplete(e) : editRepository");
					_bookmarks = e.data.result[1].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_EDITED, _bookmarks));
				break;				
				case _delete:	
			//		trace("AppDatabase.onTransactionComplete(e) : deleteRepository");
					_bookmarks = e.data.result[2].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_DELETED, _bookmarks));
				break;	
				case _setActive:	
				//	trace("AppDatabase.onTransactionComplete(e) : setActiveBookmark");
				break;					
			}
		}
		
	}
	
}
