\name{harvest_point}

\alias{harvest_point}

\title{Biomass data from one harvest}

\description{
  This S3 class is designed to store the information from a crop harvest data
  sheet (see \code{\link{access_sheet}}) in an R data structure. Thus, it
  represents biomass and leaf area measurements collected from a single plot at
  a single time.
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
    target_population = NA,
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
  \item{crop}{A name for the crop, such as \code{'soybean'}.}

  \item{variety}{A name for the crop variety, such as \code{'ld11'}.}

  \item{location}{A name for the crop's location, such as \code{'energy farm'}.}

  \item{plot}{A name for the plot that was harvested, such as \code{2}.}

  \item{year}{The year the crop was grown, such as \code{2022}.}

  \item{doy}{The day of year when the plot was harvested, such as \code{180}.}

  \item{hour}{The hour of the day when the plot was harvested.}

  \item{target_population}{
    The intended number of plants per unit ground area in \code{plants / acre};
    typically this is the seed density, which may be different than the actual
    plant population due to seeds that fail to emerge (reduces actual
    population) or accidental double-planting (increases actual population).
  }

  \item{row_spacing}{The spacing between rows in the plot (in \code{m}).}

  \item{partitioning_nplants}{The number of plants chosen for partitioning.}

  \item{partitioning_leaf_area}{
    The total leaf area from the partitioned plants (in \code{cm^2}).
  }

  \item{partitioning_component_weights}{
    A list of named numeric elements, where the name of each element indicates a
    plant component (such as \code{'leaf'}) and the value of each element
    indicates its dry weight as measured from the partitioned plants (in
    \code{g}).
  }

  \item{agb_nplants}{The number of plants harvested for above-ground biomass.}

  \item{agb_components}{
    A character vector indicating the partitioned components that should be
    added together to determine the above-ground biomass of the partitioned
    plants.
  }

  \item{agb_row_length}{
    The length of row harvested for above-ground biomass (in \code{m}).
  }

  \item{agb_weight}{
    The weight of the row section harvested for above-ground biomass (in
    \code{g}).
  }

  \item{trap_area}{The area of the litter trap (in \code{m^2}).}

  \item{trap_component_weights}{
    A list of named numeric elements, where the name of each element indicates a
    plant litter component (such as \code{'leaf_litter'}) and the value of each
    element indicates its dry weight as measured from the litter trap contents
    (in \code{g}).
  }

  \item{\dots}{
    Any additional arguments (such as comments) to include in the
    \code{harvest_point} object.
  }
}

\details{
  From a technical point of view, a \code{harvest_point} object is simply an R
  list with a particular set of named elements, so it can be viewed and modified
  using any standard R commands that apply to lists. All of its input arguments
  are optional, so a user only needs to enter information that was actually
  measured. Typically, a \code{harvest_point} object is passed to
  \code{\link{process}} to convert the raw measurements into more useful
  quantities like the mass per unit area and leaf area index.
}

\value{
  A \code{harvest_point} object as described above.
}

\examples{
# Example: Creating a harvest_point object that includes (optional) comments
# about the stem and the leaf litter.
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
  plot = 1,
  year = 2023,
  doy = 186,
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

str(hp)
}

\concept{harvest_point}
