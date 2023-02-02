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

  The following options are available for \code{sheet_name}:
  \itemize{
    \item \code{'harvest'}: A data record sheet for recording information from a
          crop harvest.
  }

  The following opetions are avaialable for \code{sheet_type}:
  \itemize{
    \item \code{'word'}: Will locatate and/or open the Microsoft Word version of
          the sheet.
    \item \code{'pdf'}: Will locate and/or open the PDF version of the sheet.
  }
}

\value{
  The full path to the specified file.
}

\examples{
# Get the full path to the MS Word version of the harvest data sheet
access_sheet('harvest', sheet_type = 'word', open_sheet = FALSE)

# Open the PDF version of the harvest data sheet
\dontrun{

access_sheet('harvest')
}
}
