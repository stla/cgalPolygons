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
bool contains(const Polygon2& polygon1, const Polygon2& polygon2) {
  for(
    Polygon2::Vertex_iterator vi = polygon2.vertices_begin(); 
    vi != polygon2.vertices_end(); ++vi
  ) {
    Point2 vert = *vi;
    CGAL::Bounded_side side = polygon1.bounded_side(vert);
    if(side == CGAL::ON_UNBOUNDED_SIDE) {
      return false;
    }
  }
  return true;
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
  
  bool isSimple = true;
  if(!outer.is_simple()) {
    Rcpp::warning("The outer polygon is not simple.");
    isSimple = false;
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

  if(isSimple) {
    int h = 1;
    for(auto hit = holes.begin(); hit != holes.end(); ++hit) {
      Polygon2 hole = *hit;
      if(!contains(outer, hole)) {
        Rcpp::stop(
          "Hole " + std::to_string(h) + 
            " is not contained in the outer polygon."
        );
      }
      h++;
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


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Polygon2WithHoles polygonToPolygon2WithHoles(Polygon& polygon) {
  if(!polygon.is_counterclockwise_oriented()) {
    polygon.reverse_orientation();
  }
  Polygon2 outer;
  for(
    Polygon::Vertex_iterator vi = polygon.vertices_begin(); 
                             vi != polygon.vertices_end(); ++vi
  ) {
    outer.push_back(*vi);
  }
  std::vector<Polygon2> holes(0);
  Polygon2WithHoles plgwh(outer, holes.begin(), holes.end());
  return plgwh;
}