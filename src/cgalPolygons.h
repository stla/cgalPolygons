#ifndef _HEADER_
#define _HEADER_
#endif

#include <Rcpp.h>

#define CGAL_EIGEN3_ENABLED 1

#include "cgalPolygons_types.h"

#include <CGAL/Bbox_2.h>
#include <CGAL/enum.h>


typedef Polygon::Vertex_iterator VertexIterator;


Polygon makePolygon(const Rcpp::NumericMatrix);