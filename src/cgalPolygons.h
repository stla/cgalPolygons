#ifndef _HEADER_
#define _HEADER_
#endif

#include <Rcpp.h>
#define CGAL_EIGEN3_ENABLED 1
#include "cgalPolygons_types.h"
#include <CGAL/Bbox_2.h>
#include <CGAL/enum.h>
#include <CGAL/Polygon_triangulation_decomposition_2.h>
#include <CGAL/Polygon_vertical_decomposition_2.h>

// -------------------------------------------------------------------------- //
typedef CGAL::Polygon_triangulation_decomposition_2<EK> PTD;
typedef CGAL::Polygon_vertical_decomposition_2<EK>      PVD;

// -------------------------------------------------------------------------- //
void Message(const std::string&);
Polygon makePolygon(const Rcpp::NumericMatrix&);
Polygon2WithHoles makePolygonWithHoles(
  const Rcpp::NumericMatrix&, const Rcpp::List&
);
template <typename PolygonT>
Rcpp::NumericMatrix getVertices(const PolygonT&);
