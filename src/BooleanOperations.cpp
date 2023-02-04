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
    Message("The intersection is empty.\n");
    return Rcpp::List::create();
  } else if(npgns == 1) {
    Message("The intersection consists in one polygon.\n");
  } else {
    Message("The intersection consists in " + 
              std::to_string(npgns) + " polygons.\n");
  }
  Rcpp::List out(npgns);
  for(int i = 0; i < npgns; i++) {
    out(i) = returnPolygonWithHoles(pgnsList[i]);
  }
  return out;
}