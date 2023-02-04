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
    .method("area", &CGALpolygonWithHoles::area)
    .method("boolop_intersection", &CGALpolygonWithHoles::boolop_intersection)
    .method("boolop_subtract", &CGALpolygonWithHoles::boolop_subtract)
    .method("boolop_symdiff", &CGALpolygonWithHoles::boolop_symdiff)
    .method("boolop_union", &CGALpolygonWithHoles::boolop_union)
    .method("boolop_intersection2", &CGALpolygonWithHoles::boolop_intersection2)
    .method("boolop_subtract2", &CGALpolygonWithHoles::boolop_subtract2)
    .method("boolop_symdiff2", &CGALpolygonWithHoles::boolop_symdiff2)
    .method("boolop_union2", &CGALpolygonWithHoles::boolop_union2)
    .method("boundingBox", &CGALpolygonWithHoles::boundingBox)
    .method("convexPartsT", &CGALpolygonWithHoles::convexPartsT)
    .method("convexPartsV", &CGALpolygonWithHoles::convexPartsV)
    .method("minkowskiC", &CGALpolygonWithHoles::minkowskiC)
    .method("minkowskiO", &CGALpolygonWithHoles::minkowskiO)
    .method("minkowskiT", &CGALpolygonWithHoles::minkowskiT)
    .method("minkowskiV", &CGALpolygonWithHoles::minkowskiV)
    .method("print", &CGALpolygonWithHoles::print);
}