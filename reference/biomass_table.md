# Reorganize harvest point data into a table

This function reorganizes the information contained in one or more
[`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)
objects into a `data.frame`.

## Usage

``` r
biomass_table(
    ...,
    zero_when_missing = character(),
    other_columns = c(
        'leaf_area_per_plant',
        'LAI_from_planting_density',
        'LAI_from_measured_population',
        'agb_per_area',
        'agb_per_plant_row',
        'agb_per_plant_partitioning',
        'measured_population'
    )
  )

  # S3 method for class 'harvest_point'
biomass_table(
    ...,
    zero_when_missing = character(),
    other_columns = c(
        'leaf_area_per_plant',
        'LAI_from_planting_density',
        'LAI_from_measured_population',
        'agb_per_area',
        'agb_per_plant_row',
        'agb_per_plant_partitioning',
        'measured_population'
    )
  )
```

## Arguments

- ...:

  One or more
  [`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)
  objects.

- zero_when_missing:

  A character vector indicating any biomass columns whose values should
  be set to zero when they were not explicitly measured. For example,
  early harvest data points for soybeans may not include a value for
  `pod`; by default, `pod` would be set to `NA` for these points, but it
  would make more sense to set it to 0.

- other_columns:

  The names of variables to include as columns in addition to the
  default columns (see below).

## Details

The following `harvest_point` elements will be included as columns in
the final `data.frame`, where each row represents the information from
one of the `harvest_point` objects passed to `biomass_table`:

- `crop`

- `variety`

- `location`

- `plot`

- `year`

- `doy`

- `hour`

- `time`

- `SLA`

- `LMA`

- `LAI_from_LMA`

- `row_spacing`

- `plant_spacing`

- `planting_density`

- Any elements contained in `components_biocro` (see
  [`process`](https://biocro.github.io/BioCroField/reference/process.md))

- Any additional arguments (such as comments) that were passed to
  [`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)
  when creating the data points

- Any additional variables specified in the `other_columns` input
  argument

See
[`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)
and
[`process`](https://biocro.github.io/BioCroField/reference/process.md)
for more information about these elements. In general, any missing
values will be set to `NA` in the final `data.frame`.

## Value

A [`data.frame`](https://rdrr.io/r/base/data.frame.html) as described
above.

## See also

[`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)

## Examples

``` r
# Example: Creating, processing, and reorganizing a harvest_point object that
# includes (optional) comments about the stem and the leaf litter.
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
  plot = 1,
  year = 2023,
  doy = 186,
  hour = 12,
  planting_density = 140000,
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

str(biomass)
#> 'data.frame':    1 obs. of  29 variables:
#>  $ crop                        : chr "soybean"
#>  $ variety                     : chr "ld11"
#>  $ location                    : chr "energy farm"
#>  $ plot                        : num 1
#>  $ year                        : num 2023
#>  $ doy                         : num 186
#>  $ hour                        : num 12
#>  $ time                        : num 4452
#>  $ leaf                        : num 0.223
#>  $ stem                        : num 0.134
#>  $ root                        : num 0.125
#>  $ leaf_litter                 : num 0.0395
#>  $ stem_litter                 : num 0.027
#>  $ SLA                         : num 2
#>  $ LMA                         : num 50
#>  $ LAI_from_LMA                : num 0.446
#>  $ row_spacing                 : num 0.7
#>  $ plant_spacing               : num 0.0413
#>  $ planting_density            : num 140000
#>  $ leaf_area_per_plant         : num 83.3
#>  $ LAI_from_planting_density   : num 0.288
#>  $ LAI_from_measured_population: num 0.298
#>  $ agb_per_area                : num 0.357
#>  $ agb_per_plant_row           : num 1
#>  $ agb_per_plant_partitioning  : num 0.667
#>  $ measured_population         : num 144536
#>  $ stem_comment                : chr "The stem weight includes petioles"
#>  $ stem_litter_comment         : chr "The stem litter is entirely petioles"
#>  $ leaf_litter_comment         : chr "Senesced leaves were present on the plants and in the trap"
```
