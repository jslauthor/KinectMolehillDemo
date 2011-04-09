package com.leonardsouza.kinect.util
{
	public class Vector3DSmoother
	{
		
		protected static const SAMPLE_SIZE:uint = 2;
		
		protected var _x:Smoother;
		protected var _y:Smoother;
		protected var _z:Smoother;
		
		public function Vector3DSmoother(size:uint = SAMPLE_SIZE):void
		{
			_x = new Smoother(size);
			_y = new Smoother(size);
			_z = new Smoother(size);
		}
		
		public function get z():Smoother
		{
			return _z;
		}

		public function set z(value:Smoother):void
		{
			_z = value;
		}

		public function get y():Smoother
		{
			return _y;
		}

		public function set y(value:Smoother):void
		{
			_y = value;
		}

		public function get x():Smoother
		{
			return _x;
		}

		public function set x(value:Smoother):void
		{
			_x = value;
		}

		public function updateSample(x:Number, y:Number, z:Number):void
		{
			this.x.sample(x);
			this.y.sample(y);
			this.z.sample(z);
		}
		
	}
}