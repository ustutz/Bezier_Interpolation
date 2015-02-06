package;

import flash.display.Shape;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * http://stackoverflow.com/questions/5883264/interpolating-values-between-interval-interpolation-as-per-bezier-curve
 */

class BezierMain 
{
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		var p0 = new Point( 0, 0 );
		var p1 = new Point( 0.4, 0 );
		var p2 = new Point( 0.6, 1 );
		var p3 = new Point( 1, 1 );
		var curve = new BezierCurve( p0, p1, p2, p3 );
		
		var shape = new Shape();
		Lib.current.addChild( shape );
		shape.graphics.lineStyle(1, 0xFF0000, 1);
		shape.graphics.moveTo(0, 0);
		
		for ( i in 0...100 ) {
			var x:Float = i / 100;
			var y = curve.getY( x );

			shape.graphics.lineTo(x * 600, y * 600); 
			//trace( curve.getY( x / 100 ) );
		}
	}
	
}