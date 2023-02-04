#ifndef _HEADER_TYPES_
#define _HEADER_TYPES_

#include <CGAL/Exact_predicates_exact_constructions_kernel.h>
#include <CGAL/Partition_traits_2.h>
#include <CGAL/partition_2.h>
#include <CGAL/Gps_segment_traits_2.h>

typedef CGAL::Exact_predicates_exact_constructions_kernel EK;
typedef CGAL::Partition_traits_2<EK>                      Traits;
typedef Traits::Point_2                                   Point;
typedef Traits::Polygon_2                                 Polygon;
typedef CGAL::Gps_segment_traits_2<EK>                    Traits2;
typedef Traits2::Point_2                                  Point2;
typedef Traits2::Polygon_2                                Polygon2;
typedef Traits2::Polygon_with_holes_2                     Polygon2WithHoles;


#endif
