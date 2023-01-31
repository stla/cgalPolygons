#ifndef _HEADER_
#define _HEADER_
#endif

#include <Rcpp.h>
#define CGAL_EIGEN3_ENABLED 1
#include "cgalPolygons_types.h"
#include <CGAL/Bbox_2.h>
#include <CGAL/enum.h>
#include <CGAL/Polygon_triangulation_decomposition_2.h>

// -------------------------------------------------------------------------- //
typedef Polygon::Vertex_iterator                        VertexIterator;
typedef CGAL::Polygon_triangulation_decomposition_2<EK> PTD;

// -------------------------------------------------------------------------- //
void Message(const std::string&);
Polygon makePolygon(const Rcpp::NumericMatrix&);
Rcpp::NumericMatrix getVertices(const Polygon&);
Polygon2WithHoles makePolygonWithHoles(
  const Rcpp::NumericMatrix&, const Rcpp::List&
);