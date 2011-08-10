package model.db {
	import events.DataBaseEvent;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTransactionLockType;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class SQLLiteDataBase extends EventDispatcher{
		
		private var _conn				:SQLConnection;
		private var _debug				:Boolean = false;
		private var _queue				:Vector.<SQLStatement>;
		private var _results			:Vector.<SQLResult>;
		private var _commitOnComplete	:Boolean = false;

		public function SQLLiteDataBase($file:String)
		{
			_conn = new SQLConnection();
			_conn.addEventListener(SQLEvent.OPEN, onDatabaseOpen);
			_conn.addEventListener(SQLEvent.CLOSE, onDatabaseClose);
			_conn.addEventListener(SQLErrorEvent.ERROR, onDatabaseError);
			_conn.openAsync(File.applicationStorageDirectory.resolvePath($file));	
		}
				
		protected function execute(v:Vector.<SQLStatement>, $commit:Boolean = false):void 
		{
			_queue = v;
			_results = new Vector.<SQLResult>();
			_commitOnComplete = $commit;
			for (var i : int = 0; i < v.length; i++) {
				v[i].sqlConnection = _conn;
				v[i].addEventListener(SQLEvent.RESULT, onSQLResult);
            	v[i].addEventListener(SQLErrorEvent.ERROR, onDatabaseError);			
			}
			_conn.begin(SQLTransactionLockType.EXCLUSIVE);			
		}		

//	private methods		

		private function onSQLResult(e:SQLEvent = null):void 
		{
			if (e) _results.push(e.target.getResult());
			_queue.shift();
			if (_queue.length) {
				_queue[0].execute();
			}	else{
				if (_commitOnComplete){
					log("SQLLiteDataBase.commit()");
					_conn.commit();						
				}	else{
					log("SQLLiteDataBase.release()");
					_conn.rollback();					
				}
			}
		}
		
		private function onDatabaseOpen(e:SQLEvent):void 
		{
            _conn.removeEventListener(SQLEvent.OPEN, onDatabaseOpen);            _conn.addEventListener(SQLEvent.BEGIN, transactionStart);            _conn.addEventListener(SQLEvent.COMMIT, transactionComplete);            _conn.addEventListener(SQLEvent.ROLLBACK, transactionComplete);
			dispatchEvent(new DataBaseEvent(DataBaseEvent.DATABASE_OPENED));
		}

		private function transactionStart(e:SQLEvent):void 		{
			_queue[0].execute();
			log("SQLLiteDataBase.transactionStart(e)", _conn.inTransaction);		}
		
		private function transactionComplete(e:SQLEvent):void 
		{
			log("SQLLiteDataBase.transactionComplete(e)", _conn.inTransaction);
			dispatchEvent(new DataBaseEvent(DataBaseEvent.TRANSACTION_COMPLETE, {transaction:_queue, result:_results}));
			log('--------------------------------------');
		}

		private function onDatabaseError(e:SQLErrorEvent):void 
		{
			log("SQLLiteDataBase.onDatabaseError(e)");
		    log("Error Message:", e.error.message);
    		log("Error Details:", e.error.details);
    		onSQLResult();
		}

		private function onDatabaseClose(e:SQLEvent):void 
		{
			log("SQLLiteDataBase.onDatabaseClose(e)");
		}
		
		public function printResults($data:Array):void
		{
			for (var i:int = 0; i < $data.length; i++)
    		{
        		var row:Object = $data[i];
				for (var j : String in row) log('field: '+j,'=',row[j]);
   		 	}			
		}
		
		private function log(...args):void
		{
			if (_debug) trace(args);	
		}
		
	}
	
}
