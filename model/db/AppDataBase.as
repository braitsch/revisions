package model.db {

	import model.remote.RemoteAccount;
	import events.DataBaseEvent;
	import model.vo.Bookmark;
	import flash.data.SQLStatement;

	public class AppDatabase extends SQLLiteDataBase {
	
		private static var _readDB				:Vector.<SQLStatement>;
				private static var _addBkmk				:Vector.<SQLStatement>;
		private static var _delBkmk				:Vector.<SQLStatement>;		private static var _editBkmk			:Vector.<SQLStatement>;		private static var _setActiveBkmk		:Vector.<SQLStatement>;
		
		private static var _addAccount			:Vector.<SQLStatement>;
		private static var _delAccount			:Vector.<SQLStatement>;
		private static var _editAccount			:Vector.<SQLStatement>;
		private static var _setSSHKeyId			:Vector.<SQLStatement>;
		
		private static var _bkmks				:Array;
		private static var _accts:Array;
		
		public function AppDatabase()
		{
			super('Revisions.db');
			super.addEventListener(DataBaseEvent.TRANSACTION_COMPLETE, onTransactionComplete);
		}

		// public methods //

		public function initialize():void 
		{
			_readDB = new Vector.<SQLStatement>();
			_readDB.push(AppSQLQuery.INIT_TABLE_BOOKMARKS);
			_readDB.push(AppSQLQuery.READ_BOOKMARKS);
			_readDB.push(AppSQLQuery.INIT_TABLE_ACCOUNTS);
			_readDB.push(AppSQLQuery.READ_ACCOUNTS);
			super.execute(_readDB, true);
		}

		public function addRepository(bkmk:Bookmark):void
		{
			_addBkmk = new Vector.<SQLStatement>();
			_addBkmk.push(AppSQLQuery.CLEAR_ACTIVE_BKMK);				_addBkmk.push(AppSQLQuery.ADD_BKMK(bkmk));
			_addBkmk.push(AppSQLQuery.READ_BOOKMARKS);
			super.execute(_addBkmk, true);	
		}
		
		public function deleteRepository($label:String):void
		{
			var n:String = getNextActiveRepository($label);
			_delBkmk = new Vector.<SQLStatement>();	
			_delBkmk.push(AppSQLQuery.DEL_BKMK($label));									_delBkmk.push(AppSQLQuery.SET_ACTIVE_BKMK(n));
			_delBkmk.push(AppSQLQuery.READ_BOOKMARKS);
			super.execute(_delBkmk, true);
		}	

		public function editRepository($oldId:String, $newId:String, $path:String, $autosave:uint):void 
		{
			_editBkmk = new Vector.<SQLStatement>();	
			_editBkmk.push(AppSQLQuery.EDIT_BKMK($oldId, $newId, $path, $autosave));						
			_editBkmk.push(AppSQLQuery.READ_BOOKMARKS);
			super.execute(_editBkmk, true);			
		}		
		
		public function setActiveBookmark(label:String):void
		{
			_setActiveBkmk = new Vector.<SQLStatement>();
			_setActiveBkmk.push(AppSQLQuery.CLEAR_ACTIVE_BKMK);				_setActiveBkmk.push(AppSQLQuery.SET_ACTIVE_BKMK(label));	
			super.execute(_setActiveBkmk, true);	
		}
		
	// accounts //	
		
		public function addAccount(a:RemoteAccount):void
		{
			_addAccount = new Vector.<SQLStatement>();
			_addAccount.push(AppSQLQuery.ADD_ACCOUNT(a));
			super.execute(_addAccount, true);
		}
		
		public function editAccount(a:RemoteAccount):void
		{
			trace("AppDatabase.editAccount(a)", a.sshKeyId);
			_editAccount = new Vector.<SQLStatement>();
			_editAccount.push(AppSQLQuery.EDIT_ACCOUNT(a));
			super.execute(_editAccount, true);						
		}
		
		public function deleteAccount(a:RemoteAccount):void
		{
			_delAccount = new Vector.<SQLStatement>();
			_delAccount.push(AppSQLQuery.DEL_ACCOUNT(a));
			super.execute(_delAccount, true);
		}	
		
		public function setSSHKeyId(a:RemoteAccount):void
		{
			_setSSHKeyId = new Vector.<SQLStatement>();
			_setSSHKeyId.push(AppSQLQuery.CLEAR_SSH_KEY_ID);
			_setSSHKeyId.push(AppSQLQuery.SET_SSH_KEY_ID(a));
			super.execute(_setSSHKeyId, true);
		}									
			//	private methods //	
		
		private function getNextActiveRepository($old:String):String 
		{
			if (_bkmks.length == 1) return '';
			for (var i:int = 0; i < _bkmks.length; i++) if (_bkmks[i].label == $old) break;
			if (i == _bkmks.length - 1) {
				i --;
			}	else if (i == 0){
				i = 1;
			}	else{
				i ++;			}
			return _bkmks[i].label;
		}		

		private function onTransactionComplete(e:DataBaseEvent):void 
		{
			switch(e.data.transaction as Vector.<SQLStatement>){
				case _readDB:	
					_bkmks = e.data.result[1].data || [];
					_accts =  e.data.result[3].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.DATABASE_READ, {bookmarks:_bkmks, accounts:_accts}));
				break;				case _addBkmk:	
					_bkmks = e.data.result[2].data || [];					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_ADDED, _bkmks));
				break;				case _editBkmk:						_bkmks = e.data.result[1].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_EDITED, _bkmks));
				break;				
				case _delBkmk:	
					_bkmks = e.data.result[2].data || [];
					dispatchEvent(new DataBaseEvent(DataBaseEvent.RECORD_DELETED, _bkmks));
				break;
				case _addAccount :
			//		trace("AppDatabase.onTransactionComplete(e) -- new account added!!");	
				break;	
				case _editAccount :
					trace("AppDatabase.onTransactionComplete(e) -- account edited !!");	
				break;						
				case _setSSHKeyId :
					trace("AppDatabase.onTransactionComplete(e) -- primary account set !!");	
				break;									
			}
		}

	}
	
}
