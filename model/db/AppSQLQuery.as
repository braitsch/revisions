package model.db {
	import model.vo.Bookmark;
	import flash.data.SQLStatement;

	public class AppSQLQuery {

		public static const INIT_DATABASE:SQLStatement = new SQLStatement();
		INIT_DATABASE.text = "CREATE TABLE IF NOT EXISTS bookmarks ";
		INIT_DATABASE.text+= "(id INTEGER PRIMARY KEY AUTOINCREMENT, ";
		INIT_DATABASE.text+= "label TEXT, type TEXT, path TEXT, remote TEXT, ";
		INIT_DATABASE.text+= "active tinyint(1) default 0, autosave tinyint(1) default 60)";

		public static const READ_REPOSITORIES:SQLStatement = new SQLStatement();
		READ_REPOSITORIES.text = "SELECT * FROM bookmarks";
		
		public static const CLEAR_ACTIVE:SQLStatement = new SQLStatement();
		CLEAR_ACTIVE.text = "UPDATE bookmarks SET active=0 WHERE active=1";

		public static function INSERT(b:Bookmark):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "INSERT INTO bookmarks (label, type, path, autosave, active) ";
			s.text+= "VALUES ('"+b.label+"', '"+b.type+"', '"+b.path+"', '"+b.autosave+"', 1)";
			return s;
		}
		
		public static function EDIT($oldLabel:String, $newLabel:String, $path:String, $autosave:uint):SQLStatement 
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE bookmarks SET label='"+$newLabel+"', path='"+$path+"', autosave='"+$autosave+"' WHERE label = '"+$oldLabel+"'";
			return s;				
		}
		
		public static function DELETE($label:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "DELETE FROM bookmarks WHERE label = '"+$label+"'";
			return s;
		}		
		
		public static function SET_ACTIVE($label:String):SQLStatement
		{
			var s:SQLStatement = new SQLStatement();
			s.text = "UPDATE bookmarks SET active=1 WHERE label = '"+$label+"'";
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
