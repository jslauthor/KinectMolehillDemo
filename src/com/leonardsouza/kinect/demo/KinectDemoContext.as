package com.leonardsouza.kinect.demo
{
	import away3d.animators.skeleton.Skeleton;
	
	import com.leonardsouza.kinect.demo.controller.LoadFlickrGalleryCommand;
	import com.leonardsouza.kinect.demo.model.ImageModel;
	import com.leonardsouza.kinect.demo.model.SkeletonModel;
	import com.leonardsouza.kinect.demo.remote.services.FlickrImageService;
	import com.leonardsouza.kinect.demo.remote.services.IImageService;
	import com.leonardsouza.kinect.demo.signals.BitmapReady;
	import com.leonardsouza.kinect.demo.signals.GestureUpdate;
	import com.leonardsouza.kinect.demo.signals.HandsUpdate;
	import com.leonardsouza.kinect.demo.signals.LoadFlickrGallery;
	import com.leonardsouza.kinect.demo.signals.UserSkeletonUpdate;
	import com.leonardsouza.kinect.demo.signals.UserUpdate;
	import com.leonardsouza.kinect.demo.view.components.MediaWallView;
	import com.leonardsouza.kinect.demo.view.components.SkeletonHandsView;
	import com.leonardsouza.kinect.demo.view.components.UserStatusView;
	import com.leonardsouza.kinect.demo.view.mediators.KinectMolehillMediator;
	import com.leonardsouza.kinect.demo.view.mediators.MediaWallViewMediator;
	import com.leonardsouza.kinect.demo.view.mediators.SkeletonHandsViewMediator;
	import com.leonardsouza.kinect.demo.view.mediators.UserStatusViewMediator;
	
	import flash.display.DisplayObjectContainer;
	
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.SignalContext;
	import org.swiftsuspenders.Injector;
	
	public class KinectDemoContext extends SignalContext
	{

		override public function startup():void
		{
			// Map singleton Signals
			injector.mapSingleton(UserSkeletonUpdate);
			injector.mapSingleton(UserUpdate);
			injector.mapSingleton(GestureUpdate);
			injector.mapSingleton(HandsUpdate);
			injector.mapSingleton(BitmapReady);
			
			// Map remote services
			injector.mapSingletonOf(IImageService, FlickrImageService);
			
			// Map Models
			injector.mapSingleton(SkeletonModel);
			injector.mapSingleton(ImageModel);

			// Map signals to commands
			signalCommandMap.mapSignalClass(LoadFlickrGallery, LoadFlickrGalleryCommand);

			// Map views
			mediatorMap.mapView(KinectMolehill, KinectMolehillMediator);
			mediatorMap.mapView(UserStatusView, UserStatusViewMediator);
			mediatorMap.mapView(SkeletonHandsView, SkeletonHandsViewMediator);
			mediatorMap.mapView(MediaWallView, MediaWallViewMediator);
		}
		
	}
}