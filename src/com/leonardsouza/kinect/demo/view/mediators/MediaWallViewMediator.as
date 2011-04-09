package com.leonardsouza.kinect.demo.view.mediators
{
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	
	import com.leonardsouza.kinect.demo.model.ImageModel;
	import com.leonardsouza.kinect.demo.model.vo.HandsVO;
	import com.leonardsouza.kinect.demo.remote.vo.GestureVO;
	import com.leonardsouza.kinect.demo.signals.BitmapReady;
	import com.leonardsouza.kinect.demo.signals.GestureUpdate;
	import com.leonardsouza.kinect.demo.signals.HandsUpdate;
	import com.leonardsouza.kinect.demo.signals.LoadFlickrGallery;
	import com.leonardsouza.kinect.demo.view.components.MediaWallView;
	import com.leonardsouza.kinect.util.CoordinateUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MediaWallViewMediator extends Mediator
	{
		[Inject]
		public var view:MediaWallView;
		
		[Inject]
		public var handsUpdate:HandsUpdate; 
		
		[Inject]
		public var gestureUpdate:GestureUpdate; 
		
		[Inject]
		public var loadFlickrGallery:LoadFlickrGallery;
		
		[Inject]
		public var bitmapReady:BitmapReady;
		
		[Inject]
		public var imageModel:ImageModel;
		
		private var _currentHands:HandsVO;
		
		private var _handExpirationTimer:Timer;
		
		override public function onRegister():void
		{
			handsUpdate.add(updateHands);
			gestureUpdate.add(updateGesture);
			
			loadFlickrGallery.add(resetPlanes);
			
			// Load flick gallery
			loadFlickrGallery.dispatch();
			bitmapReady.add(onFlickrLoad);
			
			_handExpirationTimer = new Timer(300, 1);
			_handExpirationTimer.addEventListener(TimerEvent.TIMER, resetAngle);
			_handExpirationTimer.start();
			resetTimer();
		}
		
		protected function resetTimer():void
		{
			_handExpirationTimer.stop();
			_handExpirationTimer.reset();
			_handExpirationTimer.start();
		}
		
		protected function resetAngle(event:TimerEvent = null):void
		{
			view.camController.twoHandGestureAngle = 0;
		}
		
		protected function resetPlanes():void
		{
			
		}
		
		protected function onFlickrLoad(index:uint):void
		{
			try
			{
				var plane:Plane = view.planes[index];
				plane.material = new BitmapMaterial(cropAndScaleBitmap(imageModel.bitmaps[index], 512, 512));
				//plane.material.lights = [view.light];
			}
			catch (e:Error)
			{
				trace('Error! ' + e.message);
			}
		}
		
		private function cropAndScaleBitmap(source:BitmapData, width:uint = 1024, height:uint = 1024):BitmapData
		{
			var matrix : Matrix =  new Matrix();
			matrix.scale(width / source.width, height / source.height);
			
			var ouputBitmapData:BitmapData = new BitmapData( width, height , true , 0x00000000 );
			ouputBitmapData.draw( source , matrix , null , null , null , true );
			return ouputBitmapData;
		}
		
		protected function updateHands(hands:HandsVO):void
		{
			if (view.camController.isTracking)
			{
				var distance:Number = Vector3D.distance(hands.left, hands.right);
				trace(distance);
				if (distance >= 300)
					view.camController.handDistance = Vector3D.distance(hands.left, hands.right);
			}
			else
			{
				view.camController.handDistance;
			}
			
			if ((hands.left.z >= 1 && hands.right.z >= 1) 
				&& (Math.abs(hands.left.z - hands.right.z) >= 30) // require a little distance between hands before activating scroll
				&& (Math.abs(hands.left.y - hands.right.y) <= 30)
				&& (Math.abs(hands.left.x - hands.right.x) <= 200))
				view.camController.twoHandGestureAngle = (Math.round(hands.left.z - hands.right.z) - 30) * .5; // add the distance back in (that's the 30) so velocity is not exaggerated
			else
				resetAngle();
			
			resetTimer();
		}
		
		protected function updateGesture(gesture:GestureVO):void
		{
			if (gesture.type == 4)
			{
				if (view.camController.isTracking)
				{
					view.camController.stopTracking();
					return;
				}
				
				var stage:DisplayObject = DisplayObject(FlexGlobals.topLevelApplication);
				var point:Point = CoordinateUtil.scalePixelCoordinate(stage.width, stage.height, new Point(gesture.location.x, gesture.location.y));
				view.view.stage.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, true, point.x, point.y));
			}
		}
		
		protected function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2(dy,dx);
		}
	}
}