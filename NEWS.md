<!--
This file should document all pull requests and all user-visible changes.

When a pull request is completed, changes made should be added to a section at
the top of this file called "# Unreleased". All changes should be categorized
under "## MAJOR CHANGES", "## MINOR CHANGES", or "## BUG FIXES" following the
major.minor.patch structure of semantic versioning. When applicable, entries
should include direct links to the relevant pull requests.

Then, when a new release is made, "# Unreleased" should be replaced by a heading
with the new version number, such as "# BioCroField version 2.0.0."
This section will combine all of the release notes from all of the pull requests
merged in since the previous release.

Subsequent commits will then include a new "Unreleased" section in preparation
for the next release.
-->

# BioCroField version 0.4.0

- It is now possible to specify extra columns to be returned in the output from
  `biomass_table`.
- Values of `time` are now calculated using `BioCro::add_time_to_weather_data`
  to ensure they are always consistent with BioCro's time definition.
- Values of partitioned leaf mass can be set to `NA` when creating a
  `harvest_point`, which is treated as if the leaf mass had not been provided.

# BioCroField version 0.3.0

- LMA is now included in the output from `biomass_table`.
- New crop-specific guides to harvesting and weighing are now available, along
  with a convenience function for creating such guides (`generate_crop_guide`).
- The new sheets are now mentioned in the main vignette
  (`handling_biomass_measurements`).
- A new vignette has been added (`images_from_the_field`) that illustrates
  parts of the harvesting and weighing process using pictures from the field.

# BioCroField version 0.2.0

- Two new methods for estimating LAI were added to `process`:
  `LAI_from_planting_density` and `LAI_from_measured_population`. The original
  LAI estimate was renamed from `LAI` to `LAI_from_LMA` to better indicate the
  different estimates.
- Allow the user to (optionally) specify plant spacing in additiong to row
  spacing and plant population when creating a `harvest_point` object. If all
  three are specified, a consistency check will be performed. If only two are
  specified, the value of the third will be calculated.
- `add_seed_biomass` now takes planting density from the input data frame.
- Renamed two other variables to make their meaning more clear:
  - `target_population` was renamed to `planting_density`
  - `population` was renamed to `measured_population`
- PRs related to creating this version:
  - https://github.com/biocro/BioCroField/pull/3
  - https://github.com/biocro/BioCroField/pull/4
  - https://github.com/biocro/BioCroField/pull/5

# BioCroField version 0.1.1

- A bug related to partial name matching for partitioning components was
  detected and fixed. In short, if a value of `leaf` mass was not supplied but
  a value of `leaf_litter` _was_ supplied, the leaf litter mass would be used by
  `process` when calculating LMA and other related properties, leading to
  errors. Now, the internal code does not use partial name matching, and the
  user is able to supply a different name for the leaf tissue component if it
  does not have the standard name of `leaf`.
- PRs related to creating this version:
  - https://github.com/biocro/BioCroField/pull/2

# BioCroField version 0.1.0

- This is the first version of BioCroField. At this point, the package is in a
  state of rapid development, and not all changes will be described here.
- We are reserving version `1.0.0` for a more stable and complete future
  release; until then, major changes should only increase the minor version
  number.
