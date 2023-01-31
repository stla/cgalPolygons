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
      .method("print", &CGALpolygon::print)
      .method("whereIs", &CGALpolygon::whereIs);
}