package com.leonardsouza.kinect.demo.view.mediators
{
	import com.leonardsouza.kinect.animators.skeleton.Skeleton3D;
	import com.leonardsouza.kinect.demo.model.SkeletonModel;
	import com.leonardsouza.kinect.demo.model.enums.KinectServerEventTypes;
	import com.leonardsouza.kinect.demo.remote.vo.GestureVO;
	import com.leonardsouza.kinect.demo.remote.vo.UserStatusVO;
	import com.leonardsouza.kinect.demo.signals.GestureUpdate;
	import com.leonardsouza.kinect.demo.signals.UserSkeletonUpdate;
	import com.leonardsouza.kinect.demo.signals.UserUpdate;
	
	import flash.events.DatagramSocketDataEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.core.FlexGlobals;
	import mx.managers.FocusManager;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class KinectMolehillMediator extends Mediator
	{
		
		[Inject]
		public var view:KinectMolehill;
		
		[Inject]
		public var userSkeletonUpdate:UserSkeletonUpdate; 
		
		[Inject]
		public var userUpdate:UserUpdate; 
		
		[Inject]
		public var gestureUpdate:GestureUpdate; 
		
		[Inject]
		public var skeletonModel:SkeletonModel; 
		
		private var datagramSocket:DatagramSocket;
		
		public function KinectMolehillMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			initialize();
		}
		
		public function initialize():void
		{
			datagramSocket = new DatagramSocket();
			
			if( datagramSocket.bound ) 
			{
				datagramSocket.close();
				datagramSocket = new DatagramSocket();
			}
			
			datagramSocket.bind(3131, "127.0.0.1");
			datagramSocket.addEventListener(DatagramSocketDataEvent.DATA, dataReceived);
			datagramSocket.receive();
		}
		
		private function dataReceived( event:DatagramSocketDataEvent ):void
		{
			if (event.data.bytesAvailable > 0)
			{
				event.data.endian = Endian.LITTLE_ENDIAN;
				event.data.position = 0;
			} else { return; }
			
			var eventType:uint = event.data.readByte();
			var eventAction:uint = event.data.readByte();
			
			switch (eventType)
			{
				case KinectServerEventTypes.SKELETAL_EVENT:
					switch (eventAction)
					{
						case KinectServerEventTypes.USER_SKELETON_UPDATE:
							var id:uint = event.data.readInt();
							event.data.position -= 4;
							
							if (id-1 > SkeletonModel.MAX_SKELETONS) return; 
							
							skeletonModel.skeletons[id-1].updateFromByteArray(event.data);
							userSkeletonUpdate.dispatch(skeletonModel.skeletons[id-1]);
							break;
						default: break;
					}
					break;
				case KinectServerEventTypes.GESTURE_EVENT:
					switch (eventAction)
					{
						case KinectServerEventTypes.GESTURE_RECOGNIZED:
							var gestureType:uint = event.data.readInt();
							var vec3d:Vector3D = new Vector3D(event.data.readFloat(), event.data.readFloat(), event.data.readFloat());
							var gesture:GestureVO = new GestureVO();
							gesture.type = gestureType;
							gesture.location = vec3d;
							gestureUpdate.dispatch(gesture);
							break;
						default: break;
					}
					break;
				case KinectServerEventTypes.USER_EVENT:
					var userStatus:UserStatusVO = new UserStatusVO(event.data.readInt(), eventAction);
					userUpdate.dispatch(userStatus);
					break;
				default:
					break;
			}
		}
		
	}
}