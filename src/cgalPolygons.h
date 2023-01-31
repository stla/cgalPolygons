#ifndef _HEADER_
#define _HEADER_
#endif

#include <Rcpp.h>

#define CGAL_EIGEN3_ENABLED 1

#include "cgalPolygons_types.h"

#include <CGAL/Bbox_2.h>


Polygon makePolygon(const Rcpp::NumericMatrix);