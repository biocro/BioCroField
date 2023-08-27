\name{process}

\alias{process}
\alias{process.harvest_point}

\title{Process raw biomass data from one harvest}

\description{
  This function processes the raw biomass data stored in a
  \code{\link{harvest_point}} object to convert it into more meaningful values.
}

\usage{
  process(x, \dots)

  \method{process}{harvest_point}(x, leaf_name = 'leaf', \dots)
}

\arguments{
  \item{x}{A \code{\link{harvest_point}} object.}

  \item{leaf_name}{
    A string specifying the name of the leaf tissue to use when calculating the
    leaf area index. Typically, the leaf mass is called \code{'leaf'}, but it
    may sometimes have a similar name such as \code{'main_leaf'}.
  }

  \item{\dots}{Additional arguments (currently unused).}
}

\details{
  The \code{process} function attempts to make a variety of calculations using
  the information stored in \code{x}. If some of the possible elements of
  \code{x} are set to \code{\link{NA}}, the relevant calculations that would
  require those pieces of information will simply be skipped, and their outputs
  will be set to \code{NA}. The results of the calculations will be stored as
  new elements in the \code{harvest_point} object.

  The detailed calculations are as follows:
  \itemize{
    \item \code{time}: In BioCro, the time is specified as a fractional day of
          the year calculated by \code{time = doy + hour / 24.0}.

    \item \code{population}: The number of plants per unit ground area (in
          \code{plants / acre} can be estimated from the row spacing and the
          number of plants harvested for above-ground biomass using
          \code{population = agb_nplants / (agb_row_length * row_spacing) * 4047}.
          Here, the factor \code{4047} converts the area basis from \code{m^2}
          to \code{acre} using \code{1 acre = 4047 m^2}.

    \item \code{agb_per_area}: The amount of above-ground biomass per unit
          ground area (in \code{Mg / ha}) in the plot can be estimated from the
          row spacing and the dry mass of the plants harvested for above-ground
          biomass using
          \code{agb_per_area = agb_weight / (agb_row_length * row_spacing) * 1e-2}.
          Here, the factor \code{1e-2} converts from \code{g / m^2} to
          \code{Mg / ha} using \code{1 g / m^2 = 0.01 Mg / ha}.

    \item \code{agb_per_plant_row}: The amount of above-ground biomass per plant
          (in \code{g / plant}) can be estimated from the row section harvested
          for above-ground biomass using
          \code{agb_per_plant_row = agb_weight / agb_nplants}.
          This value can be compared against \code{agb_per_plant_partitioning}
          to get an idea of the variability in plant size throughout the plot.

    \item \code{partitioning_agb_weight}: The above-ground biomass (in \code{g})
          of the plants selected for partitioning can be obtained by adding
          the partitioning component weights for the components that are
          designated as being part of the above-ground biomass. For example, if
          \code{partitioning_component_weights = list(leaf = 1, stem = 2, root = 0.5)}
          and \code{agb_components = c('leaf', 'stem')}, then the above-ground
          biomass from the partitioned plants would be \code{1 + 2 = 3}. In
          other words, the \code{root} mass would not be included.

    \item \code{agb_per_plant_partitioning}: The amount of above-ground biomass
          per plant (in \code{g / plant}) can be estimated from the partitioned
          plants using
          \code{agb_per_plant_partitioning = partitioning_agb_weight / agb_nplants}.
          This value can be compared against \code{agb_per_plant_row} to get an
          idea of the variability in plant size throughout the plot.

    \item \code{relative_components}: The relative mass (dimensionless from
          \code{g / g}; normalized to the above-ground biomass) for each
          partitioned component can be obtained by dividing each component's dry
          mass by \code{partitioning_agb_weight}. For example, if
          \code{partitioning_component_weights = list(leaf = 1, stem = 2, root = 0.5)}
          and \code{agb_components = c('leaf', 'stem')}, then
          \code{partitioning_agb_weight = 3} and
          \code{relative_components = list(leaf = 1 / 3, stem = 2 / 3, root = 0.5 / 3)}.

    \item \code{components_biocro}: The biomass per unit ground area (in
          \code{Mg / ha}, the units used in BioCro) can be obtained by
          multiplying each element of \code{relative_components} by
          \code{agb_per_area}.

    \item \code{LMA}: The leaf mass per unit leaf area (LMA; in units of
          \code{g / m^2}) can be calculated from the mass and area of the
          partitioned leaves using
          \code{LMA = partitioning_component_weights$leaf / partitioning_leaf_area * 1e4}.
          Here, the factor \code{1e-4} converts from \code{g / cm^2} to
          \code{g / m^2} using \code{1 g / cm^2 = 1e-4 g / m^2}.

    \item \code{LAI_from_LMA}: The leaf area per unit ground area, which is
          referred to as the leaf area index (LAI; dimensionless from
          \code{m^2 / m^2}), can be calculated from the leaf mass per unit area
          and the LMA using \code{LAI = components_biocro$leaf / LMA * 1e2}.
          Here, the factor \code{1e2} converts the leaf mass per unit area from
          \code{Mg / ha} to \code{g / m^2} using \code{1 Mg / ha = 100 g / m^2}.
          This estimate of LAI can be compared to the estimates based on target
          or measured population, which are stored as
          \code{LAI_from_planting_density} and
          \code{LAI_from_measured_population}, respectively.

    \item \code{leaf_area_per_plant}: The leaf area per plant in
          \code{cm^2 / plant} can be calculated from the partitioning leaf area
          and the number of plants that were partitioned.

    \item \code{LAI_from_planting_density}: The LAI can be estimated from the
          target population and the leaf area per plant using
          \code{LAI = planting_density * leaf_area_per_plant * 1e-4 / 4047}.
          Here, the factor \code{1e-4} converts leaf area from \code{cm^2} to
          \code{m^2} and the factor \code{1 / 4047} converts population from
          \code{plants / acre} to \code{plants / m^2}. This estimate of LAI can
          be compared to the estimates based on LMA or measured population,
          which are stored as \code{LAI_from_LMA} and
          \code{LAI_from_measured_population}, respectively.

    \item \code{LAI_from_measured_population}: The LAI can be estimated from the
          measured population and the leaf area per plant using
          \code{LAI = population * leaf_area_per_plant * 1e-4}. Here, the
          factor \code{1e-4} converts leaf area from \code{cm^2} to \code{m^2}.
          This estimate of LAI can be compared to the estimates based on LMA or
          target population, which are stored as \code{LAI_from_LMA} and
          \code{LAI_from_planting_density}, respectively.

    \item \code{SLA}: The leaf mass per unit leaf area, which is referred to as
          the specific leaf area (SLA; in units of \code{ha / Mg}), can be
          calculated from LMA using \code{SLA = 1 / LMA * 1e2} where the factor
          \code{1e2} converts the units from \code{m^2 / g} to \code{ha / Mg}.

    \item \code{trap_components_biocro}: The biomass per unit ground area for
          the tissue types collected in the litter trap (in units of
          \code{Mg / ha}) can be calculated by dividing the dry mass of each
          component by the litter trap area and multiplying by \code{1e-2} to
          convert from \code{g / m^2} to \code{Mg / ha}.

    \item \code{all_components_biocro}: The biomass per unit ground area (in
          \code{Mg / ha}) for all plant tissue types included in
          \code{components_biocro} and \code{trap_components_biocro} is stored
          in \code{all_components_biocro}. If a component is present in both
          lists, the separate values will be added together. For example,
          \code{components_biocro} may include a \code{leaf_litter} component
          that represents the biomass of senesced leaves that are still attached
          to the plants, while \code{trap_components_biocro} may contain a
          \code{leaf_litter} component representing the biomass of senesced
          leaves that have fallen off the plant; in this case, the value of
          \code{leaf_litter} in \code{all_components_biocro} will be the sum of
          the two separate leaf litter biomass values.
  }

  A note about LAI estimates: LAI estimated using LMA is the most accurate of
  the three methods, and is commonly used when estimating LAI from destructive
  leaf area measurements (Bréda 2003). When mass values are unavailable, it may
  not be possible to use this method; in that case, the estimates based on
  population can be used instead. When enough information is available to make
  all three estimates, they can be compared to each other as a consistency
  check or to estimate upper and lower bounds on the LAI.

  References:
  \itemize{
    \item Bréda, N. J. J. "Ground-based measurements of leaf area index: a
          review of methods, instruments and current controversies." Journal of
          Experimental Botany 54, 2403–2417 (2003)
          [\doi{https://doi.org/10.1093/jxb/erg263}].
  }

}

\value{
  A \code{\link{harvest_point}} object with new elements as described above.
}

\seealso{\code{\link{harvest_point}}}

\examples{
# Example: Creating and processing a harvest_point object that includes
# (optional) comments about the stem and the leaf litter.
hp <- harvest_point(
  crop = 'soybean',
  variety = 'ld11',
  location = 'energy farm',
  plot = 1,
  year = 2023,
  doy = 186,
  hour = 12,
  planting_density = 140000,
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

str(hpp)

# Example: Creating and processing a harvest point object that has `main_leaf`
# rather than `leaf`.
hp2 <- harvest_point(
  partitioning_component_weights = list(main_leaf = 1),
  partitioning_leaf_area = 2
)

print(process(hp2)$LMA)              # returns NA because no leaf weight was found
print(process(hp2, 'main_leaf')$LMA) # returns the correct value
}

\concept{harvest_point}
