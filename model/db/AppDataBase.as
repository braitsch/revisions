package model.db {

	import events.DataBaseEvent;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;

	public class AppDatabase extends EventDispatcher {
	
		private static var _db					:SQLLiteDataBase;
		private static var _open				:Vector.<SQLStatement>;		private static var _add					:Vector.<SQLStatement>;
		private static var _edit				:Vector.<SQLStatement>;		private static var _delete				:Vector.<SQLStatement>;		private static var _setActive			:Vector.<SQLStatement>;
		private static var _repositories		:Array;
		
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

		public function addRepository($label:String, $target:String):void
		{
			trace("AppDatabase.addRepository > ", $label, $target);
			_add = new Vector.<SQLStatement>();
			_add.push(AppSQLQuery.CLEAR_ACTIVE);				_add.push(AppSQLQuery.INSERT($label, $target));	
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

		public function editRepository($oldId:String, $newId:String, $target:String):void 
		{
			_edit = new Vector.<SQLStatement>();	
			_edit.push(AppSQLQuery.EDIT($oldId, $newId, $target));						
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
			if (_repositories.length == 1) return '';
			for (var i:int = 0; i < _repositories.length; i++) if (_repositories[i].label == $old) break;
			if (i == _repositories.length - 1) {
				i --;
			}	else if (i == 0){
				i = 1;
			}	else{
				i ++;			}
			return _repositories[i].label;
		}		

		private function onTransactionComplete(e:DataBaseEvent):void 
		{
			switch(e.data.transaction as Vector.<SQLStatement>){
				case _open:	
					trace("AppDatabase.onTransactionComplete(e) : initDataBase", e.data.result);
					_repositories = e.data.result[1].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.BOOKMARKS_READ, _repositories));
				break;				case _add:	
					trace("AppDatabase.onTransactionComplete(e) : addRepository");					_repositories = e.data.result[2].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_ADDED, _repositories));
				break;				case _edit:						trace("AppDatabase.onTransactionComplete(e) : editRepository");
					_repositories = e.data.result[1].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_EDITED, _repositories));
				break;				
				case _delete:	
					_repositories = e.data.result[2].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_DELETED, _repositories));
					trace("AppDatabase.onTransactionComplete(e) : deleteRepository");
				break;	
				case _setActive:	
				//	trace("AppDatabase.onTransactionComplete(e) : setActiveBookmark");
				break;					
			}
		}
		
	}
	
}
