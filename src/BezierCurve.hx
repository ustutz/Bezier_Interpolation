package;

/**
 * ...
 * from
 * http://stackoverflow.com/questions/5883264/interpolating-values-between-interval-interpolation-as-per-bezier-curve
 */
class BezierCurve {
	
	var p0:Point;
	var p1:Point;
	var p2:Point;
	var p3:Point;

	public function new( p0:Point, p1:Point, p2:Point, p3:Point ) {
		
		this.p3 = p3;
		this.p2 = p2;
		this.p1 = p1;
		this.p0 = p0;
	}
	
	public function getY( x:Float ):Null<Float> {
		
        // Determine t
		var t:Float;
		if ( x == p0.x ) {
           // Handle corner cases explicitly to prevent rounding errors
			t = 0;
		} else if ( x == p3.x ) {
			t = 1;
		} else {
            // Calculate t
			var a = -p0.x + 3 * p1.x - 3 * p2.x + p3.x;
			var b = 3 * p0.x - 6 * p1.x + 3 * p2.x;
			var c = -3 * p0.x + 3 * p1.x;
			var d = p0.x - x;
			var tTemp = SolveCubic( a, b, c, d );
			if ( tTemp == null ) return null;
			t = tTemp;
		}
		
        // Calculate y from t
        return cubed( 1 - t ) * p0.y
            + 3 * t * squared( 1 - t ) * p1.y
            + 3 * squared( t ) * ( 1 - t ) * p2.y
            + cubed( t ) * p3.y;
	}
	
    // Solves the equation ax³+bx²+cx+d = 0 for x ϵ ℝ
    // and returns the first result in [0, 1] or null.
	
	function SolveCubic( a:Float, b:Float, c:Float, d:Float ):Null<Float> {
		
		if ( a == 0 ) return SolveQuadratic( b, c, d );
		if ( d == 0 ) return 0;
		
		b /= a;
        c /= a;
        d /= a;
        var q = ( 3.0 * c - squared( b ) ) / 9.0;
        var r = ( -27.0 * d + b * ( 9.0 * c - 2.0 * squared( b ) ) ) / 54.0;
        var disc = cubed( q ) + squared( r );
        var term1 = b / 3.0;
        
		if ( disc > 0 ) {
            var s = r + Math.sqrt( disc );
            s = ( s < 0 ) ? -cubicRoot( -s ) : cubicRoot( s );
            var t = r - Math.sqrt( disc );
            t = ( t < 0 ) ? -cubicRoot( -t ) : cubicRoot( t );

            var result = -term1 + s + t;
            if ( result >= 0 && result <= 1 ) return result;
        } else if ( disc == 0 ) {
            var r13 = ( r < 0 ) ? -cubicRoot( -r ) : cubicRoot( r );

            var result = -term1 + 2.0 * r13;
            if ( result >= 0 && result <= 1 ) return result;

            result = -( r13 + term1 );
            if ( result >= 0 && result <= 1 ) return result;
        } else {
            q = -q;
            var dum1 = q * q * q;
            dum1 = Math.acos( r / Math.sqrt( dum1 ) );
            var r13 = 2.0 * Math.sqrt( q );

            var result = -term1 + r13 * Math.cos( dum1 / 3.0 );
            if ( result >= 0 && result <= 1 ) return result;

            result = -term1 + r13 * Math.cos( ( dum1 + 2.0 * Math.PI ) / 3.0 );
            if ( result >= 0 && result <= 1 ) return result;

            result = -term1 + r13 * Math.cos( ( dum1 + 4.0 * Math.PI ) / 3.0 );
            if ( result >= 0 && result <= 1 ) return result;
        }

        return null;
    }
	
    // Solves the equation ax² + bx + c = 0 for x ϵ ℝ
    // and returns the first result in [0, 1] or null.
    function SolveQuadratic( a:Float, b:Float, c:Float ):Null<Float> {
        var result = ( -b + Math.sqrt( squared( b ) - 4 * a * c ) ) / ( 2 * a );
        if ( result >= 0 && result <= 1 ) return result;

        result = ( -b - Math.sqrt( squared( b ) - 4 * a * c ) ) / ( 2 * a );
        if ( result >= 0 && result <= 1 ) return result;

        return null;
    }

	function squared( f:Float ):Float { return f * f; }

    function cubed( f:Float ):Float { return f * f * f; }

	function cubicRoot( f:Float ):Float { return Math.pow( f, 1.0 / 3.0 ); }
}

