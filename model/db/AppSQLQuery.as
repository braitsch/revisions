package model.db {
	import flash.data.SQLStatement;

	public class AppSQLQuery {

		public static const INIT_DATABASE:SQLStatement = new SQLStatement();
		INIT_DATABASE.text = "CREATE TABLE IF NOT EXISTS repositories (id INTEGER PRIMARY KEY AUTOINCREMENT, label TEXT, path TEXT, remote TEXT, active INTEGER)";

		public static const READ_REPOSITORIES:SQLStatement = new SQLStatement();
		READ_REPOSITORIES.text = "SELECT * FROM repositories";
		
		public static const CLEAR_ACTIVE:SQLStatement = new SQLStatement();
		CLEAR_ACTIVE.text = "UPDATE repositories SET active=0 WHERE active=1";

		public static function INSERT($label:String, $path:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "INSERT INTO repositories (label, path, active) VALUES ('"+$label+"', '"+$path+"', 1)";
			return s;
		}
		
		public static function EDIT($oldLabel:String, $newLabel:String, $path:String):SQLStatement 
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE repositories SET label='"+$newLabel+"', path='"+$path+"' WHERE label = '"+$oldLabel+"'";
			return s;				
		}
		
		public static function DELETE($label:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "DELETE FROM repositories WHERE label = '"+$label+"'";
			return s;
		}		
		
		public static function SET_ACTIVE($label:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE repositories SET active=1 WHERE label = '"+$label+"'";
			return s;			
		}
				
	}
	
}
