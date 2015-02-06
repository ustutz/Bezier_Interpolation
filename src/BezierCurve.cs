using System;

public class Point {
    public Point(double x, double y) {
        X = x;
        Y = y;
    }
    public double X { get; private set; }
    public double Y { get; private set; }
}

public class BezierCurve {
    public BezierCurve(Point p0, Point p1, Point p2, Point p3) {
        P0 = p0;
        P1 = p1;
        P2 = p2;
        P3 = p3;
    }

    public Point P0 { get; private set; }
    public Point P1 { get; private set; }
    public Point P2 { get; private set; }
    public Point P3 { get; private set; }

    public double? GetY(double x) {
        // Determine t
        double t;
        if (x == P0.X) {
            // Handle corner cases explicitly to prevent rounding errors
            t = 0;
        } else if (x == P3.X) {
            t = 1;
        } else {
            // Calculate t
            double a = -P0.X + 3 * P1.X - 3 * P2.X + P3.X;
            double b = 3 * P0.X - 6 * P1.X + 3 * P2.X;
            double c = -3 * P0.X + 3 * P1.X;
            double d = P0.X - x;
            double? tTemp = SolveCubic(a, b, c, d);
            if (tTemp == null) return null;
            t = tTemp.Value;
        }

        // Calculate y from t
        return Cubed(1 - t) * P0.Y
            + 3 * t * Squared(1 - t) * P1.Y
            + 3 * Squared(t) * (1 - t) * P2.Y
            + Cubed(t) * P3.Y;
    }

    // Solves the equation ax³+bx²+cx+d = 0 for x ϵ ℝ
    // and returns the first result in [0, 1] or null.
    private static double? SolveCubic(double a, double b, double c, double d) {
        if (a == 0) return SolveQuadratic(b, c, d);
        if (d == 0) return 0;

        b /= a;
        c /= a;
        d /= a;
        double q = (3.0 * c - Squared(b)) / 9.0;
        double r = (-27.0 * d + b * (9.0 * c - 2.0 * Squared(b))) / 54.0;
        double disc = Cubed(q) + Squared(r);
        double term1 = b / 3.0;

        if (disc > 0) {
            double s = r + Math.Sqrt(disc);
            s = (s < 0) ? -CubicRoot(-s) : CubicRoot(s);
            double t = r - Math.Sqrt(disc);
            t = (t < 0) ? -CubicRoot(-t) : CubicRoot(t);

            double result = -term1 + s + t;
            if (result >= 0 && result <= 1) return result;
        } else if (disc == 0) {
            double r13 = (r < 0) ? -CubicRoot(-r) : CubicRoot(r);

            double result = -term1 + 2.0 * r13;
            if (result >= 0 && result <= 1) return result;

            result = -(r13 + term1);
            if (result >= 0 && result <= 1) return result;
        } else {
            q = -q;
            double dum1 = q * q * q;
            dum1 = Math.Acos(r / Math.Sqrt(dum1));
            double r13 = 2.0 * Math.Sqrt(q);

            double result = -term1 + r13 * Math.Cos(dum1 / 3.0);
            if (result >= 0 && result <= 1) return result;

            result = -term1 + r13 * Math.Cos((dum1 + 2.0 * Math.PI) / 3.0);
            if (result >= 0 && result <= 1) return result;

            result = -term1 + r13 * Math.Cos((dum1 + 4.0 * Math.PI) / 3.0);
            if (result >= 0 && result <= 1) return result;
        }

        return null;
    }

    // Solves the equation ax² + bx + c = 0 for x ϵ ℝ
    // and returns the first result in [0, 1] or null.
    private static double? SolveQuadratic(double a, double b, double c) {
        double result = (-b + Math.Sqrt(Squared(b) - 4 * a * c)) / (2 * a);
        if (result >= 0 && result <= 1) return result;

        result = (-b - Math.Sqrt(Squared(b) - 4 * a * c)) / (2 * a);
        if (result >= 0 && result <= 1) return result;

        return null;
    }

    private static double Squared(double f) { return f * f; }

    private static double Cubed(double f) { return f * f * f; }

    private static double CubicRoot(double f) { return Math.Pow(f, 1.0 / 3.0); }
}