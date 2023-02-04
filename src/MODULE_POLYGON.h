#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

class CGALpolygon {
 public:
  Polygon polygon;
  Rcpp::XPtr<Polygon> xptr;

  CGALpolygon(const Rcpp::NumericMatrix vertices)
      : polygon(makePolygon(vertices)),
        xptr(Rcpp::XPtr<Polygon>(&polygon, false)) {}

  CGALpolygon(Rcpp::XPtr<Polygon> xptr_, const bool dummy)
      : polygon(*(xptr_.get())), 
        xptr(Rcpp::XPtr<Polygon>(&polygon, false)) {}


  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::List approxConvexParts() {
    
    if(!polygon.is_simple()) {
      Rcpp::stop("The polygon is not simple.");
    }
    if(!polygon.is_counterclockwise_oriented()) {
      Rcpp::stop("The polygon is not counter-clockwise oriented.");
    }
    
    std::list<Polygon> convexParts;
    
    CGAL::approx_convex_partition_2(
      polygon.vertices_begin(), polygon.vertices_end(),
      std::back_inserter(convexParts)
    );
    
    int nparts = convexParts.size();
    
    std::string msg;
    if(nparts == 1) {
      msg = "Only one convex part found.";
    } else {
      msg = "Found " + std::to_string(nparts) + " convex parts.";
    }
    Message(msg);
    
    Rcpp::List Out(nparts);
    int i = 0;
    for(Polygon cpolygon : convexParts) {
      Out(i++) = getVertices<Polygon>(cpolygon);
    }
    
    return Out;
  }


  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  double area() {
    if(!polygon.is_simple()) {
      Rcpp::stop("The polygon is not simple.");
    }
    EK::FT a = polygon.area();
    return CGAL::to_double<EK::FT>(a);
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::List boolop_intersection(Rcpp::XPtr<Polygon> plg2XPtr) {
    Polygon2WithHoles polygonwh = polygonToPolygon2WithHoles(polygon);
    Polygon plg2 = *(plg2XPtr.get());
    Polygon2WithHoles pwh2 = polygonToPolygon2WithHoles(plg2);
    return Intersection(polygonwh, pwh2);
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::List boolop_subtract(Rcpp::XPtr<Polygon> plg2XPtr) {
    Polygon2WithHoles polygonwh = polygonToPolygon2WithHoles(polygon);
    Polygon plg2 = *(plg2XPtr.get());
    Polygon2WithHoles pwh2 = polygonToPolygon2WithHoles(plg2);
    return Subtract(polygonwh, pwh2);
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::List boolop_symdiff(Rcpp::XPtr<Polygon> plg2XPtr) {
    Polygon2WithHoles polygonwh = polygonToPolygon2WithHoles(polygon);
    Polygon plg2 = *(plg2XPtr.get());
    Polygon2WithHoles pwh2 = polygonToPolygon2WithHoles(plg2);
    return Symdiff(polygonwh, pwh2);
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::List boolop_union(Rcpp::XPtr<Polygon> plg2XPtr) {
    Polygon2WithHoles polygonwh = polygonToPolygon2WithHoles(polygon);
    Polygon plg2 = *(plg2XPtr.get());
    Polygon2WithHoles pwh2 = polygonToPolygon2WithHoles(plg2);
    return Union(polygonwh, pwh2);
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::NumericMatrix boundingBox() {
    CGAL::Bbox_2 bbox = polygon.bbox();
    Rcpp::NumericVector minCorner = {bbox.xmin(), bbox.ymin()};
    Rcpp::NumericVector maxCorner = {bbox.xmax(), bbox.ymax()};
    Rcpp::NumericMatrix Corners(2, 2);
    Corners(0, Rcpp::_) = minCorner;
    Corners(1, Rcpp::_) = maxCorner;
    Rcpp::CharacterVector rownames = {"min", "max"};
    Rcpp::rownames(Corners) = rownames;
    return Corners;
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::List greeneApproxConvexParts() {
    
    if(!polygon.is_simple()) {
      Rcpp::stop("The polygon is not simple.");
    }
    if(!polygon.is_counterclockwise_oriented()) {
      Rcpp::stop("The polygon is not counter-clockwise oriented.");
    }
    
    std::list<Polygon> convexParts;
    
    CGAL::greene_approx_convex_partition_2(
      polygon.vertices_begin(), polygon.vertices_end(),
      std::back_inserter(convexParts)
    );
    
    int nparts = convexParts.size();
    
    std::string msg;
    if(nparts == 1) {
      msg = "Only one convex part found.";
    } else {
      msg = "Found " + std::to_string(nparts) + " convex parts.";
    }
    Message(msg);
    
    Rcpp::List Out(nparts);
    int i = 0;
    for(Polygon cpolygon : convexParts) {
      Out(i++) = getVertices<Polygon>(cpolygon);
    }
    
    return Out;
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  bool isCWO() {
    return polygon.is_clockwise_oriented();
  }
  

  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  bool isCCWO() {
    return polygon.is_counterclockwise_oriented();
  }

    
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  bool isConvex() {
    return polygon.is_convex();
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  bool isSimple() {
    return polygon.is_simple();
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::List optimalConvexParts() {
    
    if(!polygon.is_simple()) {
      Rcpp::stop("The polygon is not simple.");
    }
    if(!polygon.is_counterclockwise_oriented()) {
      Rcpp::stop("The polygon is not counter-clockwise oriented.");
    }
    
    std::list<Polygon> convexParts;
    
    CGAL::optimal_convex_partition_2(
      polygon.vertices_begin(), polygon.vertices_end(),
      std::back_inserter(convexParts)
    );
    
    int nparts = convexParts.size();
    
    std::string msg;
    if(nparts == 1) {
      msg = "Only one convex part found.";
    } else {
      msg = "Found " + std::to_string(nparts) + " convex parts.";
    }
    Message(msg);
    
    Rcpp::List Out(nparts);
    int i = 0;
    for(Polygon cpolygon : convexParts) {
      Out(i++) = getVertices<Polygon>(cpolygon);
    }
    
    return Out;
  }
  
    
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  void print() {
    Rcpp::Rcout << "Polygon with " << polygon.size() << " vertices.\n";
  }


  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::NumericMatrix reverseOrientation() {
    polygon.reverse_orientation();
    return getVertices<Polygon>(polygon);
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::IntegerVector whereIs(Rcpp::NumericMatrix points) {
    
    if(!polygon.is_simple()) {
      Rcpp::stop("The polygon is not simple.");
    }

    int npoints = points.ncol();
    Rcpp::IntegerVector results(npoints);
    
    for(int i = 0; i < npoints; i++) {
      Rcpp::NumericVector point = points(Rcpp::_, i);
      Point pt(point(0), point(1));
      CGAL::Bounded_side side = polygon.bounded_side(pt);
      int result = -1;
      if(side == CGAL::ON_BOUNDED_SIDE) {
        result = 1;
      } else if(side == CGAL::ON_BOUNDARY) {
        result = 0;
      }
      results(i) = result;
    }
    
    return results;
  }
  
  
};