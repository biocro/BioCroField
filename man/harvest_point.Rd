\name{harvest_point}

\alias{harvest_point}

\title{Biomass data from one harvest}

\description{
  TO-DO: provide description, arguments, and details here.
}

\usage{
  harvest_point(
    crop = NA,
    variety = NA,
    location = NA,
    plot = NA,
    year = NA,
    doy = NA,
    hour = 12,
    row_spacing = NA,
    partitioning_nplants = NA,
    partitioning_leaf_area = NA,
    partitioning_component_weights = list(),
    agb_nplants = NA,
    agb_components = character(),
    agb_row_length = NA,
    agb_weight = NA,
    trap_area = NA,
    trap_component_weights = list(),
    \dots
  )
}

\arguments{
  \item{\dots}{
    Any additional arguments to pass to \code{\link{list}} when creating the
    \code{harvest_point} object.
  }
}

\details{
  Blah
}

\value{
  A \code{harvest_point} object as described above.
}

\examples{
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

str(hp)
}

\concept{harvest_point}
