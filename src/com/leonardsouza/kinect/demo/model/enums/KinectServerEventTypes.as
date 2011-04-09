package com.leonardsouza.kinect.demo.model.enums
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class KinectServerEventTypes extends EventDispatcher
	{
		// Main Events
		
		public static const SKELETAL_EVENT:uint = 0;
		public static const GESTURE_EVENT:uint = 1;
		public static const HAND_EVENT:uint = 2;
		public static const USER_EVENT:uint = 3;
		
		// Secondary (specific) Events
		
		public static const GESTURE_RECOGNIZED:uint = 0;
		public static const	GESTURE_PROCESSED:uint = 1;
		
		public static const HAND_BEGAN:uint = 0;
		public static const HAND_MOVED:uint = 1;
		public static const HAND_ENDED:uint = 2;
		
		public static const NEW_USER_FOUND:uint = 0;
		public static const USER_POSE_DETECTED:uint = 1;
		public static const USER_CALIBRATION_START:uint = 2;
		public static const USER_CALIBRATION_FAILED:uint = 3;
		public static const USER_CALIBRATION_SUCEEDED:uint = 4;
		public static const USER_LOST:uint = 5;
		public static const USER_TOO_CLOSE:uint = 6; // This is actually dispatched client-side, but could be written into the server if needed
		
		public static const USER_SKELETON_UPDATE:uint = 0;
		
	}
}