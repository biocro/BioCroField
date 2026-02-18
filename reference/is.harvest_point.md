# Is an object an harvest_point?

Checks whether an object is an `harvest_point` object.

## Usage

``` r
is.harvest_point(x)
```

## Arguments

- x:

  An R object.

## Details

This function simply checks to see if `'harvest_point'` is in
`class(x)`.

## Value

A logical (TRUE / FALSE) value indicating whether the object is an
`harvest_point` object.

## See also

[`harvest_point`](https://biocro.github.io/BioCroField/reference/harvest_point.md)

## Examples

``` r
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
  plot = 1,
  year = 2023,
  doy = 186,
  hour = 12,
  row_spacing = 0.7,
  partitioning_leaf_area = 500,
  partitioning_component_weights = list(leaf = 2.5, stem = 1.5, root = 1.4),
  agb_components = c('leaf', 'stem'),
  agb_row_length = 2,
  agb_weight = 50,
  trap_area = 0.185,
  trap_component_weights = list(leaf_litter = 0.4, stem_litter = 0.5),
  partitioning_nplants = 6,
  agb_nplants = 50
)

is.harvest_point(hp)
#> [1] TRUE
```
