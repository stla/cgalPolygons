#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

class CGALpolygonWithHoles {
public:
  Polygon2WithHoles polygonwh;

  CGALpolygonWithHoles(
    const Rcpp::NumericMatrix outer, const Rcpp::List holes
  )
    : polygonwh(makePolygonWithHoles(outer, holes)) {}

  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  Rcpp::NumericMatrix boundingBox() {
    CGAL::Bbox_2 bbox = polygonwh.bbox();
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
  Rcpp::List convexPartsT() {
    
    PTD decomposition;
    std::list<Polygon2> convexParts;
    decomposition(polygonwh, std::back_inserter(convexParts));

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
    for(Polygon2 cpolygon : convexParts) {
      Out(i++) = getVertices<Polygon2>(cpolygon);
    }
    
    return Out;
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  void print() {
    int nholes = polygonwh.number_of_holes();
    if(nholes == 0) {
      Rcpp::Rcout << "Polygon with zero hole.\n";
    } else if(nholes == 1) {
      Rcpp::Rcout << "Polygon with one hole.\n";
    } else {
      Rcpp::Rcout << "Polygon with " << nholes << " holes.\n";
    }
  }
  
};