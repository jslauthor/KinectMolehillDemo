package com.leonardsouza.kinect.controllers
{
	import away3d.cameras.Camera3D;
	import away3d.primitives.Plane;
	
	import com.leonardsouza.easing.spark.Back;
	import com.leonardsouza.easing.spark.base.EaseInOutBase;
	import com.leonardsouza.kinect.util.Smoother;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import mx.effects.Parallel;
	import mx.effects.Sequence;
	import mx.events.EffectEvent;
	
	import spark.effects.Animate;
	import spark.effects.animation.Keyframe;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.IEaser;

	[Event(name="effectEnd", type="mx.events.EffectEvent")]
	
	public class KinectGestureController extends EventDispatcher
	{
		
		public static const DEFAULT_Z:int = -600;
		public static const MAX_ZOOM_Z:int = -1500;
		public static const MAX_ANGLE:Number = 160;
		
		private static const MAX_VELOCITY:Number = 60;
		private static const ANIMATED_Z_AMOUNT:int = -200;
		
		private var _leftBounds:Number;
		private var _rightBounds:Number;
		
		private var _container:DisplayObject;
		private var _target:Vector3D;
		private var _camera:Camera3D;
		
		private var _updateTimer:Timer;
		
		private var _currentVelocity:Number = 0;
		private var _currentAngle:Number = 0;
		
		private var _twoHandGestureAngle:Number = 0;
		private var _handDistance:Number = 0;
		
		private var _isTracking:Boolean = false;
		
		private var _ease:Back = new Back();
		private var _trackingSequence:Sequence;
		
		public function KinectGestureController(camera:Camera3D, container:DisplayObject)
		{
			_camera = camera;
			_target = new Vector3D();
			_container = container;
			
			_trackingSequence = new Sequence(_camera);
			_ease.easeType = EaseInOutBase.EASE_OUT;
			
			_updateTimer = new Timer(0, 0);
			_updateTimer.addEventListener(TimerEvent.TIMER, update);
			_updateTimer.start();
		}
		
		public function get handDistance():Number
		{
			return _handDistance;
		}

		public function set handDistance(value:Number):void
		{
			_handDistance = value;
		}

		public function get isTracking():Boolean
		{
			return _isTracking;
		}

		public function get twoHandGestureAngle():Number
		{
			return _twoHandGestureAngle;
		}

		public function set twoHandGestureAngle(value:Number):void
		{
			if (Math.abs(value) > MAX_ANGLE)
				_twoHandGestureAngle = value > 0 ? MAX_ANGLE : -MAX_ANGLE;
			else 
				_twoHandGestureAngle = value;
		}

		public function get rightBounds():int
		{
			return _rightBounds;
		}

		public function set rightBounds(value:int):void
		{
			_rightBounds = value;
			_camera.x = value;
		}

		public function get leftBounds():int
		{
			return _leftBounds;
		}

		public function set leftBounds(value:int):void
		{
			_leftBounds = value;
			_camera.x = value;
		}

		public function get target():Vector3D
		{
			return _target;
		}

		public function set target(value:Vector3D):void
		{
			_target = value;
		}

		public function startTracking(x:int, y:int):void
		{
			if (_twoHandGestureAngle != 0 && Math.round(_currentVelocity) != 0 && Math.round(_currentAngle) != 0) return; // only allow users to select a plane if they aren't moving it
			if (_camera.x == x && _camera.y == y && _camera.z == ANIMATED_Z_AMOUNT) return;
			
			_isTracking = true;
			
			_trackingSequence.children = new Array();
			var cameraAnimator:Animate;
			
			if (_trackingSequence.isPlaying || _camera.z != DEFAULT_Z)
			{
				_trackingSequence.stop();
				
				cameraAnimator = animationFactory(_camera, 350, _ease);
				cameraAnimator.motionPaths.push(motionPathFactory(_camera.z, DEFAULT_Z, 'z'));
				_trackingSequence.addChild(cameraAnimator);
			}
			
			cameraAnimator = animationFactory(_camera, 350, _ease);
			cameraAnimator.motionPaths.push(motionPathFactory(_camera.x, x, 'x'));
			cameraAnimator.motionPaths.push(motionPathFactory(_camera.y, y, 'y'));
			_trackingSequence.addChild(cameraAnimator);
			
			cameraAnimator = animationFactory(_camera, 350, _ease);
			cameraAnimator.motionPaths.push(motionPathFactory(DEFAULT_Z, ANIMATED_Z_AMOUNT, 'z'));
			_trackingSequence.addChild(cameraAnimator);
			
			_trackingSequence.play();
		}
		
		public function stopTracking():void
		{
			_trackingSequence.children = new Array();
			var cameraAnimator:Animate;
			
			_trackingSequence.stop();
			
			cameraAnimator = animationFactory(_camera, 350, _ease);
			cameraAnimator.motionPaths.push(motionPathFactory(_camera.z, DEFAULT_Z, 'z'));
			cameraAnimator.motionPaths.push(motionPathFactory(_camera.y, 0, 'y'));
			_trackingSequence.addChild(cameraAnimator);
			
			_trackingSequence.addEventListener(EffectEvent.EFFECT_END, onTrackingStopped);
			_trackingSequence.play();
		}
		
		protected function onTrackingStopped(event:EffectEvent):void
		{
			_trackingSequence.removeEventListener(EffectEvent.EFFECT_END, onTrackingStopped);
			_isTracking = false;
		}
		
		protected function update(event:TimerEvent):void
		{
			if (_isTracking)
			{
				if (!_trackingSequence.isPlaying)
				{
					var z:Number = ANIMATED_Z_AMOUNT + _handDistance/6;
					if (z <= -100)
						_camera.z = z;
					else
						_camera.z = -100;
				}
				return; // disable scrolling while focused on a single plane
			}
			
			// Begin of regular tracking
			
			var direction:Number = 1;
			if (_twoHandGestureAngle < 0) direction = -1;
			
			var vDifference:Number;
			var aDifference:Number;

			if (_twoHandGestureAngle != 0 && (!(_camera.x == _leftBounds && direction < 0) && !(_camera.x == _rightBounds && direction > 0)))
			{
				// Provides animation for when there is movement
				
				var velocity:Number = (_twoHandGestureAngle / MAX_ANGLE) * MAX_VELOCITY;
				var acceleration:Number = velocity * (_twoHandGestureAngle / MAX_ANGLE);
				
				vDifference = (velocity - _currentVelocity) / 10;
				aDifference = (_twoHandGestureAngle - _currentAngle) / 10;
				
				if (velocity != _currentVelocity)
					_currentVelocity += vDifference;
				
				if (_twoHandGestureAngle !=_currentAngle)
					_currentAngle += aDifference;
			}
			else
			{
				// Provides animation back to neutral position
				
				vDifference = Math.abs(0 - Math.abs(_currentVelocity)) / 20;
				aDifference = Math.abs(0 - Math.abs(_currentAngle)) / 20;
				
				if (Math.abs(_currentVelocity) <= MAX_VELOCITY && Math.abs(_currentVelocity) > .1)
					_currentVelocity = _currentVelocity > 0 ? _currentVelocity - vDifference : _currentVelocity + vDifference;
				else
					_currentVelocity = 0;
				
				if (Math.abs(_currentAngle) <= MAX_ANGLE && Math.abs(_currentAngle) > .1)
					_currentAngle = _currentAngle > 0 ? _currentAngle - aDifference : _currentAngle + aDifference;
				else
					_currentAngle = 0;
			}

			_camera.x += _currentVelocity; // track the camera along the planes
			_camera.lookAt(new Vector3D(_camera.x + _currentAngle, 0, 0)); // turn the camera slightly at an angle based on speed

			if (_camera.x < _leftBounds)
				_camera.x = _leftBounds;
			else if (_camera.x > _rightBounds)
				_camera.x = _rightBounds;

		}
		
		// Some simple factories
		
		protected function motionPathFactory(from:Number, to:Number, property:String):SimpleMotionPath
		{
			var motionPath:SimpleMotionPath = new SimpleMotionPath(property);
			motionPath.valueFrom =from;
			motionPath.valueTo = to;
			return motionPath;
		}
		
		protected function animationFactory(target:Object, duration:Number, easer:IEaser):Animate
		{
			var animate:Animate = new Animate(target);
			animate.duration = duration;
			animate.easer = easer;
			animate.duration = duration;
			animate.motionPaths = new Vector.<MotionPath>();
			return animate;
		}
	}
}