#ifndef _HEADER_
#include "cgalPolygons.h"
#endif


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Rcpp::List Intersection(
  const Polygon2WithHoles& plg1, const Polygon2WithHoles& plg2 
) {
  Traits2 traits;
  if(!CGAL::is_valid_polygon_with_holes(plg1, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  if(!CGAL::is_valid_polygon_with_holes(plg2, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  std::vector<Polygon2WithHoles> Plgs;
  CGAL::intersection(plg1, plg2, std::back_inserter(Plgs));
  int npgns = std::distance(Plgs.begin(), Plgs.end());
  if(npgns == 0) {
    Message("The intersection is empty.");
    return Rcpp::List::create();
  } else if(npgns == 1) {
    Message("The intersection consists in one polygon.");
    int nholes = Plgs[0].number_of_holes();
    if(nholes == 0) {
      Message("It doesn't have any hole.");
    } else if(nholes == 1) {
      Message("It has one hole.");
    } else {
      Message("It has " + std::to_string(nholes) + " holes.");
    }
  } else {
    Message("The intersection consists in " + 
              std::to_string(npgns) + " polygons.");
  }
  Rcpp::List out(npgns);
  for(int i = 0; i < npgns; i++) {
    out(i) = returnPolygonWithHoles(Plgs[i]);
    if(npgns > 1) {
      int nholes = Plgs[i].number_of_holes();
      if(nholes == 0) {
        Message("Polygon " + std::to_string(i+1) + " has no hole.");
      } else if(nholes == 1) {
        Message("Polygon " + std::to_string(i+1) + " has one hole.");
      } else {
        Message("Polygon " + std::to_string(i+1) + " has " + 
                  std::to_string(nholes) + " holes.");
      }
    }
  }
  return out;
}


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Rcpp::List Subtract(
    const Polygon2WithHoles& plg1, const Polygon2WithHoles& plg2 
) {
  Traits2 traits;
  if(!CGAL::is_valid_polygon_with_holes(plg1, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  if(!CGAL::is_valid_polygon_with_holes(plg2, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  std::vector<Polygon2WithHoles> Plgs;
  CGAL::difference(plg1, plg2, std::back_inserter(Plgs));
  int npgns = std::distance(Plgs.begin(), Plgs.end());
  if(npgns == 0) {
    Message("The difference is empty.");
    return Rcpp::List::create();
  } else if(npgns == 1) {
    Message("The difference consists in one polygon.");
    int nholes = Plgs[0].number_of_holes();
    if(nholes == 0) {
      Message("It doesn't have any hole.");
    } else if(nholes == 1) {
      Message("It has one hole.");
    } else {
      Message("It has " + std::to_string(nholes) + " holes.");
    }
  } else {
    Message("The difference consists in " + 
      std::to_string(npgns) + " polygons.");
  }
  Rcpp::List out(npgns);
  for(int i = 0; i < npgns; i++) {
    out(i) = returnPolygonWithHoles(Plgs[i]);
    if(npgns > 1) {
      int nholes = Plgs[i].number_of_holes();
      if(nholes == 0) {
        Message("Polygon " + std::to_string(i+1) + " has no hole.");
      } else if(nholes == 1) {
        Message("Polygon " + std::to_string(i+1) + " has one hole.");
      } else {
        Message("Polygon " + std::to_string(i+1) + " has " + 
          std::to_string(nholes) + " holes.");
      }
    }
  }
  return out;
}


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Rcpp::List Symdiff(
    const Polygon2WithHoles& plg1, const Polygon2WithHoles& plg2 
) {
  Traits2 traits;
  if(!CGAL::is_valid_polygon_with_holes(plg1, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  if(!CGAL::is_valid_polygon_with_holes(plg2, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  std::vector<Polygon2WithHoles> Plgs;
  CGAL::symmetric_difference(plg1, plg2, std::back_inserter(Plgs));
  int npgns = std::distance(Plgs.begin(), Plgs.end());
  if(npgns == 0) {
    Message("The symmetric difference is empty.");
    return Rcpp::List::create();
  } else if(npgns == 1) {
    Message("The symmetric difference consists in one polygon.");
    int nholes = Plgs[0].number_of_holes();
    if(nholes == 0) {
      Message("It doesn't have any hole.");
    } else if(nholes == 1) {
      Message("It has one hole.");
    } else {
      Message("It has " + std::to_string(nholes) + " holes.");
    }
  } else {
    Message("The symmetric difference consists in " + 
      std::to_string(npgns) + " polygons.");
  }
  Rcpp::List out(npgns);
  for(int i = 0; i < npgns; i++) {
    out(i) = returnPolygonWithHoles(Plgs[i]);
    if(npgns > 1) {
      int nholes = Plgs[i].number_of_holes();
      if(nholes == 0) {
        Message("Polygon " + std::to_string(i+1) + " has no hole.");
      } else if(nholes == 1) {
        Message("Polygon " + std::to_string(i+1) + " has one hole.");
      } else {
        Message("Polygon " + std::to_string(i+1) + " has " + 
          std::to_string(nholes) + " holes.");
      }
    }
  }
  return out;
}


// -------------------------------------------------------------------------- //
// -------------------------------------------------------------------------- //
Rcpp::List Union(
    const Polygon2WithHoles& plg1, const Polygon2WithHoles& plg2 
) {
  Traits2 traits;
  if(!CGAL::is_valid_polygon_with_holes(plg1, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  if(!CGAL::is_valid_polygon_with_holes(plg2, traits)){
    Rcpp::stop("Invalid polygon with holes.");
  }
  std::vector<Polygon2WithHoles> input = {plg1, plg2};
  std::vector<Polygon2WithHoles> Plgs;
  CGAL::join(input.begin(), input.end(), std::back_inserter(Plgs));
  int npgns = std::distance(Plgs.begin(), Plgs.end());
  if(npgns == 0) {
    Message("The union is empty.");
    return Rcpp::List::create();
  } else if(npgns == 1) {
    Message("The union consists in one polygon.");
    int nholes = Plgs[0].number_of_holes();
    if(nholes == 0) {
      Message("It doesn't have any hole.");
    } else if(nholes == 1) {
      Message("It has one hole.");
    } else {
      Message("It has " + std::to_string(nholes) + " holes.");
    }
  } else {
    Message("The union consists in " + 
      std::to_string(npgns) + " polygons.");
  }
  Rcpp::List out(npgns);
  for(int i = 0; i < npgns; i++) {
    out(i) = returnPolygonWithHoles(Plgs[i]);
    if(npgns > 1) {
      int nholes = Plgs[i].number_of_holes();
      if(nholes == 0) {
        Message("Polygon " + std::to_string(i+1) + " has no hole.");
      } else if(nholes == 1) {
        Message("Polygon " + std::to_string(i+1) + " has one hole.");
      } else {
        Message("Polygon " + std::to_string(i+1) + " has " + 
          std::to_string(nholes) + " holes.");
      }
    }
  }
  return out;
}
