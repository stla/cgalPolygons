#ifndef _HEADER_TYPES_
#define _HEADER_TYPES_

#include <CGAL/Exact_predicates_exact_constructions_kernel.h>
#include <CGAL/Partition_traits_2.h>
#include <CGAL/partition_2.h>
#include <CGAL/Polygon_2.h>
#include <CGAL/Polygon_with_holes_2.h>

typedef CGAL::Exact_predicates_exact_constructions_kernel EK;
typedef CGAL::Partition_traits_2<EK>                      Traits;
typedef Traits::Point_2                                   Point;
typedef Traits::Polygon_2                                 Polygon;
typedef CGAL::Point_2<EK>                                 Point2;
typedef CGAL::Polygon_2<EK>                               Polygon2;               
typedef CGAL::Polygon_with_holes_2<EK>                    Polygon2WithHoles;                 

#endif
