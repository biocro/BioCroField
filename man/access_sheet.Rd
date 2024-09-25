\name{access_sheet}

\alias{access_sheet}

\title{Access a built-in data record sheet}

\description{
  A convenience function for accessing the data record sheets included with the
  \code{BioCroField} R package.
}

\usage{
  access_sheet(sheet_name, sheet_type = 'pdf', open_sheet = TRUE)
}

\arguments{
  \item{sheet_name}{The base name of the sheet to be opened.}

  \item{sheet_type}{The file type of the sheet to be opened.}

  \item{open_sheet}{A logical value indicating whether to open the sheet.}
}

\details{
  The selected record sheet will be automatically opened by an appropriate
  application when \code{open_sheet} is set to \code{TRUE}.

  Several sheets are available:

  \strong{Log Sheets:}

  Log sheets are available as PDFs (\code{sheet_type = 'pdf'}) or Microsoft Word
  documents (\code{sheet_type = 'word'}).

  \itemize{
    \item \code{'harvest'}: A data record sheet for recording information from a
          crop harvest.
  }

  \strong{Protocol Sheets:}

  Protocol sheets are available as PDFs (\code{sheet_type = 'pdf'}) or Microsoft
  Word documents (\code{sheet_type = 'word'}).

  \itemize{
    \item \code{'weighing_tissue'}: A general protocol for weighing dry tissue.
  }

  \strong{Crop-Specific Guide Sheets:}

  Crop-specific guide sheets are only available as PDFs
  (\code{sheet_type = 'pdf'}).

  \itemize{
    \item \code{'cowpea_guide'}
    \item \code{'grain_sorghum_guide'}
    \item \code{'maize_guide'}
    \item \code{'soybean_guide'}
  }
}

\value{
  The full path to the specified file.
}

\examples{
# Get the full paths to all available sheets
access_sheet('harvest', open_sheet = FALSE)
access_sheet('weighing_tissue', open_sheet = FALSE)
access_sheet('cowpea_guide', open_sheet = FALSE)
access_sheet('grain_sorghum_guide', open_sheet = FALSE)
access_sheet('maize_guide', open_sheet = FALSE)
access_sheet('soybean_guide', open_sheet = FALSE)

# Open the MS Word version of the harvest data sheet
\dontrun{

access_sheet('harvest', sheet_type = 'word')
}
}
