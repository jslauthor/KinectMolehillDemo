package com.leonardsouza.kinect.demo.remote.vo
{
	import com.leonardsouza.kinect.demo.model.enums.KinectServerEventTypes;

	public class UserStatusVO
	{

		private var _userID:uint;
		private var _type:uint;
		
		public function UserStatusVO(id:uint, eventID:uint):void
		{
			userID = id;
			type = eventID;
		}
		
		public function get userID():uint
		{
			return _userID;
		}

		public function set userID(value:uint):void
		{
			_userID = value;
		}

		public function get type():uint
		{
			return _type;
		}

		public function set type(value:uint):void
		{
			_type = value;
		}

	}
}