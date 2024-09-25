\name{generate_crop_guide}

\alias{generate_crop_guide}

\title{Create a crop-specific guide to harvesting and weighing tissue}

\description{
  A convenience function for generating \code{\link[rmarkdown]{rmarkdown}} code
  that can be used to build a PDF document with crop-specific advice for
  harvesting and weighing tissue.
}

\usage{
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
}

\arguments{
  \item{crop_name}{The name of the crop.}

  \item{uses_litter_trap}{
    A logical value indicating whether or not litter traps are used with this
    crop.
  }

  \item{notes}{
    Basic notes about the crop, which will appear just below the title of the
    document.
  }

  \item{harvesting_specific_tissues}{
    A named list, where the name of each element is the name of a tissue type,
    and the value of each element is a string describing how this tissue type
    should be harvested.
  }

  \item{weighing_specific_tissues}{
    A named list, where the name of each element is the name of a tissue type,
    and the value of each element is a string describing how this tissue type
    should be weighed.
  }

  \item{all_possible_weights}{
    A list with two elements named \code{living} and \code{litter}. Each should
    be a string vector describing the possible types of living and senesced
    tissue that might be collected from this crop.
  }

  \item{build}{
    A logical value indicating whether to automatically build the PDF.
  }

  \item{output_dir}{
    A path to the output directory where the PDF should be built (only relevant
    when \code{build} is \code{TRUE}).
  }

  \item{clean}{
    A logical value to be passed to \code{\link[rmarkdown]{render}} when
    building the PDF.
  }
}

\details{
  This function can be used to easily generate a basic guide to harvesting and
  weighing tissue from a particular crop.

  \code{generate_crop_guide} is used internally to generate the crop guides that
  are included with the \code{BioCroField} package. The script used to generate
  the guides is also included with the package and can be located on your
  computer by typing
  \code{system.file('build_crop_sheets.R', package = 'BioCroField')}. See
  \code{\link{access_sheet}} for details about accessing the pre-built guides.

  Ideally, a crop guide should fit on one page so it can be printed and kept on
  hand for reference when harvesting or weighing. When \code{build} is
  \code{TRUE}, a warning will be sent if the resulting PDF is longer than one
  page.

  Building the guide sheets requires LaTeX. If you do not have a system-wide
  LaTeX installation, you may need to use the \code{TinyTex} package. To do
  this, make sure the package is installed and then run
  \code{tinytex::install_tinytex()}. \code{TinyTex} can be installed from CRAN
  by typing code{install.packages('TinyTex')}.
}

\value{
  A text string of \code{\link[rmarkdown]{rmarkdown}} code that can be written
  to a file (with \code{\link{writeLines}}) and then built into a PDF (with
  \code{\link[rmarkdown]{render}}).
}

\examples{
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
}
