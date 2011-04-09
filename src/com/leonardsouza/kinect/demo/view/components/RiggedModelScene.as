package com.leonardsouza.kinect.demo.view.components
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.ResourceEvent;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.loading.ResourceManager;
	import away3d.loading.parsers.ColladaParser;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.utils.CubeMap;
	import away3d.primitives.Plane;
	import away3d.primitives.SkyBox;
	
	import com.leonardsouza.kinect.controllers.KinectMonsterController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	import spark.primitives.Rect;
	
	public class RiggedModelScene extends UIComponent implements IVisualElement
	{
		
		[Embed(source="/../embeds/rockbase.jpg")]
		private var FloorDiffuse : Class;
		
		[Embed(source="/../embeds/rockbase_local.png")]
		private var FloorNormals : Class;
		
		[Embed(source="/../embeds/rockbase_s.png")]
		private var FloorSpecular : Class;
		
		[Embed(source="/../embeds/grim_sky/posX.png")]
		private var EnvPosX : Class;
		
		[Embed(source="/../embeds/grim_sky/posY.png")]
		private var EnvPosY : Class;
		
		[Embed(source="/../embeds/grim_sky/posZ.png")]
		private var EnvPosZ : Class;
		
		[Embed(source="/../embeds/grim_sky/negX.png")]
		private var EnvNegX : Class;
		
		[Embed(source="/../embeds/grim_sky/negY.png")]
		private var EnvNegY : Class;
		
		[Embed(source="/../embeds/grim_sky/negZ.png")]
		private var EnvNegZ : Class;
		
		private var _view : View3D;
		private var _controller : KinectMonsterController;
		private var _targetLookAt : Vector3D;
		private var _envMap : CubeMap;
		private var _light : LightBase;
		private var _light3 : LightBase;
		private var _shadowMethod1 : SoftShadowMapMethod;
		private var _shadowMethod2 : SoftShadowMapMethod;
		
		public function RiggedModelScene()
		{
			super();
			
			_view = new View3D();
			_view.backgroundColor = 0xFFFFFF;
			_view.camera.lens.far = 10000;
			_view.camera.z = -200;
			_view.camera.y = 160;
			_view.camera.lookAt(_targetLookAt = new Vector3D(0, 50, 0));
			
			addChild(new AwayStats(_view));
			addChild(_view);
			
			_light = new DirectionalLight(0, -20, 10);
			_light.color = 0xffffee;
			_light.castsShadows = true;

			_light3 = new PointLight();
			_light3.x = 15000;
			_light3.z = 15000;
			_light3.color = 0xffddbb;
			_view.scene.addChild(_light3);
			
			_view.scene.addChild(_light);
			
			_envMap = new CubeMap(	new EnvPosX().bitmapData,  new EnvNegX().bitmapData,
				new EnvPosY().bitmapData,  new EnvNegY().bitmapData,
				new EnvPosZ().bitmapData,  new EnvNegZ().bitmapData);
			_view.scene.addChild(new SkyBox(_envMap));
			
			var material:BitmapMaterial = new BitmapMaterial(new FloorDiffuse().bitmapData, true, true, true);
			material.lights = [_light, _light3];
			material.ambientColor = 0x202030;
			material.normalMap = new FloorNormals().bitmapData;
			material.specularMap = new FloorSpecular().bitmapData;
			material.addMethod(_shadowMethod1 = new SoftShadowMapMethod(_light, 0x707090));
			material.addMethod(new FogMethod(_view.camera.lens.far*.5, 0x000000));
			
			var plane:Plane = new Plane(material, 50000, 50000, 1, 1, false);
			plane.geometry.scaleUV(200);
			plane.castsShadows = false;
			_view.scene.addChild(plane);
			
			_controller = new KinectMonsterController();
			_view.scene.addChild(_controller.mesh);
			_controller.bodyMaterial.addMethod(new FogMethod(_view.camera.lens.far*.5, 0x000000));
			_controller.bodyMaterial.specularMethod = null;
			_controller.bodyMaterial.lights = [_light, _light3];
			_controller.bodyMaterial.addMethod(_shadowMethod2 = new SoftShadowMapMethod(_light, 0x707090));
			
			FlexGlobals.topLevelApplication.addEventListener(Event.RESIZE, onStageResize);
			FlexGlobals.topLevelApplication.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			_view.antiAlias = 4;
			_view.width = 1024;
			_view.height = 576;
		}

		private function onStageResize(event:Event) : void
		{
			_view.width = FlexGlobals.topLevelApplication.width;
			_view.height = FlexGlobals.topLevelApplication.height;
		}
		
		private function handleEnterFrame(ev : Event) : void
		{
			var mesh : Mesh = _controller.mesh;
			_targetLookAt.x = _targetLookAt.x + (mesh.x - _targetLookAt.x)*.03;
			_targetLookAt.y = _targetLookAt.y + (mesh.y + 50 - _targetLookAt.y)*.03;
			_targetLookAt.z = _targetLookAt.z + (mesh.z - _targetLookAt.z)*.03;
			_view.camera.lookAt(_targetLookAt);

			_view.render();
		}
		
	}
}