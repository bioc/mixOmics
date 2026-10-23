# buildignore

Development scripts that belong to a version of the code, such as
benchmarks or reproduction scripts for a pull request. `.Rbuildignore`
excludes this folder from the package.

Once the work of a script is merged, delete the script or turn it into a
test in `tests/testthat`.

To view a previous script, look in the git history of this folder; deleted
scripts remain there.
