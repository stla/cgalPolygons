#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

#include "MODULE_POLYGONWITHHOLES.h"

RCPP_MODULE(class_CGALpolygonWithHoles) {
  using namespace Rcpp;
  class_<CGALpolygonWithHoles>("CGALpolygonWithHoles")
    .constructor<const NumericMatrix, const List>()
    .method("boundingBox", &CGALpolygonWithHoles::boundingBox)
    .method("convexPartsT", &CGALpolygonWithHoles::convexPartsT)
    .method("convexPartsV", &CGALpolygonWithHoles::convexPartsV)
    .method("print", &CGALpolygonWithHoles::print);
}