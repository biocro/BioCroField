\name{biomass_table}

\alias{biomass_table}
\alias{biomass_table.harvest_point}

\title{Reorganize harvest point data into a table}

\description{
  This function reorganizes the information contained in one or more
  \code{\link{harvest_point}} objects into a \code{data.frame}.
}

\usage{
  biomass_table(\dots, zero_when_missing = character())

  \method{biomass_table}{harvest_point}(\dots, zero_when_missing = character())
}

\arguments{
  \item{\dots}{One or more \code{\link{harvest_point}} objects.}

  \item{zero_when_missing}{
    A character vector indicating any biomass columns whose values should be set
    to zero when they were not explicitly measured. For example, early harvest
    data points for soybeans may not include a value for \code{pod}; by default,
    \code{pod} would be set to \code{NA} for these points, but it would make
    more sense to set it to 0.
  }
}

\details{
  The following \code{harvest_point} elements will be included as columns in the
  final \code{data.frame}, where each row represents the information from one of
  the \code{harvest_point} objects passed to \code{biomass_table}:
  \itemize{
    \item \code{crop}

    \item \code{variety}

    \item \code{location}

    \item \code{plot}

    \item \code{year}

    \item \code{doy}

    \item \code{hour}

    \item \code{time}

    \item \code{SLA}

    \item \code{LAI_from_LMA}

    \item \code{LAI_from_target_population}

    \item \code{LAI_from_measured_population}

    \item \code{agb_per_plant_row}

    \item \code{agb_per_plant_partitioning}

    \item \code{population}

    \item Any elements contained in \code{components_biocro} (see
          \code{\link{process}})

    \item Any additional arguments (such as comments) that were passed to
          \code{\link{harvest_point}} when creating the data points
  }

  See \code{\link{harvest_point}} and \code{\link{process}} for more information
  about these elements. In general, any missing values will be set to \code{NA}
  in the final \code{data.frame}.
}

\value{
  A \code{\link{data.frame}} as described above.
}

\seealso{\code{\link{harvest_point}}}

\examples{
# Example: Creating, processing, and reorganizing a harvest_point object that
# includes (optional) comments about the stem and the leaf litter.
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
  plot = 1,
  year = 2023,
  doy = 186,
  hour = 12,
  target_population = 140000,
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

str(biomass)
}

\concept{harvest_point}
