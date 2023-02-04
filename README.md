# cgalPolygons

R6 based utilities for polygons.

<!-- badges: start -->
[![R-CMD-check](https://github.com/stla/cgalPolygons/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/stla/cgalPolygons/actions/workflows/R-CMD-check.yaml)
[![R-CMD-check-valgrind](https://github.com/stla/cgalPolygons/actions/workflows/R-CMD-check-valgrind.yaml/badge.svg)](https://github.com/stla/cgalPolygons/actions/workflows/R-CMD-check-valgrind.yaml)
<!-- badges: end -->

### Decomposition into convex parts

- *Eight-pointed star:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/star.png)

- *Monster head:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/monster.png)

- *Sun curve with a hole:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/funnyCurve.png)


### Minkowski sum

- *Eight-pointed star + sun curve:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/msum_star-funnyCurve.png)

- *Decagram + circle with varying radius:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/minko_circle-decagram.gif)


### Boolean operations

- *Intersection:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/boolop_intersection.png)

- *Union:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/boolop_union.png)

- *Difference:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/boolop_difference.png)

- *Symmetric difference:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/boolop_symdiff.png)

- *An example with some holes:*

![](https://raw.githubusercontent.com/stla/cgalPolygons/main/inst/screenshots/boolop_withHoles.png)


## License

This package is provided under the GPL-3 license but it uses the C++ library 
CGAL. If you wish to use CGAL for commercial purposes, you must obtain a 
license from the [GeometryFactory](https://geometryfactory.com).

