#include <cstdlib> // for std::exit()
#include <iostream>
#include <CGAL/Exact_predicates_exact_constructions_kernel.h>
#include <CGAL/Partition_traits_2.h>
#include <CGAL/partition_2.h>
#include <CGAL/Gps_segment_traits_2.h>
#include <CGAL/Boolean_set_operations_2.h>

typedef CGAL::Exact_predicates_exact_constructions_kernel EK;
typedef CGAL::Partition_traits_2<EK>                      Traits;
typedef Traits::Point_2                                   Point;
typedef Traits::Polygon_2                                 Polygon;
typedef CGAL::Gps_segment_traits_2<EK>                    Traits2;
typedef Traits2::Point_2                                  Point2;
typedef Traits2::Polygon_2                                Polygon2;
typedef Traits2::Polygon_with_holes_2                     Polygon2WithHoles;

// circle centered at (x,y) with radius r
Polygon Circle(double x, double y, double r) {
  Polygon plg;
  double step = 2.0 / 99.0;
  for(int i = 1; i < 100; i++) {
    double t = i * step;
    double xx = x + r * cospi(t);
    double yy = y + r * sinpi(t);
    plg.push_back(Point(xx, yy));
  }
  return plg;
}

Polygon2 polygonToPolygon2(const Polygon& polygon) {
  Polygon2 polygon2;
  for(
    Polygon::Vertex_iterator vi = polygon.vertices_begin(); 
    vi != polygon.vertices_end(); ++vi
  ) {
    polygon2.push_back(*vi);
  }
  return polygon2;
}

Polygon2WithHoles polygonToPolygon2WithHoles(Polygon& polygon) {
  if(!polygon.is_counterclockwise_oriented()) {
    polygon.reverse_orientation();
  }
  Polygon2 outer = polygonToPolygon2(polygon);
  std::vector<Polygon2> holes(0);
  Polygon2WithHoles plgwh(outer, holes.begin(), holes.end());
  return plgwh;
}

std::vector<Polygon2WithHoles> Intersection(
    const Polygon2WithHoles& plg1, const Polygon2WithHoles& plg2 
) {
  Traits2 traits;
  if(!CGAL::is_valid_polygon_with_holes(plg1, traits)){
    std::cout << "Invalid polygon with holes.\n";
    std::exit(0);
  }
  if(!CGAL::is_valid_polygon_with_holes(plg2, traits)){
    std::cout << "Invalid polygon with holes.\n";
    std::exit(0);
  }
  std::vector<Polygon2WithHoles> Plgs;
  CGAL::intersection(plg1, plg2, std::back_inserter(Plgs));
  return Plgs;
}

int main() {
  Polygon plg1 = Circle(-1, 0, 1.25);
  Polygon plg2 = Circle(1, 0, 1.25);
  Polygon2WithHoles plg1wh = polygonToPolygon2WithHoles(plg1);
  Polygon2WithHoles plg2wh = polygonToPolygon2WithHoles(plg2);
  std::vector<Polygon2WithHoles> Plgs = Intersection(plg1wh, plg2wh);
  int npgns = std::distance(Plgs.begin(), Plgs.end());
  if(npgns == 0) {
    std::cout << "The intersection is empty.\n";
  } else if(npgns == 1) {
    std::cout << "The intersection consists in one polygon.\n";
    int nholes = Plgs[0].number_of_holes();
    if(nholes == 0) {
      std::cout << "It doesn't have any hole.\n";
    } else if(nholes == 1) {
      std::cout << "It has one hole.\n";
    } else {
      std::string msg = "It has " + std::to_string(nholes) + " holes.\n";
      std::cout << msg;
    }
  } else {
    std::string msg = "The intersection consists in " + 
      std::to_string(npgns) + " polygons.\n";
    std::cout << msg;
  }
  return 1;
}