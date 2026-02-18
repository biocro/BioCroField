# Access a built-in data record sheet

A convenience function for accessing the data record sheets included
with the `BioCroField` R package.

## Usage

``` r
access_sheet(sheet_name, sheet_type = 'pdf', open_sheet = TRUE)
```

## Arguments

- sheet_name:

  The base name of the sheet to be opened.

- sheet_type:

  The file type of the sheet to be opened.

- open_sheet:

  A logical value indicating whether to open the sheet.

## Details

The selected record sheet will be automatically opened by an appropriate
application when `open_sheet` is set to `TRUE`.

Several sheets are available:

**Log Sheets:**

Log sheets are available as PDFs (`sheet_type = 'pdf'`) or Microsoft
Word documents (`sheet_type = 'word'`).

- `'harvest'`: A data record sheet for recording information from a crop
  harvest.

**Protocol Sheets:**

Protocol sheets are available as PDFs (`sheet_type = 'pdf'`) or
Microsoft Word documents (`sheet_type = 'word'`).

- `'weighing_tissue'`: A general protocol for weighing dry tissue.

**Crop-Specific Guide Sheets:**

Crop-specific guide sheets are only available as PDFs
(`sheet_type = 'pdf'`).

- `'cowpea_guide'`

- `'grain_sorghum_guide'`

- `'maize_guide'`

- `'soybean_guide'`

## Value

The full path to the specified file.

## Examples

``` r
# Get the full paths to all available sheets
access_sheet('harvest', open_sheet = FALSE)
#> [1] "/home/runner/work/_temp/Library/BioCroField/sheets/harvest.pdf"
access_sheet('weighing_tissue', open_sheet = FALSE)
#> [1] "/home/runner/work/_temp/Library/BioCroField/sheets/weighing_tissue.pdf"
access_sheet('cowpea_guide', open_sheet = FALSE)
#> [1] "/home/runner/work/_temp/Library/BioCroField/sheets/cowpea_guide.pdf"
access_sheet('grain_sorghum_guide', open_sheet = FALSE)
#> [1] "/home/runner/work/_temp/Library/BioCroField/sheets/grain_sorghum_guide.pdf"
access_sheet('maize_guide', open_sheet = FALSE)
#> [1] "/home/runner/work/_temp/Library/BioCroField/sheets/maize_guide.pdf"
access_sheet('soybean_guide', open_sheet = FALSE)
#> [1] "/home/runner/work/_temp/Library/BioCroField/sheets/soybean_guide.pdf"

# Open the MS Word version of the harvest data sheet
if (FALSE) { # \dontrun{

access_sheet('harvest', sheet_type = 'word')
} # }
```
