# Add the initial values to the data frame:
#   The LD11 seeds were found to weigh 0.NNN g per seed on average, and were
#   planted at a density of PPP seeds per acre. So the initial total biomass
#   was 0.NNN g / seed * PPP seeds / acre = XXX g / acre =
#   XXX g / acre * (1 Mg / 1e6 g) * (2.47 acre / 1 ha) = YYY Mg / ha.
#   We will make the standard Soybean-BioCro assumption about how this is
#   distributed across leaf, stem, and root.

add_seed_biomass <- function(
    biomass_df,
    year,
    doy,
    hour,
    seed_mass,
    planting_density,
    zero_when_missing = c(),
    component_fractions = list(leaf = 0.8, stem = 0.1, root = 0.1)
)
{
    if (!isTRUE(all.equal(sum(as.numeric(component_fractions)), 1))) {
        stop('The component_fractions must add to 1')
    }

    total_initial_biomass <- seed_mass * planting_density * 2.47e-6

    # Initialize a single-row data frame with the same number of columns as
    # biomass_df, but all values set to NA
    initial_biomass <- biomass_df[1, ]
    initial_biomass[1, ] <- NA

    # Reset the crop name, variety, and location, which we can safely assume to
    # be the same across the entire data frame
    initial_biomass$crop <- biomass_df$crop[1]
    initial_biomass$variety <- biomass_df$variety[1]
    initial_biomass$location <- biomass_df$location[1]

    # Specify the time
    initial_biomass$year <- year
    initial_biomass$doy <- doy
    initial_biomass$hour <- hour
    initial_biomass$time <- initial_biomass$doy + initial_biomass$hour / 24.0

    # Reset certain columns to zero; there is no leaf area when the plant is a
    # seed, so also make sure to set LAI to zero
    for (comp in c(zero_when_missing, 'LAI')) {
        initial_biomass[[comp]] <- 0.0
    }

    # Set some column values as fractions of the initial seed mass
    for (comp in names(component_fractions)) {
        initial_biomass[[comp]] <-
            total_initial_biomass * component_fractions[[comp]]
    }

    # Add the initial values as the first row of the biomass data frame
    biomass_df <- rbind(initial_biomass, biomass_df)

    return(biomass_df)
}
