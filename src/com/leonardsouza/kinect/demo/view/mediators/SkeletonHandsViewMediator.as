package com.leonardsouza.kinect.demo.view.mediators
{
	import com.leonardsouza.kinect.animators.skeleton.Skeleton3D;
	import com.leonardsouza.kinect.demo.model.enums.KinectServerEventTypes;
	import com.leonardsouza.kinect.demo.model.vo.HandsVO;
	import com.leonardsouza.kinect.demo.remote.vo.UserStatusVO;
	import com.leonardsouza.kinect.demo.signals.HandsUpdate;
	import com.leonardsouza.kinect.demo.signals.UserSkeletonUpdate;
	import com.leonardsouza.kinect.demo.signals.UserUpdate;
	import com.leonardsouza.kinect.demo.view.components.SkeletonHandsView;
	import com.leonardsouza.kinect.util.CoordinateUtil;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SkeletonHandsViewMediator extends Mediator
	{
		
		public static const MIN_DISTANCE:Number = 6.5; // Minimum number of feet the user needs to be from the sensor 
		
		[Inject]
		public var view:SkeletonHandsView;
		
		[Inject]
		public var userSkeletonUpdate:UserSkeletonUpdate; 
		
		[Inject]
		public var handsUpdate:HandsUpdate; 
		
		[Inject]
		public var userUpdate:UserUpdate;
		
		private var handsExpirationTimer:Timer;
		
		override public function onRegister():void
		{
			handsExpirationTimer = new Timer(300, 1);
			handsExpirationTimer.addEventListener(TimerEvent.TIMER, onHandsExpiration);
			
			userSkeletonUpdate.add(render);
		}
		
		private function onHandsExpiration(event:TimerEvent = null):void
		{
			view.leftHand.visible = view.rightHand.visible = false;
			
		}
		
		private function render(skeleton:Skeleton3D):void
		{
			// If user's torso is closer than 6.5 feet, do not update hands
			// User will be warned in the UserStatusViewMediator messaging
			if (getDistance(skeleton.torso.z) < MIN_DISTANCE)
			{
				onHandsExpiration();
				return;
			}
			
			view.leftHand.visible = view.rightHand.visible = true;
			
			var hands:HandsVO = new HandsVO();
			
			var width:uint = view.width;
			var height:uint = view.height;
			
			// Scale Kinect x/y coordinates to skeleton hands view size
			var point:Point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.leftHand.x, skeleton.leftHand.y));
			
			// Change coordinates to global coordinates to simulate mouse event
			hands.left = new Vector3D(view.localToGlobal(point).x, view.localToGlobal(point).y, skeleton.leftHand.z);

			// Show the left hand on the screen
			if (skeleton.leftHand.x >= 1 && skeleton.leftHand.y >= 1)
			{
				view.leftHand.x = point.x;
				view.leftHand.y = point.y;				
			}
			
			// Scale Kinect x/y coordinates to view size
			point = CoordinateUtil.scalePixelCoordinate(width, height, new Point(skeleton.rightHand.x, skeleton.rightHand.y));
			
			// Change coordinates to global coordinates to simulate mouse event
			hands.right = new Vector3D(view.localToGlobal(point).x, view.localToGlobal(point).y, skeleton.rightHand.z);
			
			// Show the right hand on the screen
			if (skeleton.rightHand.x >= 1 && skeleton.rightHand.y >= 1)
			{
				view.rightHand.x = point.x;
				view.rightHand.y = point.y;
			}
			
			// Scale hands in proportion to each others Z
			if (hands.left.z >= 1 && hands.right.z >= 1)
			{
				view.leftHand.width = view.leftHand.height = 40 * (hands.left.z / hands.right.z);
				view.rightHand.width = view.rightHand.height = 40 * (hands.right.z / hands.left.z);
			}
			
			// Let away3D know there are hands
			handsUpdate.dispatch(hands);
			
			resetTimer();
		}
		
		private function resetTimer():void
		{
			handsExpirationTimer.stop();
			handsExpirationTimer.reset();
			handsExpirationTimer.start();
		}
		
		private function getDistance(mm:Number):Number
		{
			return (mm / 25.4) / 12; // Convert mm to feet
		}
		
	}
}