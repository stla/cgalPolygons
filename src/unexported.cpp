#ifndef _HEADER_
#include "cgalPolygons.h"
#endif


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
void Message(const std::string& msg) {
  SEXP rmsg = Rcpp::wrap(msg);
  Rcpp::message(rmsg);
}


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Polygon makePolygon(const Rcpp::NumericMatrix& pts) {
  Polygon plg;
  int npts = pts.ncol();
  for(int i = 0; i < npts; i++) {
    Rcpp::NumericVector pt = pts(Rcpp::_, i);
    plg.push_back(Point(pt(0), pt(1)));
  }
  return plg;
}


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Rcpp::NumericMatrix getVertices(const Polygon& polygon) {
  const int nverts = polygon.size();
  Rcpp::NumericMatrix Pts(2, nverts);
  int i = 0;
  for(
    VertexIterator vi = polygon.vertices_begin(); 
    vi != polygon.vertices_end(); ++vi
  ) {
    Point vert = *vi;
    Rcpp::NumericVector pt = 
      {CGAL::to_double<EK::FT>(vert.x()), CGAL::to_double<EK::FT>(vert.y())};
    Pts(Rcpp::_, i++) = pt;
  }
  return Rcpp::transpose(Pts);
}

