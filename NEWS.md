<!--
This file should document all pull requests and all user-visible changes.

When a pull request is completed, changes made should be added to a section at
the top of this file called "# Unreleased". All changes should be categorized
under "## MAJOR CHANGES", "## MINOR CHANGES", or "## BUG FIXES" following the
major.minor.patch structure of semantic versioning. When applicable, entries
should include direct links to the relevant pull requests.

Then, when a new release is made, "# Unreleased" should be replaced by a heading
with the new version number, such as "# CHANGES IN BioCroField VERSION 2.0.0."
This section will combine all of the release notes from all of the pull requests
merged in since the previous release.

Subsequent commits will then include a new "Unreleased" section in preparation
for the next release.
-->

# BioCroField VERSION 0.1.1

- A bug related to partial name matching for partitioning components was
  detected and fixed. In short, if a value of `leaf` mass was not supplied but
  a value of `leaf_litter` _was_ supplied, the leaf litter mass would be used by
  `process` when calculating LMA and other related properties, leading to
  errors. Now, the internal code does not use partial name matching, and the
  user is able to supply a different name for the leaf tissue component if it
  does not have the standard name of `leaf`.
- PRs related to creating this version:
  - https://github.com/biocro/BioCroField/pull/2

# BioCroField VERSION 0.1.0

- This is the first version of BioCroField. At this point, the package is in a
  state of rapid development, and not all changes will be described here.

- We are reserving version `1.0.0` for a more stable and complete future
  release; until then, major changes should only increase the minor version
  number.
