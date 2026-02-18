# Initial biomass from seed information

Adds a new row to a `data.frame` created by
[`biomass_table`](https://biocro.github.io/BioCroField/reference/biomass_table.md)
that represents the initial seed biomass.

## Usage

``` r
add_seed_biomass(
    biomass_df,
    year = NA,
    doy = NA,
    hour = 12,
    seed_mass = NA,
    zero_when_missing = character(),
    component_fractions = list(),
    ...
  )
```

## Arguments

- biomass_df:

  A data frame assumed to have been created by
  [`biomass_table`](https://biocro.github.io/BioCroField/reference/biomass_table.md).

- year:

  The year the crop was grown, such as `2022`.

- doy:

  The day of year when the plot was sown, such as `150`.

- hour:

  The hour of the day when the plot was sown.

- seed_mass:

  The average mass per seed (in `g`), typically determined by weighing a
  known number of seeds (such as one hundred seeds).

- zero_when_missing:

  A character vector indicating any biomass columns whose values should
  be set to zero when they were not explicitly measured.

- component_fractions:

  A list of named numeric elements whose values must add to 1. For
  BioCro simulations, it is often necessary to estimate the initial
  leaf, stem, and root biomass as fractions of the original seed
  biomass. For example, if we assume that the initial mass is 80 set
  `component_fractions` to `list(leaf = 0.8, stem = 0.1, root = 0.1)`.

- ...:

  Any additional arguments (such as comments) to include as columns in
  the new row.

## Details

The new row in the data table will be constructed as follows:

- The values of the `crop`, `variety`, `location`, `planting_density`,
  `row_spacing`, and `plant_spacing` will be copied from the first row
  of `biomass_df`.

- The values of `year`, `doy`, and `hour` will be taken from the inputs;
  the value of `time` will be calculated as in
  [`process`](https://biocro.github.io/BioCroField/reference/process.md).

- The value of all LAI estimates (`LAI_from_LMA`,
  `LAI_from_planting_density`, and `LAI_from_measured_population`) will
  be set to 0 since there cannot be any leaf area corresponding to seeds
  that were just sown.

- The initial seed biomass per unit ground area (in `Mg / ha`) will be
  stored in a new column called `initial_seed`. This value is calculated
  using `initial_seed = seed_mass * planting_density * 2.47e-6`, where
  the factor `2.47e-6` converts from `g / acre` to `Mg / ha` using
  `1 g / acre = 2.47e-6 Mg / ha`.

- If component fractions were specified, the values of those columns
  will be set to the corresponding fractions of `initial_seed`.

## Value

A data frame as described above.

## Examples

``` r
# Example: Creating and processing a harvest_point object that includes
# (optional) comments about the stem and the leaf litter, and then adding an
# initial seed biomass (and another comment).
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
  plot = 1,
  year = 2023,
  doy = 186,
  hour = 12,
  planting_density = 125000,
  row_spacing = 0.7,
  partitioning_leaf_area = 500,
  partitioning_component_weights = list(leaf = 2.5, stem = 1.5, root = 1.4, leaf_litter = 0.2),
  agb_components = c('leaf', 'stem'),
  agb_row_length = 2,
  agb_weight = 50,
  trap_area = 0.185,
  trap_component_weights = list(leaf_litter = 0.4, stem_litter = 0.5),
  partitioning_nplants = 6,
  agb_nplants = 50,
  stem_comment = 'The stem weight includes petioles',
  stem_litter_comment = 'The stem litter is entirely petioles',
  leaf_litter_comment = 'Senesced leaves were present on the plants and in the trap'
)

hpp <- process(hp)

biomass <- biomass_table(hpp)

biomass <- add_seed_biomass(
  biomass,
  year = 2023,
  doy = 152,
  hour = 12,
  seed_mass = 0.17,
  component_fractions = list(leaf = 0.8, stem = 0.1, root = 0.1),
  seed_comment = 'Sown with precision planter'
)

str(biomass)
#> 'data.frame':    2 obs. of  31 variables:
#>  $ crop                        : chr  "soybean" "soybean"
#>  $ variety                     : chr  "ld11" "ld11"
#>  $ location                    : chr  "energy farm" "energy farm"
#>  $ plot                        : num  NA 1
#>  $ year                        : num  2023 2023
#>  $ doy                         : num  152 186
#>  $ hour                        : num  12 12
#>  $ time                        : num  3636 4452
#>  $ leaf                        : num  0.042 0.223
#>  $ stem                        : num  0.00525 0.13393
#>  $ root                        : num  0.00525 0.125
#>  $ leaf_litter                 : num  NA 0.0395
#>  $ stem_litter                 : num  NA 0.027
#>  $ SLA                         : num  NA 2
#>  $ LMA                         : num  NA 50
#>  $ LAI_from_LMA                : num  0 0.446
#>  $ row_spacing                 : num  0.7 0.7
#>  $ plant_spacing               : num  0.0463 0.0463
#>  $ planting_density            : num  125000 125000
#>  $ leaf_area_per_plant         : num  NA 83.3
#>  $ LAI_from_planting_density   : num  0 0.257
#>  $ LAI_from_measured_population: num  0 0.298
#>  $ agb_per_area                : num  NA 0.357
#>  $ agb_per_plant_row           : num  NA 1
#>  $ agb_per_plant_partitioning  : num  NA 0.667
#>  $ measured_population         : num  NA 144536
#>  $ stem_comment                : chr  NA "The stem weight includes petioles"
#>  $ stem_litter_comment         : chr  NA "The stem litter is entirely petioles"
#>  $ leaf_litter_comment         : chr  NA "Senesced leaves were present on the plants and in the trap"
#>  $ initial_seed                : num  0.0525 NA
#>  $ seed_comment                : chr  "Sown with precision planter" NA
```
