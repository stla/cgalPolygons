#include <CGAL/Exact_predicates_exact_constructions_kernel.h>
//#include <CGAL/Polygon_2.h>
#include <CGAL/Partition_traits_2.h>
#include <CGAL/partition_2.h>

typedef CGAL::Exact_predicates_exact_constructions_kernel EK;
//typedef EK::Point_2                                       Point;
//typedef CGAL::Polygon_2<EK>                               Polygon;
typedef CGAL::Partition_traits_2<EK>                        Traits;
typedef Traits::Point_2                                     Point;
typedef Traits::Polygon_2                                   Polygon;
