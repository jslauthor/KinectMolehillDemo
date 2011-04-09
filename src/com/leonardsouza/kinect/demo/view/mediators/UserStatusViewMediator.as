package com.leonardsouza.kinect.demo.view.mediators
{
	import com.leonardsouza.kinect.animators.skeleton.Skeleton3D;
	import com.leonardsouza.kinect.demo.model.enums.KinectServerEventTypes;
	import com.leonardsouza.kinect.demo.remote.vo.UserStatusVO;
	import com.leonardsouza.kinect.demo.signals.UserSkeletonUpdate;
	import com.leonardsouza.kinect.demo.signals.UserUpdate;
	import com.leonardsouza.kinect.demo.view.components.UserStatusView;
	import com.leonardsouza.kinect.util.CoordinateUtil;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Mediator;

	public class UserStatusViewMediator extends Mediator
	{
		public static const UDP_EXPIRATION:uint = 3000;
		
		[Inject]
		public var view:UserStatusView;
		
		[Inject]
		public var userSkeletonUpdate:UserSkeletonUpdate; 
		
		[Inject]
		public var userUpdate:UserUpdate;
		
		protected var labelExpirationTimer:Timer;
		protected var currentUserID:uint;
		
		override public function onRegister():void
		{
			userSkeletonUpdate.add(render);
			userUpdate.add(updateLabel);
			
			labelExpirationTimer = new Timer(UDP_EXPIRATION, 0);
			labelExpirationTimer.addEventListener(TimerEvent.TIMER, onLabelExpiration);
			
			onLabelExpiration();
			
			view.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
																								
		}
		
		protected function onKeyboardEvent(event:KeyboardEvent):void
		{
			if (event.charCode == 100)
				view.currentState = view.currentState == 'skeletonMinimized' ? 'skeletonMaximized' : 'skeletonMinimized';
		}
		
		private function onLabelExpiration(event:TimerEvent = null):void
		{
			setLabel("Waiting for user");
		}
		
		private function setLabel(text:String):void
		{
			if (view.userStatusLabel.text == text)
			{
				return;
			}
			else
			{
				if (!view.showStatusCaption.isPlaying)
				{
					view.showStatusCaption.play();
				}
				else
				{
					view.showStatusCaption.end();
					view.showStatusCaption.play();
				}
			}
			
			view.userStatusLabel.text = text;
		}
		
		private function render(skeleton:Skeleton3D):void
		{
			var width:uint = view.userSkeleton.width;
			var height:uint = view.userSkeleton.height;
			var point:Point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.head.x, skeleton.head.y));
			
			view.head.x = point.x;
			view.head.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.neck.x, skeleton.neck.y));

			view.neck.x = point.x;
			view.neck.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.torso.x, skeleton.torso.y));
			
			view.torso.x = point.x;
			view.torso.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.leftShoulder.x, skeleton.leftShoulder.y));
			
			view.leftShoulder.x = point.x;
			view.leftShoulder.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.rightShoulder.x, skeleton.rightShoulder.y));
			
			view.rightShoulder.x = point.x;
			view.rightShoulder.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.leftElbow.x, skeleton.leftElbow.y));
			
			view.leftElbow.x = point.x;
			view.leftElbow.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.rightElbow.x, skeleton.rightElbow.y));
			
			view.rightElbow.x = point.x;
			view.rightElbow.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.leftHand.x, skeleton.leftHand.y));
			
			view.leftHand.x = point.x;
			view.leftHand.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.rightHand.x, skeleton.rightHand.y));
			
			view.rightHand.x = point.x;
			view.rightHand.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.leftHip.x, skeleton.leftHip.y));
			
			view.leftHip.x = point.x;
			view.leftHip.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.rightHip.x, skeleton.rightHip.y));
			
			view.rightHip.x = point.x;
			view.rightHip.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.leftKnee.x, skeleton.leftKnee.y));
			
			view.leftKnee.x = point.x;
			view.leftKnee.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.rightKnee.x, skeleton.rightKnee.y));
			
			view.rightKnee.x = point.x;
			view.rightKnee.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.leftFoot.x, skeleton.leftFoot.y));
		
			view.leftFoot.x = point.x;
			view.leftFoot.y = point.y;
			
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.rightFoot.x, skeleton.rightFoot.y));
			
			view.rightFoot.x = point.x;
			view.rightFoot.y = point.y;
			
			// Warn user if user's torso is closer than 6.5 feet
			if ((skeleton.torso.z / 25.4) / 12 < SkeletonHandsViewMediator.MIN_DISTANCE)
				setLabel("User " + skeleton.userID + " too close, please back up");
			else
				setLabel("User " + skeleton.userID + " currently active");
			
			resetTimer();
		}
		
		private function updateLabel(user:UserStatusVO):void
		{
			var label:String = "Unknown status";
			var eventID:int = user.type;
			
			switch (eventID)
			{
				case KinectServerEventTypes.NEW_USER_FOUND:
					label = "User " + user.userID + " found";
					labelExpirationTimer.stop(); // pending user feedback, leave message there
					break;
				case KinectServerEventTypes.USER_POSE_DETECTED:
					label = "User " + user.userID + " calibration pose detected";
					labelExpirationTimer.stop(); // pending user feedback, leave message there
					break;
				case KinectServerEventTypes.USER_CALIBRATION_START:
					label = "User " + user.userID + " calibration started";
					labelExpirationTimer.stop(); // pending user feedback, leave message there
					break;
				case KinectServerEventTypes.USER_CALIBRATION_FAILED:
					label = "User " + user.userID + " calibration failed";
					labelExpirationTimer.stop(); // pending user feedback, leave message there
					break;
				case KinectServerEventTypes.USER_CALIBRATION_SUCEEDED:
					label = "User " + user.userID + " calibration succeeded";
					currentUserID = user.userID;
					resetTimer();
					break;
				case KinectServerEventTypes.USER_LOST:
					label = "User " + user.userID + " lost";
					break;
				default: break;
			}
			setLabel(label);
		}
		
		private function resetTimer():void
		{
			labelExpirationTimer.stop();
			labelExpirationTimer.reset();
			labelExpirationTimer.start();
		}
	}
}