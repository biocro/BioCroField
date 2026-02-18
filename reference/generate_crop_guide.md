# Create a crop-specific guide to harvesting and weighing tissue

A convenience function for generating
[`rmarkdown`](https://pkgs.rstudio.com/rmarkdown/reference/rmarkdown-package.html)
code that can be used to build a PDF document with crop-specific advice
for harvesting and weighing tissue.

## Usage

``` r
generate_crop_guide(
    crop_name,
    uses_litter_trap,
    notes,
    harvesting_specific_tissues,
    weighing_specific_tissues,
    all_possible_weights,
    build = FALSE,
    output_dir = '.',
    clean = TRUE
  )
```

## Arguments

- crop_name:

  The name of the crop.

- uses_litter_trap:

  A logical value indicating whether or not litter traps are used with
  this crop.

- notes:

  Basic notes about the crop, which will appear just below the title of
  the document.

- harvesting_specific_tissues:

  A named list, where the name of each element is the name of a tissue
  type, and the value of each element is a string describing how this
  tissue type should be harvested.

- weighing_specific_tissues:

  A named list, where the name of each element is the name of a tissue
  type, and the value of each element is a string describing how this
  tissue type should be weighed.

- all_possible_weights:

  A list with two elements named `living` and `litter`. Each should be a
  string vector describing the possible types of living and senesced
  tissue that might be collected from this crop.

- build:

  A logical value indicating whether to automatically build the PDF.

- output_dir:

  A path to the output directory where the PDF should be built (only
  relevant when `build` is `TRUE`).

- clean:

  A logical value to be passed to
  [`render`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
  when building the PDF.

## Details

This function can be used to easily generate a basic guide to harvesting
and weighing tissue from a particular crop.

`generate_crop_guide` is used internally to generate the crop guides
that are included with the `BioCroField` package. The script used to
generate the guides is also included with the package and can be located
on your computer by typing
`system.file('build_crop_sheets.R', package = 'BioCroField')`. See
[`access_sheet`](https://biocro.github.io/BioCroField/reference/access_sheet.md)
for details about accessing the pre-built guides.

Ideally, a crop guide should fit on one page so it can be printed and
kept on hand for reference when harvesting or weighing.

Building the guide sheets requires LaTeX. If you do not have a
system-wide LaTeX installation, you may need to use the `TinyTex`
package. To do this, make sure the package is installed and then run
[`tinytex::install_tinytex()`](https://rdrr.io/pkg/tinytex/man/install_tinytex.html).
`TinyTex` can be installed from CRAN by typing
`install.packages('TinyTex')`.

## Value

A text string of
[`rmarkdown`](https://pkgs.rstudio.com/rmarkdown/reference/rmarkdown-package.html)
code that can be written to a file (with
[`writeLines`](https://rdrr.io/r/base/writeLines.html)) and then built
into a PDF (with
[`render`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)).

## Examples

``` r
# A simple example with some basic soybean information. Here we generate the
# rmarkdown code but do not build the document. Change `build` to `TRUE` to see
# what the final document looks like.
markdown_file_contents <- generate_crop_guide(
    crop_name = 'Soybean',
    uses_litter_trap = TRUE,
    notes = 'This is an incomplete example.',
    harvesting_specific_tissues = list(
      Leaves = 'These should always be harvested.',
      Stems = 'These should also always be harvested.'
    ),
    weighing_specific_tissues = list(
      Leaves = 'Only weigh the green ones. Brown ones count as litter.',
      Stems = 'Just open the bag and weigh what you find inside.'
    ),
    all_possible_weights = list(
      living = c('Roots', 'Leaves', 'Stems', 'Pods'),
      litter = c('Leaf', 'Stem')
    ),
    build = FALSE
)

cat(markdown_file_contents)
#> ---
#> title: "Soybean Guide (BioCroField)"
#> output: pdf_document
#> geometry: top=0.5in,bottom=0.75in,left=0.75in,right=0.75in
#> ---
#> 
#> **Notes**: This is an incomplete example.
#> 
#> # Harvesting and Partitioning Soybean Tissue
#> 
#> - **Essential Tissue Types**: Every harvest should include above-ground biomass,
#>   leaf, stem, and root tissue. When the plants are young, this might be all of
#>   the tissue types. As the plants enter reproductive stages, additional types
#>   might appear.
#> 
#> - **Plant Litter**: Any senesced tissue still attached to the plants themselves
#>   is considered to be "plant litter." Plant litter should be included when
#>   collecting above-ground biomass samples. Plant litter from partitioned plants
#>   should be placed in a bag labeled "litter" or "plant litter."
#> 
#> - **Litter Trap**: Any senesced tissue in the trap should be placed in a bag labeled "trap litter"
#> to distinguish it from the "plant litter" described above. The trap might not
#> contain any litter when the plants are young.
#> 
#> - **Leaves**: These should always be harvested.
#> 
#> - **Stems**: These should also always be harvested.
#> 
#> # Weighing the Partitioned Soybean Tissue
#> 
#> - **Roots**: Roots are cleaned in the field before drying, but they are usually
#>   still a bit dirty. Before weighing the roots, remove any soil or other
#>   obviously foreign material. A small screwdriver or a capped pen is often
#>   useful for this purpose. Be careful, and try to avoid damaging the roots
#>   themselves, because any small pieces that fall off might be difficult to
#>   recover and weigh.
#> 
#> - **Plant Litter**: The plant litter should be sorted into components as
#>   necessary, discarding any soil or foreign material. Each component should be
#>   separately weighed and recorded in the "partitioned plant components" section
#>   of the harvest log sheet. The name of these components should clearly indicate
#>   they represent litter; for example, **Leaf Litter**.
#> 
#> - **Litter Trap**: The litter trap contents should be sorted into components as necessary,
#> discarding any soil or foreign material. Each component should be separately
#> weighed and recorded in the "litter trap components" section of the harvest log
#> sheet.
#> 
#> - **Leaves**: Only weigh the green ones. Brown ones count as litter.
#> 
#> - **Stems**: Just open the bag and weigh what you find inside.
#> 
#> - **All Possible Components**: The following is a list of all possible tissue components that should be
#> weighed, although not all of them will be present at every harvest: Roots, Leaves, Stems, Pods, Leaf Litter (plant), Stem Litter (plant), Leaf Litter (trap), Stem Litter (trap)
#> 
#> - **Unclear Cases**: If you are unsure about anything while weighing, please
#>   contact the responsible person listed on the harvest record sheet.
```
