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
#include <CGAL/Small_side_angle_bisector_decomposition_2.h>
#include <CGAL/minkowski_sum_2.h>
#include <CGAL/Boolean_set_operations_2.h>


// -------------------------------------------------------------------------- //
typedef CGAL::Polygon_triangulation_decomposition_2<EK>     PTD;
typedef CGAL::Polygon_vertical_decomposition_2<EK>          PVD;
typedef CGAL::Small_side_angle_bisector_decomposition_2<EK> SSABD;

// -------------------------------------------------------------------------- //
void Message(const std::string&);

Polygon makePolygon(const Rcpp::NumericMatrix&);

Polygon2WithHoles makePolygonWithHoles(
  const Rcpp::NumericMatrix&, const Rcpp::List&
);

template <typename PolygonT>
Rcpp::NumericMatrix getVertices(const PolygonT&);

void checkPWH(const Polygon2WithHoles&);

Rcpp::List returnPolygonWithHoles(const Polygon2WithHoles&);

Rcpp::List Intersection(const Polygon2WithHoles&, const Polygon2WithHoles&);
Rcpp::List Subtract(const Polygon2WithHoles&, const Polygon2WithHoles&);
Rcpp::List Symdiff(const Polygon2WithHoles&, const Polygon2WithHoles&);
Rcpp::List Union(const Polygon2WithHoles&, const Polygon2WithHoles&);

Polygon2WithHoles polygonToPolygon2WithHoles(Polygon&);
