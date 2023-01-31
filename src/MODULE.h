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
  double area() {
    EK::FT a = polygon.area();
    return CGAL::to_double<EK::FT>(a);
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
  void print() {
    Rcpp::Rcout << "Polygon with " << polygon.size() << " vertices.\n";
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