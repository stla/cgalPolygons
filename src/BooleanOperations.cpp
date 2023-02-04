#ifndef _HEADER_
#include "cgalPolygons.h"
#endif


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Rcpp::List Intersection(
  const Polygon2WithHoles& plg1, const Polygon2WithHoles& plg2 
) {
  checkPWH(plg1);
  checkPWH(plg2);
  std::vector<Polygon2WithHoles> Plgs;
  CGAL::intersection(plg1, plg2, std::back_inserter(Plgs));
  int npgns = std::distance(Plgs.begin(), Plgs.end());
  if(npgns == 0) {
    Message("The intersection is empty.");
    return Rcpp::List::create();
  } else if(npgns == 1) {
    Message("The intersection consists in one polygon.");
    int nholes = Plgs[0].number_of_holes();
    if(nholes == 0) {
      Message("It has no hole.");
    } else if(nholes == 1) {
      Message("It has one hole.");
    } else {
      Message("It has " + std::to_string(nholes) + " holes.");
    }
  } else {
    Message("The intersection consists in " + 
              std::to_string(npgns) + " polygons.");
  }
  Rcpp::List out(npgns);
  for(int i = 0; i < npgns; i++) {
    out(i) = returnPolygonWithHoles(Plgs[i]);
    if(npgns > 1) {
      int nholes = Plgs[i].number_of_holes();
      if(nholes == 0) {
        Message("Polygon " + std::to_string(i+1) + " has no hole.");
      } else if(nholes == 1) {
        Message("Polygon " + std::to_string(i+1) + " has one hole.");
      } else {
        Message("Polygon " + std::to_string(i+1) + " has " + 
                  std::to_string(nholes) + " holes.");
      }
    }
  }
  return out;
}