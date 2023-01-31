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
  void print() {
    Rcpp::Rcout << "Polygon with " << polygon.size() << " vertices.\n";
  }
  
};