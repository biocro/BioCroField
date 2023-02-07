\name{add_seed_biomass}

\alias{add_seed_biomass}

\title{Initial biomass from seed information}

\description{
  Adds a new row to a \code{data.frame} created by \code{\link{biomass_table}}
  that represents the initial seed biomass.
}

\usage{
  add_seed_biomass(
    biomass_df,
    year = NA,
    doy = NA,
    hour = 12,
    seed_mass = NA,
    planting_density = NA,
    zero_when_missing = character(),
    component_fractions = list(),
    \dots
  )
}

\arguments{
  \item{biomass_df}{
    A data frame assumed to have been created by \code{\link{biomass_table}}.
  }

  \item{year}{The year the crop was grown, such as \code{2022}.}

  \item{doy}{The day of year when the plot was sown, such as \code{150}.}

  \item{hour}{The hour of the day when the plot was sown.}

  \item{seed_mass}{
    The average mass per seed (in \code{g}), typically determined by weighing a
    known number of seeds (such as one hundred seeds).
  }

  \item{planting_density}{The number of seeds sown per acre.}

  \item{zero_when_missing}{
    A character vector indicating any biomass columns whose values should be set
    to zero when they were not explicitly measured.
  }

  \item{component_fractions}{
    A list of named numeric elements whose values must add to 1. For BioCro
    simulations, it is often necessary to estimate the initial leaf, stem, and
    root biomass as fractions of the original seed biomass. For example, if we
    assume that the initial mass is 80% leaf, 10% stem, and 10% root, we would
    set \code{component_fractions} to
    \code{list(leaf = 0.8, stem = 0.1, root = 0.1)}.
  }

  \item{\dots}{
    Any additional arguments (such as comments) to include as columns in the new
    row.
  }
}

\details{
  The new row in the data table will be constructed as follows:
  \itemize{
    \item The values of the \code{crop}, \code{variety}, and \code{location}
          will be copied from the first row of \code{biomass_df}.

    \item The values of \code{year}, \code{doy}, and \code{hour} will be taken
          from the inputs; the value of \code{time} will be calculated as in
          \code{\link{process}}.

    \item The value of \code{LAI} will be set to 0 since there cannot be any
          leaf area corresponding to seeds that were just sown.

    \item The initial seed biomass per unit ground area (in \code{Mg / ha}) will
          be stored in a new column called \code{initial_seed}. This value is
          calculated using
          \code{initial_seed = seed_mass * planting_density * 2.47e-6}, where
          the factor \code{2.47e-6} converts from \code{g / acre} to
          \code{Mg / ha} using \code{1 g / acre = 2.47e-6 Mg / ha}.

    \item If component fractions were specified, the values of those columns
          will be set to the corresponding fractions of \code{initial_seed}.
  }
}

\value{
  A data frame as described above.
}

\examples{
# Example: Creating and processing a harvest_point object that includes
# (optional) comments about the stem and the leaf litter, and then adding an
# initial seed biomass (and another comment).
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
  partitioning_component_weights = list(leaf = 2.5, stem = 1.5, root = 1.4, leaf_litter = 0.2),
  agb_components = c('leaf', 'stem'),
  agb_row_length = 2,
  agb_weight = 50,
  trap_area = 0.185,
  trap_component_weights = list(leaf_litter = 0.4, stem_litter = 0.5),
  partitioning_nplants = 6,
  agb_nplants = 50,
  stem_comment = 'The stem weight includes petioles',
  stem_litter_comment = 'The stem litter is entirely petioles',
  leaf_litter_comment = 'Senesced leaves were present on the plants and in the trap'
)

hpp <- process(hp)

biomass <- biomass_table(hpp)

biomass <- add_seed_biomass(
  biomass,
  year = 2023,
  doy = 152,
  hour = 12,
  seed_mass = 0.17,
  planting_density = 125000,
  component_fractions = list(leaf = 0.8, stem = 0.1, root = 0.1),
  seed_comment = 'Sown with precision planter'
)

str(biomass)
}

\concept{harvest_point}
