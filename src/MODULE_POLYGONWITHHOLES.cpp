#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

#include "MODULE_POLYGONWITHHOLES.h"

RCPP_MODULE(class_CGALpolygonWithHoles) {
  using namespace Rcpp; 
  class_<CGALpolygonWithHoles>("CGALpolygonWithHoles")
    .constructor<const NumericMatrix, const List>()
    .constructor<XPtr<Polygon2WithHoles>>()
    .field("xptr", &CGALpolygonWithHoles::xptr)
    .method("boundingBox", &CGALpolygonWithHoles::boundingBox)
    .method("convexPartsT", &CGALpolygonWithHoles::convexPartsT)
    .method("convexPartsV", &CGALpolygonWithHoles::convexPartsV)
    .method("minkowskiC", &CGALpolygonWithHoles::minkowskiC)
    .method("minkowskiT", &CGALpolygonWithHoles::minkowskiT)
    .method("minkowskiV", &CGALpolygonWithHoles::minkowskiV)
    .method("print", &CGALpolygonWithHoles::print);
}