package com.leonardsouza.kinect.demo.view.components
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.utils.CubeMap;
	import away3d.primitives.Plane;
	import away3d.primitives.SkyBox;
	import away3d.tools.utils.Bounds;
	
	import com.leonardsouza.easing.spark.Back;
	import com.leonardsouza.easing.spark.base.EaseInOutBase;
	import com.leonardsouza.kinect.controllers.KinectGestureController;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import mx.events.EffectEvent;
	
	import spark.core.SpriteVisualElement;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;

	public class MediaWallView extends SpriteVisualElement
	{
		public static const WIDTH_ASPECT_RATIO:Number = 1.3;
		public static const HEIGHT_ASPECT_RATIO:Number = .75;
		
		public static const PLANE_WIDTH:uint = 1024;
		public static const PLANE_HEIGHT:uint = 768;
		
		public static const COLUMN_NUM:uint = 25;
		public static const ROW_NUM:uint = 3;
		
		public static const LAYOUT_GAP:uint = 15;
		
		private var _view:View3D;
		private var _container:ObjectContainer3D;
		private var _light:LightBase;
		private var _camController:KinectGestureController;
		private var _defaultMaterial:ColorMaterial;
		private var _shadowMaterial:ColorMaterial;
		private var _imageMaterial:BitmapMaterial;
		
		private var _renderTimer:Timer;
		private var _planes:Vector.<Plane>;
		private var _shadows:Vector.<Plane>;
		
		private var _selectedPlane:Plane;
		
		[Embed(source="/assets/env_maps/xbox.jpg")]
		private var Env:Class;
		
		public function MediaWallView()
		{
			super();
			createChildren();
		}
		
		public function get light():LightBase
		{
			return _light;
		}

		public function set light(value:LightBase):void
		{
			_light = value;
		}

		public function get planes():Vector.<Plane>
		{
			return _planes;
		}

		public function set planes(value:Vector.<Plane>):void
		{
			_planes = value;
		}

		public function get view():View3D
		{
			return _view;
		}

		public function get camController():KinectGestureController
		{
			return _camController;
		}

		protected function createChildren():void
		{
			// View
			_view = new View3D();
			_view.antiAlias = 8;
			_view.camera.z = KinectGestureController.DEFAULT_Z;
			addChild(_view);
			
			// The Kinect gesture based camera controller
			_camController = new KinectGestureController(_view.camera, DisplayObject(FlexGlobals.topLevelApplication));
			
			// These should be calculated based on the camera projection and bounds of the _container, but this is easier for a demo :)
			_camController.rightBounds = 5000;
			_camController.leftBounds = 220;
			
			//_camController.twoHandGestureAngle = KinectGestureController.MAX_ANGLE;
		
			// Render Timer
			_renderTimer = new Timer(0, 0);
			_renderTimer.addEventListener(TimerEvent.TIMER, render);
			_renderTimer.start();
			
			// Container for primitives
			_container = new ObjectContainer3D();
			_view.scene.addChild(_container);
			
			// Default material for media that hasn't been loaded yet
			_defaultMaterial = new ColorMaterial(0x333333, 1);
			_defaultMaterial.ambientColor = 0xFFFFFF;
			
			// Generate planes that will hold images
			_planes = new Vector.<Plane>();
			for (var i:uint = 0; i < COLUMN_NUM * ROW_NUM; i++)
			{
				_planes.push(new Plane(_defaultMaterial));
				
				_planes[i].mouseDetails = true;
				_planes[i].mouseEnabled = true;
				_planes[i].addEventListener(MouseEvent3D.CLICK, onMouseClick);
				
				_container.addChild(_planes[i]);
			}
			
			// Generate "shadow" planes
			_shadowMaterial = new ColorMaterial(0xf4f4f4, 1);
			_shadowMaterial.blendMode = BlendMode.MULTIPLY;
			_shadows = new Vector.<Plane>();
			for (var j:uint = 0; j < COLUMN_NUM; j++)
			{
				_shadows.push(new Plane(_shadowMaterial));
				_container.addChild(_shadows[j]);
			}
			
			// Position the planes in space
			invalidateLayout();
			
			// Light
			_light = new DirectionalLight();
			_light.x = 0;
			_light.y = 1000;
			_light.z = -1000;
			_light.color = 0xFFFFFF;
			
			_defaultMaterial.lights = [_light];
			_view.scene.addChild(_light);
			
			// Handle resize
			FlexGlobals.topLevelApplication.addEventListener(Event.RESIZE, onStageResize);
			
			// Add XBOX background :)
			var _envMap:CubeMap = new CubeMap(new Env().bitmapData, new Env().bitmapData,
				new Env().bitmapData, new Env().bitmapData,
				new Env().bitmapData, new Env().bitmapData);
			_view.scene.addChild(new SkyBox(_envMap));
		}
		
		protected function onMouseClick(event:MouseEvent3D = null):void
		{
			if (!mouseEnabled) return;
			_selectedPlane = Plane(event.target);
			_camController.startTracking(_selectedPlane.x, _selectedPlane.y - LAYOUT_GAP);
		}
		
		protected function onStageResize(event:Event) : void
		{
			width = _view.width = FlexGlobals.topLevelApplication.width;
			height = _view.height = FlexGlobals.topLevelApplication.height;
			
			invalidateLayout();
		}
		
		override protected function invalidateSize():void
		{
			super.invalidateSize();
			invalidateLayout();
		}
		
		protected function invalidateLayout():void
		{
			if (height == 0 || width == 0) {return;}
			
			var planeHeight:uint = (height - ((ROW_NUM-1) * LAYOUT_GAP) - 300) / ROW_NUM;
			var planeWidth:uint = planeHeight * WIDTH_ASPECT_RATIO;
			
			var centeredYOffset:Number = _view.height/2 - ((ROW_NUM * planeHeight) - (ROW_NUM * LAYOUT_GAP))/2;
			
			// Lay planes out in a grid pattern in center Y of view
			
			var index:uint = 0;
			for (var i:uint = 0; i < COLUMN_NUM; i++)
			{
				for (var j:uint = 0; j < ROW_NUM; j++)
				{
					_planes[index].height = planeHeight;
					_planes[index].width = planeWidth;
					
					_planes[index].x = (i * planeWidth) + (i * LAYOUT_GAP);
					_planes[index].y = -((j * planeHeight) + (j * LAYOUT_GAP)) + centeredYOffset;
					
					index++;
				}
				
				// Position "shadow" for each column of planes 
				_shadows[i].width = planeWidth;
				_shadows[i].height = 5;
				
				_shadows[i].x = (i * planeWidth) + (i * LAYOUT_GAP);
				_shadows[i].y = -260;
			}
			
			Bounds.getObjectContainerBounds(_container);
			_light.x = Bounds.width/2; // Center light within planes width
		}
		
		protected function render(event:TimerEvent):void
		{
			//_camController.twoHandGestureAngle -= 2;
//			if (_renderTimer.currentCount == 20)
//				_camController.twoHandGestureAngle = 0;
//			
//			if (_renderTimer.currentCount == 80)
//				_camController.twoHandGestureAngle = 45;
//			
//			if (_renderTimer.currentCount == 300)
//				_camController.twoHandGestureAngle = -45;
			
			_view.render();
		}
		
	}
}