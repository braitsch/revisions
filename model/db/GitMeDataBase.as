package model.db {
	import events.DataBaseEvent;

	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;

	public class GitMeDataBase extends EventDispatcher {
	
		private static var _db					:SQLLiteDataBase;
		private static var _init				:Vector.<SQLStatement>;		private static var _add					:Vector.<SQLStatement>;
		private static var _edit				:Vector.<SQLStatement>;		private static var _delete				:Vector.<SQLStatement>;		private static var _setActive			:Vector.<SQLStatement>;
		private static var _ready				:Boolean = false;
		private static var _repositories		:Array;		
		public function GitMeDataBase()
		{
			_db = new SQLLiteDataBase('GitMe.db');
			_db.addEventListener(DataBaseEvent.DATABASE_READY, onDataBaseReady);			_db.addEventListener(DataBaseEvent.TRANSACTION_COMPLETE, onTransactionComplete);
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
				_init.push(GitMeSQLQuery.INIT_DATABASE);	
				_init.push(GitMeSQLQuery.READ_REPOSITORIES);	
				_db.execute(_init, true);
			}	else{
				trace('ERROR - DataBase Not Yet Initialized');
			}
		}

		public function addRepository($label:String, $local:String):void
		{
			_add = new Vector.<SQLStatement>();
			_add.push(GitMeSQLQuery.CLEAR_ACTIVE);				_add.push(GitMeSQLQuery.INSERT($label, $local));	
			_add.push(GitMeSQLQuery.READ_REPOSITORIES);
			_db.execute(_add, true);	
		}
		
		public function deleteRepository($label:String):void
		{
			var n:String = getNextActiveRepository($label);
			_delete = new Vector.<SQLStatement>();	
			_delete.push(GitMeSQLQuery.DELETE($label));									_delete.push(GitMeSQLQuery.SET_ACTIVE(n));
			_delete.push(GitMeSQLQuery.READ_REPOSITORIES);
			_db.execute(_delete, true);
		}	

		public function editRepository($oldId:String, $newId:String, $local:String):void 
		{
			_edit = new Vector.<SQLStatement>();	
			_edit.push(GitMeSQLQuery.EDIT($oldId, $newId, $local));						
			_edit.push(GitMeSQLQuery.READ_REPOSITORIES);
			_db.execute(_edit, true);			
		}		
		
		public function setActiveBookmark($label:String):void
		{
			_setActive = new Vector.<SQLStatement>();
			_setActive.push(GitMeSQLQuery.CLEAR_ACTIVE);				_setActive.push(GitMeSQLQuery.SET_ACTIVE($label));	
			_db.execute(_setActive, true);	
		}			
			//	private methods //	
		
		private function getNextActiveRepository($old:String):String 
		{
			if (_repositories.length==1) return '';
			for (var i : int = 0; i < _repositories.length; i++) if (_repositories[i].name==$old) break;
			if (i == 0) {
				return _repositories[1].name; 
			}	else{
				return _repositories[i-1].name;
			}
		}		

		private function onTransactionComplete(e:DataBaseEvent):void 
		{
			switch(e.data.transaction as Vector.<SQLStatement>){
				case _init:	
					trace("GitMeDataBase.onTransactionComplete(e) : initDataBase", e.data.result);
					_repositories = e.data.result[1].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.REPOSITORIES, _repositories));
				break;				case _add:	
					trace("GitMeDataBase.onTransactionComplete(e) : addRepository", e.data.result);
					_repositories = e.data.result[2].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.REPOSITORIES, _repositories));				break;
				case _edit:	
					trace("GitMeDataBase.onTransactionComplete(e) : editRepository", e.data.result);
					_repositories = e.data.result[1].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.REPOSITORIES, _repositories));
				break;				
				case _delete:	
					trace("GitMeDataBase.onTransactionComplete(e) : deleteRepository", e.data.result);
					_repositories = e.data.result[2].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.REPOSITORIES, _repositories));
				break;	
				case _setActive:	
					trace("GitMeDataBase.onTransactionComplete(e) : setActiveBookmark");
				break;					
			}
		}			

	}
}
