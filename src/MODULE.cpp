#ifndef _HEADER_
#include "cgalPolygons.h"
#endif

#include "MODULE.h"

RCPP_MODULE(class_CGALpolygon) {
  using namespace Rcpp;
  class_<CGALpolygon>("CGALpolygon")
      .constructor<const NumericMatrix>()
      .constructor<XPtr<Polygon>, const bool>()
      .field("xptr", &CGALpolygon::xptr)
      .method("area", &CGALpolygon::area)
      .method("boundingBox", &CGALpolygon::boundingBox)
      .method("isCWO", &CGALpolygon::isCWO)
      .method("isCCWO", &CGALpolygon::isCCWO)
      .method("isConvex", &CGALpolygon::isConvex)
      .method("isSimple", &CGALpolygon::isSimple)
      .method("print", &CGALpolygon::print)
      .method("reverseOrientation", &CGALpolygon::reverseOrientation)
      .method("whereIs", &CGALpolygon::whereIs);
}