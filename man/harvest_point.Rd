\name{harvest_point}

\alias{harvest_point}

\title{Biomass data from one harvest}

\description{
  TO-DO: provide description, arguments, and details here.
}

\usage{
  harvest_point(
    crop,
    variety,
    location,
    plot,
    year,
    doy,
    hour,
    row_spacing,
    partitioning_leaf_area,
    partitioning_component_weights,
    agb_components,
    agb_row_length,
    agb_weight,
    trap_area,
    trap_component_weights,
    partitioning_nplants = NA,
    agb_nplants = NA,
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