package model.db {

	import events.DataBaseEvent;
	import model.vo.Bookmark;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;

	public class AppDatabase extends EventDispatcher {
	
		private static var _db					:SQLLiteDataBase;
		private static var _open				:Vector.<SQLStatement>;		private static var _add					:Vector.<SQLStatement>;
		private static var _edit				:Vector.<SQLStatement>;		private static var _delete				:Vector.<SQLStatement>;		private static var _setActive			:Vector.<SQLStatement>;
		private static var _bookmarks			:Array;
		
		public function AppDatabase()
		{
			_db = new SQLLiteDataBase('Revisions.db');
			_db.addEventListener(DataBaseEvent.DATABASE_READY, onDataBaseReady);			_db.addEventListener(DataBaseEvent.TRANSACTION_COMPLETE, onTransactionComplete);
		}

		private function onDataBaseReady(e:DataBaseEvent):void 
		{
			dispatchEvent(new DataBaseEvent(DataBaseEvent.DATABASE_READY));
		}

		// public methods //

		public function init():void 
		{
			_open = new Vector.<SQLStatement>();	
			_open.push(AppSQLQuery.INIT_DATABASE);	
			_open.push(AppSQLQuery.READ_REPOSITORIES);
			_db.execute(_open, true);
		}

		public function addRepository(bkmk:Bookmark):void
		{
			_add = new Vector.<SQLStatement>();
			_add.push(AppSQLQuery.CLEAR_ACTIVE);				_add.push(AppSQLQuery.INSERT(bkmk));
			_add.push(AppSQLQuery.READ_REPOSITORIES);
			_db.execute(_add, true);	
		}
		
		public function deleteRepository($label:String):void
		{
			var n:String = getNextActiveRepository($label);
			_delete = new Vector.<SQLStatement>();	
			_delete.push(AppSQLQuery.DELETE($label));									_delete.push(AppSQLQuery.SET_ACTIVE(n));
			_delete.push(AppSQLQuery.READ_REPOSITORIES);
			_db.execute(_delete, true);
		}	

		public function editRepository($oldId:String, $newId:String, $path:String, $autosave:uint):void 
		{
			_edit = new Vector.<SQLStatement>();	
			_edit.push(AppSQLQuery.EDIT($oldId, $newId, $path, $autosave));						
			_edit.push(AppSQLQuery.READ_REPOSITORIES);
			_db.execute(_edit, true);			
		}		
		
		public function setActiveBookmark(label:String):void
		{
			_setActive = new Vector.<SQLStatement>();
			_setActive.push(AppSQLQuery.CLEAR_ACTIVE);				_setActive.push(AppSQLQuery.SET_ACTIVE(label));	
			_db.execute(_setActive, true);	
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
					trace("AppDatabase.onTransactionComplete(e) : initDataBase", e.data.result);
					_bookmarks = e.data.result[1].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.BOOKMARKS_READ, _bookmarks));
				break;				case _add:	
					trace("AppDatabase.onTransactionComplete(e) : addRepository");					_bookmarks = e.data.result[2].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_ADDED, _bookmarks));
				break;				case _edit:						trace("AppDatabase.onTransactionComplete(e) : editRepository");
					_bookmarks = e.data.result[1].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_EDITED, _bookmarks));
				break;				
				case _delete:	
					_bookmarks = e.data.result[2].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_DELETED, _bookmarks));
					trace("AppDatabase.onTransactionComplete(e) : deleteRepository");
				break;	
				case _setActive:	
				//	trace("AppDatabase.onTransactionComplete(e) : setActiveBookmark");
				break;					
			}
		}
		
	}
	
}
