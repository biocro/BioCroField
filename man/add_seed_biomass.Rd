\name{add_seed_biomass}

\alias{add_seed_biomass}

\title{Initial biomass from seed information}

\description{
  TO-DO: provide description, arguments, and details here.
}

\usage{
  add_seed_biomass(
    biomass_df,
    year,
    doy,
    hour,
    seed_mass,
    planting_density,
    zero_when_missing = c(),
    component_fractions = list(leaf = 0.8, stem = 0.1, root = 0.1)
  )
}

\arguments{
  \item{biomass_df}{
    A data frame assumed to have been created by \code{\link{biomass_table}}.
  }
}

\details{
  Blah
}

\value{
  A data frame as described above.
}

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

biomass <- add_seed_biomass(
  biomass,
  year = 2023,
  doy = 152,
  hour = 12,
  seed_mass = 0.17,
  planting_density = 125000
)

str(biomass)
}

\concept{harvest_point}
