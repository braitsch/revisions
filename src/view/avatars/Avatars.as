package view.avatars {

	public class Avatars {
		
		private static var _avatars:Vector.<AvatarLoader> = new Vector.<AvatarLoader>();
		
		public static function getAvatar(e:String):Avatar
		{
			for (var i:int = 0; i < _avatars.length; i++) {
				if (_avatars[i].id == e) return new Avatar(_avatars[i]);
			}
			var b:AvatarLoader = new AvatarLoader(e);
			_avatars.push(b);
			return new Avatar(b);
		}

	}
	
}
