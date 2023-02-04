#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

#include "MODULE_POLYGON.h"

RCPP_MODULE(class_CGALpolygon) {
  using namespace Rcpp; 
  class_<CGALpolygon>("CGALpolygon")
    .constructor<const NumericMatrix>()
    .constructor<XPtr<Polygon>, const bool>()
    .field("xptr", &CGALpolygon::xptr)
    .method("approxConvexParts", &CGALpolygon::approxConvexParts)
    .method("area", &CGALpolygon::area)
    .method("boolop_intersection", &CGALpolygon::boolop_intersection)
    .method("boolop_subtract", &CGALpolygon::boolop_subtract)
    .method("boolop_subtract2", &CGALpolygon::boolop_subtract2)
    .method("boolop_symdiff", &CGALpolygon::boolop_symdiff)
    .method("boolop_union", &CGALpolygon::boolop_union)
    .method("boundingBox", &CGALpolygon::boundingBox)
    .method("greeneApproxConvexParts", &CGALpolygon::greeneApproxConvexParts)
    .method("isCWO", &CGALpolygon::isCWO)
    .method("isCCWO", &CGALpolygon::isCCWO)
    .method("isConvex", &CGALpolygon::isConvex)
    .method("isSimple", &CGALpolygon::isSimple)
    .method("optimalConvexParts", &CGALpolygon::optimalConvexParts)
    .method("print", &CGALpolygon::print)
    .method("reverseOrientation", &CGALpolygon::reverseOrientation)
    .method("whereIs", &CGALpolygon::whereIs);
}