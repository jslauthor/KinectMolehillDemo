package com.leonardsouza.kinect.animators
{
	
	import away3d.animators.AnimatorBase;
	import away3d.arcane;
	
	import flash.geom.Vector3D;
	
	use namespace arcane;
	
	public class KinectAnimator extends AnimatorBase
	{
		public function KinectAnimator()
		{
			super();
		}
		
		public function play():void
		{
		 	super.start();
		}
		
		override arcane function updateAnimation(dt : uint) : void
		{

		}
	}
}