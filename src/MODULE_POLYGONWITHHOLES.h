#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

class CGALpolygonWithHoles {
public:
  Polygon2WithHoles polygonwh;
  Rcpp::XPtr<Polygon2WithHoles> xptr;

  CGALpolygonWithHoles(
    const Rcpp::NumericMatrix outer, const Rcpp::List holes
  )
    : polygonwh(makePolygonWithHoles(outer, holes)),
      xptr(Rcpp::XPtr<Polygon2WithHoles>(&polygonwh, false)) {}

  CGALpolygonWithHoles(Rcpp::XPtr<Polygon2WithHoles> xptr_)
    : polygonwh(*(xptr_.get())), 
      xptr(Rcpp::XPtr<Polygon2WithHoles>(&polygonwh, false)) {}
  
  
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

    checkPWH(polygonwh);
    
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
  Rcpp::List convexPartsV() {
    
    checkPWH(polygonwh);
    
    PVD decomposition;
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
  Rcpp::List minkowskiC(Rcpp::XPtr<Polygon2WithHoles> polygonwh2XPtr) {
    
    Polygon2WithHoles polygonwh2 = *(polygonwh2XPtr.get());
    
    Polygon2WithHoles msum = 
      CGAL::minkowski_sum_by_reduced_convolution_2(polygonwh, polygonwh2);
    
    Polygon2 outer = msum.outer_boundary();
    Rcpp::NumericMatrix Outer = getVertices<Polygon2>(outer);
    
    int nholes = msum.number_of_holes();
    Rcpp::List Holes(nholes);
    int h = 0;
    for(auto hit = msum.holes_begin(); hit != msum.holes_end(); ++hit) {
      Polygon2 hole = *hit;
      Holes(h++) = getVertices<Polygon2>(hole);
    }

    return Rcpp::List::create(
      Rcpp::Named("outer") = Outer,
      Rcpp::Named("holes") = Holes
    );
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