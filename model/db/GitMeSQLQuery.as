package model.db {
	import flash.data.SQLStatement;

	public class GitMeSQLQuery {

		public static const INIT_DATABASE:SQLStatement = new SQLStatement();
		INIT_DATABASE.text = "CREATE TABLE IF NOT EXISTS repositories (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, location TEXT, active INTEGER)";
	
		public static const READ_REPOSITORIES:SQLStatement = new SQLStatement();
		READ_REPOSITORIES.text = "SELECT * FROM repositories";
		
		public static const CLEAR_ACTIVE:SQLStatement = new SQLStatement();
		CLEAR_ACTIVE.text = "UPDATE repositories SET active=0 WHERE active=1";
		
		public static function INSERT($name:String, $dir:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "INSERT INTO repositories (name, location, active) VALUES ('"+$name+"', '"+$dir+"', 1)";
			return s;
		}
		
		public static function EDIT($id:String, $newId:String, $location:String):SQLStatement 
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE repositories SET name='"+$newId+"', location='"+$location+"' WHERE name = '"+$id+"'";
			return s;				
		}
		
		public static function DELETE($name:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "DELETE FROM repositories WHERE name = '"+$name+"'";
			return s;
		}		
		
		public static function SET_ACTIVE($name:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE repositories SET active=1 WHERE name = '"+$name+"'";
			return s;			
		}
				
	}
	
}
