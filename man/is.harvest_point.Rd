\name{is.harvest_point}

\alias{is.harvest_point}

\title{Is an object an harvest_point?}

\description{
  Checks whether an object is an \code{harvest_point} object.
}

\usage{
  is.harvest_point(x)
}

\arguments{
  \item{x}{An R object.}
}

\details{
  This function simply checks to see if \code{'harvest_point'} is in
  \code{class(x)}.
}

\value{
  A logical (TRUE / FALSE) value indicating whether the object is an
  \code{harvest_point} object.
}

\seealso{\code{\link{harvest_point}}}

\examples{
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
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
}

\concept{harvest_point}
