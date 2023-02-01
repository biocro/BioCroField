\name{biomass_table}

\alias{biomass_table}
\alias{biomass_table.harvest_point}

\title{Process raw biomass data from one harvest}

\description{
  TO-DO: provide description, arguments, and details here.
}

\usage{
  biomass_table(\dots, zero_when_missing = c())

  \method{biomass_table}{harvest_point}(\dots, zero_when_missing = c())
}

\arguments{
  \item{\dots}{One or more \code{\link{harvest_point}} objects.}
}

\details{
  Blah
}

\value{
  A \code{\link{data.frame}} as described above.
}

\seealso{\code{\link{harvest_point}}}

\examples{
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
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

hpp <- process(hp)

biomass <- biomass_table(hpp, hpp)

str(biomass)
}

\concept{harvest_point}
