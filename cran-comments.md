# RESUBMISSION

This package has been archived because of problems found by clang-UBSAN. These 
problems are unrelated to my C++ code, these are problems of the C++ library 
CGAL. But a new version of RcppCGAL has been released, providing a new version 
of CGAL, and the problems should have gone, according to the CGAL developers.


# ISSUES WITH VALGRIND

This package does not work with Valgrind. This is normal: the C++ library 
CGAL is not expected to work with Valgrind.


## R CMD check results

OK.
