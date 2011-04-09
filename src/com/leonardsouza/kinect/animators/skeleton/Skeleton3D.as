package com.leonardsouza.kinect.animators.skeleton
{
	import com.leonardsouza.kinect.util.Vector3DSmoother;
	
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	public class Skeleton3D
	{
		
		public var userID:uint;
		
		public var head:Vector3D;
		public var neck:Vector3D;
		public var waist:Vector3D;
		public var torso:Vector3D;
		
		public var leftCollar:Vector3D;
		public var leftShoulder:Vector3D;
		public var leftElbow:Vector3D;
		public var leftWrist:Vector3D;
		public var leftHand:Vector3D;
		public var leftFingertip:Vector3D;
		
		public var rightCollar:Vector3D;
		public var rightShoulder:Vector3D;
		public var rightElbow:Vector3D;
		public var rightWrist:Vector3D;
		public var rightHand:Vector3D;
		public var rightFingertip:Vector3D;		

		public var leftHip:Vector3D;
		public var leftKnee:Vector3D;
		public var leftAnkle:Vector3D;
		public var leftFoot:Vector3D;
		
		public var rightHip:Vector3D;
		public var rightKnee:Vector3D;
		public var rightAnkle:Vector3D;
		public var rightFoot:Vector3D;
		
		private var headSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var neckSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var waistSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var torsoSmoother:Vector3DSmoother = new Vector3DSmoother();
		
		private var leftCollarSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftShoulderSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftElbowSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftWristSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftHandSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftFingertipSmoother:Vector3DSmoother = new Vector3DSmoother();
		
		private var rightCollarSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightShoulderSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightElbowSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightWristSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightHandSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightFingertipSmoother:Vector3DSmoother = new Vector3DSmoother();		
		
		private var leftHipSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftKneeSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftAnkleSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var leftFootSmoother:Vector3DSmoother = new Vector3DSmoother();
		
		private var rightHipSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightKneeSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightAnkleSmoother:Vector3DSmoother = new Vector3DSmoother();
		private var rightFootSmoother:Vector3DSmoother = new Vector3DSmoother();
		
		public function Skeleton3D(initialize:Boolean = true)
		{
			if (initialize) initVariables();
		}

		public function updateFromByteArray(ba:ByteArray):void
		{
			userID = ba.readInt();
			
			headSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			head.setTo(headSmoother.x.average, headSmoother.y.average, headSmoother.z.average);
			
			neckSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			neck.setTo(neckSmoother.x.average, neckSmoother.y.average, neckSmoother.z.average);
			
			waistSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			waist.setTo(waistSmoother.x.average, waistSmoother.y.average, waistSmoother.z.average);
			
			torsoSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			torso.setTo(torsoSmoother.x.average, torsoSmoother.y.average, torsoSmoother.z.average);
			
			leftCollar.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			
			leftShoulderSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			leftShoulder.setTo(leftShoulderSmoother.x.average, leftShoulderSmoother.y.average, leftShoulderSmoother.z.average);
			
			leftElbow.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			leftWrist.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			
			leftHandSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			leftHand.setTo(leftHandSmoother.x.average, leftHandSmoother.y.average, leftHandSmoother.z.average);
			
			leftFingertip.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			
			rightCollar.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			
			rightShoulderSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			rightShoulder.setTo(rightShoulderSmoother.x.average, rightShoulderSmoother.y.average, rightShoulderSmoother.z.average);
			
			rightElbow.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			rightWrist.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			
			rightHandSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			rightHand.setTo(rightHandSmoother.x.average, rightHandSmoother.y.average, rightHandSmoother.z.average);
			
			rightFingertip.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat());			

			leftHipSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			leftHip.setTo(leftHipSmoother.x.average, leftHipSmoother.y.average, leftHipSmoother.z.average);
			
			leftKneeSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			leftKnee.setTo(leftKneeSmoother.x.average, leftKneeSmoother.y.average, leftKneeSmoother.z.average);
			
			leftAnkle.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			
			leftFootSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			leftFoot.setTo(leftFootSmoother.x.average, leftFootSmoother.y.average, leftFootSmoother.z.average);

			rightHipSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			rightHip.setTo(rightHipSmoother.x.average, rightHipSmoother.y.average, rightHipSmoother.z.average);
			
			rightKneeSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			rightKnee.setTo(rightKneeSmoother.x.average, rightKneeSmoother.y.average, rightKneeSmoother.z.average);
			
			rightAnkle.setTo(ba.readFloat(), ba.readFloat(), ba.readFloat()); // No need to smooth right now, since it is not passed from the Kinect
			
			rightFootSmoother.updateSample(ba.readFloat(), ba.readFloat(), ba.readFloat());
			rightFoot.setTo(rightFootSmoother.x.average, rightFootSmoother.y.average, rightFootSmoother.z.average);
		}
		
		protected function initVariables():void
		{
			head = new Vector3D();
			neck = new Vector3D();
			waist = new Vector3D();
			torso = new Vector3D();
			
			leftCollar = new Vector3D();
			leftShoulder = new Vector3D();
			leftElbow = new Vector3D();
			leftWrist = new Vector3D();;
			leftHand = new Vector3D();
			leftFingertip = new Vector3D();
			
			rightCollar = new Vector3D();
			rightShoulder = new Vector3D();
			rightElbow = new Vector3D();
			rightWrist = new Vector3D();
			rightHand = new Vector3D();
			rightFingertip = new Vector3D();	
			
			leftHip = new Vector3D();
			leftKnee = new Vector3D();
			leftAnkle = new Vector3D();
			leftFoot = new Vector3D();
			
			rightHip = new Vector3D();
			rightKnee = new Vector3D();
			rightAnkle = new Vector3D();
			rightFoot = new Vector3D();
		}
	
	}
}