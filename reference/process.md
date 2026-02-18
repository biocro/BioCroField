# Process raw biomass data from one harvest

This function processes the raw biomass data stored in a
[`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)
object to convert it into more meaningful values.

## Usage

``` r
process(x, ...)

  # S3 method for class 'harvest_point'
process(x, leaf_name = 'leaf', ...)
```

## Arguments

- x:

  A
  [`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)
  object.

- leaf_name:

  A string specifying the name of the leaf tissue to use when
  calculating the leaf area index. Typically, the leaf mass is called
  `'leaf'`, but it may sometimes have a similar name such as
  `'main_leaf'`.

- ...:

  Additional arguments (currently unused).

## Details

The `process` function attempts to make a variety of calculations using
the information stored in `x`. If some of the possible elements of `x`
are set to [`NA`](https://rdrr.io/r/base/NA.html), the relevant
calculations that would require those pieces of information will simply
be skipped, and their outputs will be set to `NA`. The results of the
calculations will be stored as new elements in the `harvest_point`
object.

The detailed calculations are as follows:

- `time`: The time as determined from the `doy` and `hour` using
  [`add_time_to_weather_data`](https://rdrr.io/pkg/BioCro/man/add_time_to_weather_data.html).

- `measured_population`: The number of plants per unit ground area (in
  `plants / acre` can be estimated from the row spacing and the number
  of plants harvested for above-ground biomass using
  `measured_population = agb_nplants / (agb_row_length * row_spacing) * 4047`.
  Here, the factor `4047` converts the area basis from `m^2` to `acre`
  using `1 acre = 4047 m^2`.

- `agb_per_area`: The amount of above-ground biomass per unit ground
  area (in `Mg / ha`) in the plot can be estimated from the row spacing
  and the dry mass of the plants harvested for above-ground biomass
  using
  `agb_per_area = agb_weight / (agb_row_length * row_spacing) * 1e-2`.
  Here, the factor `1e-2` converts from `g / m^2` to `Mg / ha` using
  `1 g / m^2 = 0.01 Mg / ha`.

- `agb_per_plant_row`: The amount of above-ground biomass per plant (in
  `g / plant`) can be estimated from the row section harvested for
  above-ground biomass using
  `agb_per_plant_row = agb_weight / agb_nplants`. This value can be
  compared against `agb_per_plant_partitioning` to get an idea of the
  variability in plant size throughout the plot.

- `partitioning_agb_weight`: The above-ground biomass (in `g`) of the
  plants selected for partitioning can be obtained by adding the
  partitioning component weights for the components that are designated
  as being part of the above-ground biomass. For example, if
  `partitioning_component_weights = list(leaf = 1, stem = 2, root = 0.5)`
  and `agb_components = c('leaf', 'stem')`, then the above-ground
  biomass from the partitioned plants would be `1 + 2 = 3`. In other
  words, the `root` mass would not be included.

- `agb_per_plant_partitioning`: The amount of above-ground biomass per
  plant (in `g / plant`) can be estimated from the partitioned plants
  using
  `agb_per_plant_partitioning = partitioning_agb_weight / agb_nplants`.
  This value can be compared against `agb_per_plant_row` to get an idea
  of the variability in plant size throughout the plot.

- `relative_components`: The relative mass (dimensionless from `g / g`;
  normalized to the above-ground biomass) for each partitioned component
  can be obtained by dividing each component's dry mass by
  `partitioning_agb_weight`. For example, if
  `partitioning_component_weights = list(leaf = 1, stem = 2, root = 0.5)`
  and `agb_components = c('leaf', 'stem')`, then
  `partitioning_agb_weight = 3` and
  `relative_components = list(leaf = 1 / 3, stem = 2 / 3, root = 0.5 / 3)`.

- `components_biocro`: The biomass per unit ground area (in `Mg / ha`,
  the units used in BioCro) can be obtained by multiplying each element
  of `relative_components` by `agb_per_area`.

- `LMA`: The leaf mass per unit leaf area (LMA; in units of `g / m^2`)
  can be calculated from the mass and area of the partitioned leaves
  using
  `LMA = partitioning_component_weights$leaf / partitioning_leaf_area * 1e4`.
  Here, the factor `1e-4` converts from `g / cm^2` to `g / m^2` using
  `1 g / cm^2 = 1e-4 g / m^2`.

- `LAI_from_LMA`: The leaf area per unit ground area, which is referred
  to as the leaf area index (LAI; dimensionless from `m^2 / m^2`), can
  be calculated from the leaf mass per unit area and the LMA using
  `LAI = components_biocro$leaf / LMA * 1e2`. Here, the factor `1e2`
  converts the leaf mass per unit area from `Mg / ha` to `g / m^2` using
  `1 Mg / ha = 100 g / m^2`. This estimate of LAI can be compared to the
  estimates based on planting density or measured population, which are
  stored as `LAI_from_planting_density` and
  `LAI_from_measured_population`, respectively.

- `leaf_area_per_plant`: The leaf area per plant in `cm^2 / plant` can
  be calculated from the partitioning leaf area and the number of plants
  that were partitioned.

- `LAI_from_planting_density`: The LAI can be estimated from the
  planting density and the leaf area per plant using
  `LAI = planting_density * leaf_area_per_plant * 1e-4 / 4047`. Here,
  the factor `1e-4` converts leaf area from `cm^2` to `m^2` and the
  factor `1 / 4047` converts population from `plants / acre` to
  `plants / m^2`. This estimate of LAI can be compared to the estimates
  based on LMA or measured population, which are stored as
  `LAI_from_LMA` and `LAI_from_measured_population`, respectively.

- `LAI_from_measured_population`: The LAI can be estimated from the
  measured population and the leaf area per plant using
  `LAI = measured_population * leaf_area_per_plant * 1e-4`. Here, the
  factor `1e-4` converts leaf area from `cm^2` to `m^2`. This estimate
  of LAI can be compared to the estimates based on LMA or planting
  density, which are stored as `LAI_from_LMA` and
  `LAI_from_planting_density`, respectively.

- `SLA`: The leaf mass per unit leaf area, which is referred to as the
  specific leaf area (SLA; in units of `ha / Mg`), can be calculated
  from LMA using `SLA = 1 / LMA * 1e2` where the factor `1e2` converts
  the units from `m^2 / g` to `ha / Mg`.

- `trap_components_biocro`: The biomass per unit ground area for the
  tissue types collected in the litter trap (in units of `Mg / ha`) can
  be calculated by dividing the dry mass of each component by the litter
  trap area and multiplying by `1e-2` to convert from `g / m^2` to
  `Mg / ha`.

- `all_components_biocro`: The biomass per unit ground area (in
  `Mg / ha`) for all plant tissue types included in `components_biocro`
  and `trap_components_biocro` is stored in `all_components_biocro`. If
  a component is present in both lists, the separate values will be
  added together. For example, `components_biocro` may include a
  `leaf_litter` component that represents the biomass of senesced leaves
  that are still attached to the plants, while `trap_components_biocro`
  may contain a `leaf_litter` component representing the biomass of
  senesced leaves that have fallen off the plant; in this case, the
  value of `leaf_litter` in `all_components_biocro` will be the sum of
  the two separate leaf litter biomass values.

A note about LAI estimates: LAI estimated using LMA is the most accurate
of the three methods, and is commonly used when estimating LAI from
destructive leaf area measurements (Bréda 2003). When mass values are
unavailable, it may not be possible to use this method; in that case,
the estimates based on population can be used instead. When enough
information is available to make all three estimates, they can be
compared to each other as a consistency check or to estimate upper and
lower bounds on the LAI.

References:

- Bréda, N. J. J. "Ground-based measurements of leaf area index: a
  review of methods, instruments and current controversies." Journal of
  Experimental Botany 54, 2403–2417 (2003)
  \[[doi:10.1093/jxb/erg263](https://doi.org/10.1093/jxb/erg263) \].

## Value

A
[`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)
object with new elements as described above.

## See also

[`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)

## Examples

``` r
# Example: Creating and processing a harvest_point object that includes
# (optional) comments about the stem and the leaf litter.
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

str(hpp)
#> List of 36
#>  $ crop                          : chr "soybean"
#>  $ variety                       : chr "ld11"
#>  $ location                      : chr "energy farm"
#>  $ plot                          : num 1
#>  $ year                          : num 2023
#>  $ doy                           : num 186
#>  $ hour                          : num 12
#>  $ planting_density              : num 140000
#>  $ row_spacing                   : num 0.7
#>  $ plant_spacing                 : num 0.0413
#>  $ partitioning_nplants          : num 6
#>  $ partitioning_leaf_area        : num 500
#>  $ partitioning_component_weights:List of 4
#>   ..$ leaf       : num 2.5
#>   ..$ stem       : num 1.5
#>   ..$ root       : num 1.4
#>   ..$ leaf_litter: num 0.2
#>  $ agb_components                : chr [1:2] "leaf" "stem"
#>  $ agb_nplants                   : num 50
#>  $ agb_row_length                : num 2
#>  $ agb_weight                    : num 50
#>  $ trap_area                     : num 0.185
#>  $ trap_component_weights        :List of 2
#>   ..$ leaf_litter: num 0.4
#>   ..$ stem_litter: num 0.5
#>  $ additional_arguments          :List of 3
#>   ..$ stem_comment       : chr "The stem weight includes petioles"
#>   ..$ stem_litter_comment: chr "The stem litter is entirely petioles"
#>   ..$ leaf_litter_comment: chr "Senesced leaves were present on the plants and in the trap"
#>  $ time                          : num 4452
#>  $ partitioning_agb_weight       : num 4
#>  $ agb_per_plant_partitioning    : num 0.667
#>  $ agb_per_plant_row             : num 1
#>  $ measured_population           : num 144536
#>  $ agb_per_area                  : num 0.357
#>  $ relative_components           :List of 4
#>   ..$ leaf       : num 0.625
#>   ..$ stem       : num 0.375
#>   ..$ root       : num 0.35
#>   ..$ leaf_litter: num 0.05
#>  $ components_biocro             :List of 4
#>   ..$ leaf       : num 0.223
#>   ..$ stem       : num 0.134
#>   ..$ root       : num 0.125
#>   ..$ leaf_litter: num 0.0179
#>  $ LMA                           : num 50
#>  $ LAI_from_LMA                  : num 0.446
#>  $ LAI_from_planting_density     : num 0.288
#>  $ LAI_from_measured_population  : num 0.298
#>  $ leaf_area_per_plant           : num 83.3
#>  $ SLA                           : num 2
#>  $ trap_components_biocro        :List of 2
#>   ..$ leaf_litter: num 0.0216
#>   ..$ stem_litter: num 0.027
#>  $ all_components_biocro         :List of 5
#>   ..$ leaf       : num 0.223
#>   ..$ stem       : num 0.134
#>   ..$ root       : num 0.125
#>   ..$ leaf_litter: num 0.0395
#>   ..$ stem_litter: num 0.027
#>  - attr(*, "class")= chr [1:2] "harvest_point" "list"

# Example: Creating and processing a harvest point object that has `main_leaf`
# rather than `leaf`.
hp2 <- harvest_point(
  partitioning_component_weights = list(main_leaf = 1),
  partitioning_leaf_area = 2
)

print(process(hp2)$LMA)              # returns NA because no leaf weight was found
#> [1] NA
print(process(hp2, 'main_leaf')$LMA) # returns the correct value
#> [1] 5000
```
