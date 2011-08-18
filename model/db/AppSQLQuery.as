package model.db {

	import model.remote.Account;
	import model.vo.Bookmark;
	import flash.data.SQLStatement;

	public class AppSQLQuery {

		public static const INIT_TABLE_ACCOUNTS:SQLStatement = new SQLStatement();
		INIT_TABLE_ACCOUNTS.text = "CREATE TABLE IF NOT EXISTS accounts ";
		INIT_TABLE_ACCOUNTS.text+= "(id INTEGER PRIMARY KEY AUTOINCREMENT, ";
		INIT_TABLE_ACCOUNTS.text+= "type VARCHAR, user VARCHAR, pass VARCHAR, ";
		INIT_TABLE_ACCOUNTS.text+= "sshKeyId TINYINT UNSIGNED NOT NULL DEFAULT 0)";

		public static const INIT_TABLE_BOOKMARKS:SQLStatement = new SQLStatement();
		INIT_TABLE_BOOKMARKS.text = "CREATE TABLE IF NOT EXISTS bookmarks ";
		INIT_TABLE_BOOKMARKS.text+= "(id INTEGER PRIMARY KEY AUTOINCREMENT, ";
		INIT_TABLE_BOOKMARKS.text+= "label VARCHAR, type VARCHAR, path VARCHAR, ";
		INIT_TABLE_BOOKMARKS.text+= "active TINYINT UNSIGNED NOT NULL DEFAULT 0, ";
		INIT_TABLE_BOOKMARKS.text+= "autosave TINYINT UNSIGNED NOT NULL DEFAULT 60)";
		
		public static const READ_ACCOUNTS:SQLStatement = new SQLStatement();
		READ_ACCOUNTS.text = "SELECT * FROM accounts";

		public static const READ_BOOKMARKS:SQLStatement = new SQLStatement();
		READ_BOOKMARKS.text = "SELECT * FROM bookmarks";
		
	// bookmark actions //	
		
		public static function ADD_BKMK(b:Bookmark):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "INSERT INTO bookmarks (label, type, path, autosave, active) ";
			s.text+= "VALUES ('"+b.label+"', '"+b.type+"', '"+b.path+"', '"+b.autosave+"', 1)";
			return s;
		}
		
		public static function EDIT_BKMK($oldLabel:String, $newLabel:String, $path:String, $autosave:uint):SQLStatement 
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE bookmarks SET label='"+$newLabel+"', path='"+$path+"', autosave='"+$autosave+"' WHERE label='"+$oldLabel+"'";
			return s;				
		}
		
		public static function DEL_BKMK($label:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "DELETE FROM bookmarks WHERE label='"+$label+"'";
			return s;
		}		
	
		public static const CLEAR_ACTIVE_BKMK:SQLStatement = new SQLStatement();
		CLEAR_ACTIVE_BKMK.text = "UPDATE bookmarks SET active=0 WHERE active=1";		
		
		public static function SET_ACTIVE_BKMK($label:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE bookmarks SET active=1 WHERE label='"+$label+"'";
			return s;			
		}
		
	// account actions //	

		public static function ADD_ACCOUNT(a:Account):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "INSERT INTO accounts (type, user, pass, sshKeyId) ";
			s.text+= "VALUES ('"+a.type+"', '"+a.user+"', '"+a.pass+"', '"+a.primary+"')";
			return s;			
		}

		public static function EDIT_ACCOUNT(a:Account):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE accounts SET pass='"+a.pass+"', sshKeyId='"+a.sshKeyId+"' WHERE type='"+a.type+"' AND user='"+a.user+"'";
			return s;
		}

		public static function DEL_ACCOUNT(a:Account):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "DELETE FROM accounts WHERE type='"+a.type+"' AND user='"+a.user+"'";
			return s;				
		}
		
		public static const CLEAR_SSH_KEY_ID:SQLStatement = new SQLStatement();
		CLEAR_SSH_KEY_ID.text = "UPDATE accounts SET sshKeyId=0 WHERE sshKeyId=1";		
		
		public static function SET_SSH_KEY_ID(a:Account):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE accounts SET sshKeyId='"+a.sshKeyId+"' WHERE type='"+a.type+"' AND user='"+a.user+"'";
			return s;				
		}
		
//		public static function ADD_NEW_FIELD($field:String):SQLStatement
//		{
//			var s:SQLStatement = new SQLStatement();
//			s.text = "ALTER TABLE bookmarks ADD '"+$field+"' tinyint(1) NOT NULL default 60";
//			return s;
//		}	
				
	}
	
}
