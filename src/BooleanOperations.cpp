#ifndef _HEADER_
#include "cgalPolygons.h"
#endif


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
// [[Rcpp::export]]
Rcpp::List Intersection(
  Rcpp::XPtr<Polygon2WithHoles> xptr1, Rcpp::XPtr<Polygon2WithHoles> xptr2
) {
  Polygon2WithHoles pgn1 = *(xptr1.get());
  Polygon2WithHoles pgn2 = *(xptr2.get());
  std::vector<Polygon2WithHoles> pgnsList;
  CGAL::intersection(pgn1, pgn2, std::back_inserter(pgnsList));
  int npgns = std::distance(pgnsList.begin(), pgnsList.end());
  if(npgns == 0) {
    Message("The intersection is empty.");
    return Rcpp::List::create();
  } else if(npgns == 1) {
    Message("The intersection consists in one polygon.");
    int nholes = pgnsList[0].number_of_holes();
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
    out(i) = returnPolygonWithHoles(pgnsList[i]);
    if(npgns > 1) {
      int nholes = pgnsList[i].number_of_holes();
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