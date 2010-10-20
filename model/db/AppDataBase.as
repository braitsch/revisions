package model.db {
	import events.DataBaseEvent;

	import view.bookmarks.Bookmark;

	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;

	public class AppDatabase extends EventDispatcher {
	
		private static var _db					:SQLLiteDataBase;
		private static var _init				:Vector.<SQLStatement>;		private static var _add					:Vector.<SQLStatement>;
		private static var _edit				:Vector.<SQLStatement>;		private static var _delete				:Vector.<SQLStatement>;		private static var _setActive			:Vector.<SQLStatement>;
		private static var _ready				:Boolean = false;
		private static var _repositories		:Array;
		
		public function AppDatabase()
		{
			_db = new SQLLiteDataBase('GitMe.db');
			_db.addEventListener(DataBaseEvent.DATABASE_READY, onDataBaseReady);			_db.addEventListener(DataBaseEvent.TRANSACTION_COMPLETE, onTransactionComplete);
		}

		public function set bookmark(b:Bookmark):void 
		{
			setActiveBookmark(b.label);
		}		

		private function onDataBaseReady(e:DataBaseEvent):void 
		{
			_ready = true;
		}

		// public methods //

		public function init():void 
		{
			if (_ready){
				_init = new Vector.<SQLStatement>();	
				_init.push(AppSQLQuery.INIT_DATABASE);	
				_init.push(AppSQLQuery.READ_REPOSITORIES);	
				_db.execute(_init, true);
			}	else{
				trace('ERROR - DataBase Not Yet Initialized');
			}
		}

		public function addRepository($label:String, $local:String):void
		{
			trace("AppDatabase.addRepository > ", $label, $local);
			_add = new Vector.<SQLStatement>();
			_add.push(AppSQLQuery.CLEAR_ACTIVE);				_add.push(AppSQLQuery.INSERT($label, $local));	
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

		public function editRepository($oldId:String, $newId:String, $local:String):void 
		{
			_edit = new Vector.<SQLStatement>();	
			_edit.push(AppSQLQuery.EDIT($oldId, $newId, $local));						
			_edit.push(AppSQLQuery.READ_REPOSITORIES);
			_db.execute(_edit, true);			
		}		
		
		private function setActiveBookmark(label:String):void
		{
			_setActive = new Vector.<SQLStatement>();
			_setActive.push(AppSQLQuery.CLEAR_ACTIVE);				_setActive.push(AppSQLQuery.SET_ACTIVE(label));	
			_db.execute(_setActive, true);	
		}			
			//	private methods //	
		
		private function getNextActiveRepository($old:String):String 
		{
			if (_repositories.length == 1) return '';
			for (var i:int = 0; i < _repositories.length; i++) if (_repositories[i].name == $old) break;
			if (i == _repositories.length - 1) {
				i --;
			}	else if (i == 0){
				i = 1;
			}	else{
				i ++;			}
			return _repositories[i].name;
		}		

		private function onTransactionComplete(e:DataBaseEvent):void 
		{
			switch(e.data.transaction as Vector.<SQLStatement>){
				case _init:	
					trace("AppDatabase.onTransactionComplete(e) : initDataBase", e.data.result);
					_repositories = e.data.result[1].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.BOOKMARKS_READ, _repositories));
				break;				case _add:	
					trace("AppDatabase.onTransactionComplete(e) : addRepository");					_repositories = e.data.result[2].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.BOOKMARK_ADDED, _repositories));
				break;				case _edit:						trace("AppDatabase.onTransactionComplete(e) : editRepository");
					_repositories = e.data.result[1].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.BOOKMARK_EDITED, _repositories));
				break;				
				case _delete:	
					_repositories = e.data.result[2].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.BOOKMARK_DELETED, _repositories));
					trace("AppDatabase.onTransactionComplete(e) : deleteRepository");
				break;	
				case _setActive:	
				//	trace("AppDatabase.onTransactionComplete(e) : setActiveBookmark");
				break;					
			}
		}
		
	}
	
}
