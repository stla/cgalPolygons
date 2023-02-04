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
Polygon2WithHoles makePolygonWithHoles(
  const Rcpp::NumericMatrix& outerPts, const Rcpp::List& HolesPts
) {
  
  Polygon2 outer;
  {
    int npts = outerPts.ncol();
    for(int i = 0; i < npts; i++) {
      Rcpp::NumericVector pt = outerPts(Rcpp::_, i);
      outer.push_back(Point2(pt(0), pt(1)));
    }
  }
  if(!outer.is_simple()) {
    Rcpp::warning("The outer polygon is not simple.");
  }
  if(!outer.is_counterclockwise_oriented()) {
    outer.reverse_orientation();
  }
  
  int nholes = HolesPts.size();
  std::vector<Polygon2> holes(nholes);
  for(int h = 0; h < nholes; h++) {
    Rcpp::NumericMatrix holesPts = Rcpp::as<Rcpp::NumericMatrix>(HolesPts(h));
    int npts = holesPts.ncol();
    for(int i = 0; i < npts; i++) {
      Rcpp::NumericVector pt = holesPts(Rcpp::_, i);
      holes[h].push_back(Point2(pt(0), pt(1)));
    }
    if(!holes[h].is_simple()) {
      Rcpp::warning("Hole " + std::to_string(h+1) + " is not simple.");
    }
    if(!holes[h].is_clockwise_oriented()) {
      holes[h].reverse_orientation();
    }
  }
  
  Polygon2WithHoles plgwh(outer, holes.begin(), holes.end());
  return plgwh;
}


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
template <typename PolygonT>
Rcpp::NumericMatrix getVertices(const PolygonT& polygon) {
  const int nverts = polygon.size();
  Rcpp::NumericMatrix Pts(2, nverts);
  int i = 0;
  for(
    typename PolygonT::Vertex_iterator vi = polygon.vertices_begin(); 
    vi != polygon.vertices_end(); ++vi
  ) {
    Point vert = *vi;
    Rcpp::NumericVector pt = 
      {CGAL::to_double<EK::FT>(vert.x()), CGAL::to_double<EK::FT>(vert.y())};
    Pts(Rcpp::_, i++) = pt;
  }
  return Rcpp::transpose(Pts);
}

template Rcpp::NumericMatrix getVertices<Polygon>(const Polygon&);
template Rcpp::NumericMatrix getVertices<Polygon2>(const Polygon2&);


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
void checkPWH(const Polygon2WithHoles& polygonwh) {
  
  Polygon2 outer = polygonwh.outer_boundary();
  if(!outer.is_simple()) {
    Rcpp::stop("The outer polygon is not simple.");
  }
  
  int h = 1;
  for(auto hit = polygonwh.holes_begin(); hit != polygonwh.holes_end(); ++hit) {
    Polygon2 hole = *hit;
    if(!hole.is_simple()) {
      Rcpp::stop("Hole " + std::to_string(h) + " is not simple.");
    }
    if(CGAL::do_intersect(outer, hole)) {
      Rcpp::stop(
        "The outer polygon and hole " + std::to_string(h) + 
          " intersect each other."
      );
    }
    h++;
  }
  
  if(CGAL::do_intersect(polygonwh.holes_begin(), polygonwh.holes_end())) {
    Rcpp::stop("Found two holes intersecting each other");
  }
  
}


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Rcpp::List returnPolygonWithHoles(const Polygon2WithHoles& polygonwh) {
  
  Polygon2 outer = polygonwh.outer_boundary();
  Rcpp::NumericMatrix Outer = getVertices<Polygon2>(outer);
  
  int nholes = polygonwh.number_of_holes();
  Rcpp::List Holes(nholes);
  int h = 0;
  for(auto hit = polygonwh.holes_begin(); hit != polygonwh.holes_end(); ++hit) {
    Polygon2 hole = *hit;
    Holes(h++) = getVertices<Polygon2>(hole);
  }
  
  return Rcpp::List::create(
    Rcpp::Named("outer") = Outer,
    Rcpp::Named("holes") = Holes
  );
}