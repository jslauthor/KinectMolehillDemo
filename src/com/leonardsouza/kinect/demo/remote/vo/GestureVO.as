package com.leonardsouza.kinect.demo.remote.vo
{
	import com.leonardsouza.kinect.demo.model.enums.KinectServerEventTypes;
	
	import flash.geom.Vector3D;

	public class GestureVO
	{
		
		public static const GESTURE_WAVE:uint = 0;
		public static const GESTURE_RAISE_HAND:uint = 1;
		public static const GESTURE_SWIPE_LEFT:uint = 2;
		public static const GESTURE_SWIPE_RIGHT:uint = 3;
		public static const GESTURE_CLICK:uint = 4;
		
		private var _type:uint;
		private var _location:Vector3D;
		
		public function get type():uint
		{
			return _type;
		}

		public function set type(value:uint):void
		{
			_type = value;
		}

		public function get location():Vector3D
		{
			return _location;
		}

		public function set location(value:Vector3D):void
		{
			_location = value;
		}

	}
}