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
      Out(i++) = getVertices2(cpolygon);
    }
    
    return Out;
  }
  
  
  // ------------------------------------------------------------------------ //
  // ------------------------------------------------------------------------ //
  void print() {
    Rcpp::Rcout << "Polygon with " 
                << polygonwh.number_of_holes() << " holes.\n";
  }
  
};