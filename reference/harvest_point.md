# Biomass data from one harvest

This S3 class is designed to store the information from a crop harvest
data sheet (see
[`access_sheet`](https://biocro.github.io/BioCroField/reference/access_sheet.md))
in an R data structure. Thus, it represents biomass and leaf area
measurements collected from a single plot at a single time.

## Usage

``` r
harvest_point(
    crop = NA,
    variety = NA,
    location = NA,
    plot = NA,
    year = NA,
    doy = NA,
    hour = 12,
    planting_density = NA,
    row_spacing = NA,
    plant_spacing = NA,
    partitioning_nplants = NA,
    partitioning_leaf_area = NA,
    partitioning_component_weights = list(),
    agb_nplants = NA,
    agb_components = character(),
    agb_row_length = NA,
    agb_weight = NA,
    trap_area = NA,
    trap_component_weights = list(),
    ...
  )
```

## Arguments

- crop:

  A name for the crop, such as `'soybean'`.

- variety:

  A name for the crop variety, such as `'ld11'`.

- location:

  A name for the crop's location, such as `'energy farm'`.

- plot:

  A name for the plot that was harvested, such as `2`.

- year:

  The year the crop was grown, such as `2022`.

- doy:

  The day of year when the plot was harvested, such as `180`.

- hour:

  The hour of the day when the plot was harvested.

- planting_density:

  The intended number of plants per unit ground area in `plants / acre`;
  typically this will be different from the actual plant population due
  to seeds that fail to emerge (reduces actual population) or accidental
  double-planting (increases actual population).

- row_spacing:

  The spacing between rows in the plot (in `m`).

- plant_spacing:

  The spacing between plants along a row (in `m`).

- partitioning_nplants:

  The number of plants chosen for partitioning.

- partitioning_leaf_area:

  The total leaf area from the partitioned plants (in `cm^2`).

- partitioning_component_weights:

  A list of named numeric elements, where the name of each element
  indicates a plant component (such as `'leaf'`) and the value of each
  element indicates its dry weight as measured from the partitioned
  plants (in `g`).

- agb_nplants:

  The number of plants harvested for above-ground biomass.

- agb_components:

  A character vector indicating the partitioned components that should
  be added together to determine the above-ground biomass of the
  partitioned plants.

- agb_row_length:

  The length of row harvested for above-ground biomass (in `m`).

- agb_weight:

  The weight of the row section harvested for above-ground biomass (in
  `g`).

- trap_area:

  The area of the litter trap (in `m^2`).

- trap_component_weights:

  A list of named numeric elements, where the name of each element
  indicates a plant litter component (such as `'leaf_litter'`) and the
  value of each element indicates its dry weight as measured from the
  litter trap contents (in `g`).

- ...:

  Any additional arguments (such as comments) to include in the
  `harvest_point` object.

## Details

From a technical point of view, a `harvest_point` object is simply an R
list with a particular set of named elements, so it can be viewed and
modified using any standard R commands that apply to lists. All of its
input arguments are optional, so a user only needs to enter information
that was actually measured. Typically, a `harvest_point` object is
passed to
[`process`](https://biocro.github.io/BioCroField/reference/process.md)
to convert the raw measurements into more useful quantities like the
mass per unit area and leaf area index.

**Note about planting density**: seed and/or plant densities can be
specified in various ways. When planting by hand, it is convenient to
specify the row spacing and the spacing between plants along each row.
When using a precision planter, it is more typical to specify the row
spacing and the plant population. In either case, the row spacing, plant
spacing, and plant population are related to each other according to
`planting_density * row_spacing * plant_spacing = 4047`; this equation
assumes that the row and plant spacings are expressed in `m` and the
density is expressed in `plants per acre`. If a used specified all three
of these inputs (`planting_density`, `row_spacing`, and
`plant_spacing`), the `harvest_point` function will check to make sure
the values are consistent with each other. If any two of the inputs are
provided, the value of the third will automatically be calculated.

## Value

A `harvest_point` object as described above.

## Examples

``` r
# Example 1: Creating a harvest_point object that includes (optional) comments
# about the stem and the leaf litter.
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
  plot = 1,
  year = 2023,
  doy = 186,
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

str(hp)
#> List of 20
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
#>  - attr(*, "class")= chr [1:2] "harvest_point" "list"

# Example 2: Determining the planting density (in plants per acre) from the row
# and plant spacings (in m)
harvest_point(row_spacing = 0.75, plant_spacing = 0.2)$planting_density
#> [1] 26980
```
