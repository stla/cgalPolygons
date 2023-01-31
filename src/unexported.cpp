#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

Polygon makePolygon(const Rcpp::NumericMatrix pts) {
  Polygon plg;
  int npts = pts.ncol();
  for(int i = 0; i < npts; i++) {
    Rcpp::NumericVector pt = pts(Rcpp::_, i);
    plg.push_back(Point(pt(0), pt(1)));
  }
  return plg;
}
