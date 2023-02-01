process <- function(x) {
    UseMethod('process', x)
}

# Get the relative weights and LMA values. Here we make the following
# calculations:
# - agb_weight is the total weight of the partitioning component weights that
#   are designated as being part of the aboveground biomass, in g
# - relative_components is the weight of each partitioning component relative to
#   the partitioning aboveground biomass (dimensionless)
# - components_per_row are the weight of each component in g per meter of row,
#   determined by multipling the measured agb per meter by the relative
#   component fractions.
# - components_per_area is the weight of each component in g per square meter of
#   field, determined by dividing the weight per row by the row spacing in m.
# - components_biocro is the weight per area converted to biocro units (Mg / ha)
# - LMA is the leaf mass per area in g / m^2
# - LAI is the leaf area index (m^2 leaf / m^2 ground)
# - SLA is the specific leaf area in ha / Mg
# - agb_per_plant_row is the average aboveground mass per plant along the
#   section of row
# - agb_per_plant_partitioning is the average aboveground mass per plant among
#   the plants selected for partitioning
#
# Notes:
# - 1 g / m^2 * (1 Mg / 1e6 g) * (1e4 m^2 / 1 ha) = 1e-2 Mg / ha
# - 1 m^2 / g * (1e6 g / 1 Mg) * (1 ha / 1e4 m^2) = 1e2 ha / Mg
# - 1 g / cm^2 * (100 cm / m)^2 = 1e4 g / m^2
process.harvest_point <- function(x) {
    # TO-DO: account for possibility that some pieces of information are not
    # present

    # The time (as specified in BioCro)
    time <- x$doy + x$hour / 24.0

    # Above-ground biomass from the plants that were partitioned (in g)
    partitioning_agb_weight <-
        sum(as.numeric(x$partitioning_component_weights[x$agb_components]))

    # Compare above-ground biomass per plant among the plants used for
    # partitioning and the section of row used for above-ground biomass.
    agb_per_plant_partitioning <- if (!is.na(x$partitioning_nplants)) {
        partitioning_agb_weight / x$partitioning_nplants
    } else {
        NA
    }

    agb_per_plant_row = if (!is.na(x$agb_nplants)) {
        x$agb_weight / x$agb_nplants
    } else {
        NA
    }

    # Relative component weights from plants that were partitioned, normalized
    # by the above-ground biomass from those plants
    relative_components <- lapply(
        x$partitioning_component_weights,
        function(pcw) {pcw / partitioning_agb_weight}
    ) # dimensionless from m / (m agb)

    # Estimated weight per unit row length for each component
    components_per_row <- lapply(
        relative_components,
        function(rc) {rc * x$agb_weight / x$agb_row_length}
    ) # g / m

    # Estimated weight per unit area for each component
    components_per_area <- lapply(
        components_per_row,
        function(cpr) {cpr / x$row_spacing}
    ) # g / m^2

    # Convert the weight per unit area to the units typically used in BioCro
    components_biocro <- lapply(
        components_per_area,
        function(cpa) {cpa * 1e-2}
    ) # Mg / ha

    # Leaf mass per area
    LMA <- if (x$partitioning_leaf_area > 0) {
        x$partitioning_component_weights$leaf /
            x$partitioning_leaf_area * 1e4 # g / m^2
    } else {
        NA
    }

    # Leaf area index. Units are dimensionless from
    # (g / m^2 ground) / (g / m^2 leaf)
    LAI <- if (x$partitioning_leaf_area > 0) {
        components_per_area$leaf / LMA
    } else {
        0
    }

    # Specific leaf area in the units typically used in BioCro
    SLA <- 1 / LMA * 1e2 # ha / Mg

    # Biomass from litter trap
    trap_components_per_area <- lapply(
        x$trap_component_weights,
        function(tcw) {tcw / x$trap_area}
    ) # g / m^2

    # Convert the trap components per area to units typically used in BioCro
    trap_components_biocro <- lapply(
        trap_components_per_area,
        function(tcpa) {tcpa * 1e-2}
    ) # Mg / ha

    # Combine all components
    all_components_biocro <- components_biocro

    for (tn in names(trap_components_biocro)) {
        if (tn %in% names(components_biocro)) {
            all_components_biocro[[tn]] <-
                components_biocro[[tn]] + trap_components_biocro[[tn]]
        } else {
            all_components_biocro[[tn]] <- trap_components_biocro[[tn]]
        }
    }

    # Add the newly-calculated information to the harvest_point
    new_info <- list(
        time = time,
        partitioning_agb_weight = partitioning_agb_weight,
        relative_components = relative_components,
        components_per_row = components_per_row,
        components_per_area = components_per_area,
        components_biocro = components_biocro,
        LMA = LMA,
        LAI = LAI,
        SLA = SLA,
        trap_components_per_area = trap_components_per_area,
        trap_components_biocro = trap_components_biocro,
        all_components_biocro = all_components_biocro,
        agb_per_plant_partitioning = agb_per_plant_partitioning,
        agb_per_plant_row = agb_per_plant_row
    )

    for (name in names(new_info)) {
        x[[name]] <- new_info[[name]]
    }

    return(x)
}
