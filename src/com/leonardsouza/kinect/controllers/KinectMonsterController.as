package com.leonardsouza.kinect.controllers
{
	import away3d.entities.Mesh;
	import away3d.loading.ResourceManager;
	import away3d.materials.BitmapMaterial;
	
	import com.leonardsouza.kinect.animators.KinectAnimator;

	public class KinectMonsterController
	{

		public static const MESH_NAME : String = "hellknight";
		public static const MD5_DIR : String = "hellknight";
		
		[Embed(source="/../embeds/hellknight/hellknight.jpg")]
		private var BodyAlbedo : Class;
		
		[Embed(source="/../embeds/hellknight/hellknight_s.png")]
		private var BodySpec : Class;
		
		[Embed(source="/../embeds/hellknight/hellknight_local.png")]
		private var BodyNorms : Class;
		
		private var _bodyMaterial:BitmapMaterial;
		private var _controller:KinectAnimator;
		private var _mesh:Mesh;
		
		public function get bodyMaterial() : BitmapMaterial
		{
			return _bodyMaterial;
		}
		
		public function get mesh() : Mesh
		{
			return _mesh;
		}
		
		public function KinectMonsterController()
		{
			initMaterials();
			initMesh();
			initAnimation();
		}
		
		private function initMaterials() : void
		{
			_bodyMaterial = new BitmapMaterial(new BodyAlbedo().bitmapData);
			_bodyMaterial.gloss = 20;
			_bodyMaterial.specular = 1.5;
			_bodyMaterial.ambientColor = 0x505060;
			_bodyMaterial.specularMap = new BodySpec().bitmapData;
			_bodyMaterial.normalMap = new BodyNorms().bitmapData;
		}
		
		private function initMesh() : void
		{
			_mesh = Mesh(ResourceManager.instance.getResource("assets/" + MD5_DIR + "/" + MESH_NAME + ".md5mesh"));
			_mesh.material = _bodyMaterial;
		}
		
		private function initAnimation() : void
		{
			_controller = KinectAnimator(_mesh.animationController);
			_controller.play();
			_mesh.rotationY = 90;
		}
		
	}
}