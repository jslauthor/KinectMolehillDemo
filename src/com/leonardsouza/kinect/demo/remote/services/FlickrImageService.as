package com.leonardsouza.kinect.demo.remote.services
{
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.Photo;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.adobe.webapis.flickr.methodgroups.Photos;
	import com.leonardsouza.kinect.demo.model.ImageModel;
	import com.leonardsouza.kinect.demo.signals.BitmapReady;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;
	
	import spark.components.Image;
	import spark.primitives.BitmapImage;
	
	public class FlickrImageService extends Actor implements IImageService
	{

		[Inject]
		public var imageModel:ImageModel;
		
		private var service:FlickrService;
		private var photos:Photos;
		
		protected static const FLICKR_API_KEY:String = "516ab798392cb79523691e6dd79005c2";
		protected static const FLICKR_SECRET:String = "8f7e19a3ae7a25c9";
		
		protected var _loaders:Vector.<Loader>;
		
		public function FlickrImageService()
		{
			service = new FlickrService(FLICKR_API_KEY);
		}
		
		public function loadGallery(numberOfImages:uint, searchTerm:String = null):void
		{
			service.addEventListener(FlickrResultEvent.INTERESTINGNESS_GET_LIST, handleSearchResult);
			service.interestingness.getList(null, "", numberOfImages)
		}
		
		protected function handleSearchResult(event:FlickrResultEvent):void
		{
			processFlickrPhotoResults(event.data.photos.photos);
		}
		
		protected function processFlickrPhotoResults(results:Array):void
		{
			imageModel.resetBitmaps();
			resetImages();
			
			var index:uint = 0;
			for each (var photo:Photo in results)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function f():void { trace('ah'); });
				loader.load(new URLRequest('http://farm' + photo.farmID + '.static.flickr.com/' + photo.server + '/' + photo.id + '_' + photo.secret + '_b.jpg'));
				_loaders.push(loader);
				index++;
			}
		}
		
		protected function resetImages():void
		{
			for each (var loader:Loader in _loaders)
			{
				loader.removeEventListener(Event.COMPLETE, onImageLoaded);
			}
			_loaders = new Vector.<Loader>();
		}
		
		protected function onImageLoaded(event:Event):void
		{
			if (!LoaderInfo(event.currentTarget).content is Bitmap) return;
			imageModel.addBitmap(Bitmap(LoaderInfo(event.currentTarget).content).bitmapData);
		}
		
	}
}