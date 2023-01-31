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
  
};