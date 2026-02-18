process <- function(x, ...) {
    UseMethod('process', x)
}

# Notes:
# - 1 g / m^2 * (1 Mg / 1e6 g) * (1e4 m^2 / 1 ha) = 1e-2 Mg / ha
# - 1 m^2 / g * (1e6 g / 1 Mg) * (1 ha / 1e4 m^2) = 1e2 ha / Mg
# - 1 g / cm^2 * (100 cm / m)^2 = 1e4 g / m^2
process.harvest_point <- function(x, leaf_name = 'leaf', ...) {
    # In this function, we won't do any type checking; we can assume that has
    # been addressed by `harvest_point`. Instead, the main goal is to make sure
    # that we can handle incomplete information in the inputs.

    # The time (as specified in BioCro)
    time_list <- list(doy = x[['doy']], hour = x[['hour']])
    time_list <- BioCro::add_time_to_weather_data(time_list)
    time <- time_list[['time']]

    # Above-ground biomass from the plants that were partitioned (in g)
    partitioning_agb_weight <- if (length(x[['agb_components']]) > 0) {
        sum(as.numeric(x[['partitioning_component_weights']][x[['agb_components']]]))
    } else {
        NA
    }

    # Compare above-ground biomass per plant among the plants used for
    # partitioning and the section of row used for above-ground biomass.
    agb_per_plant_partitioning <-
        partitioning_agb_weight / x[['partitioning_nplants']]

    agb_per_plant_row <- x[['agb_weight']] / x[['agb_nplants']]

    # Estimate the plant population (plants per acre) from the number of plants
    # collected for above-ground biomass measurements, using 1 acre = 4047 m^2
    measured_population <- x[['agb_nplants']] / (x[['agb_row_length']] * x[['row_spacing']]) * 4047

    # Calculate the above-ground biomass per unit area (in Mg / ha), using
    # 1 g / m^2 = 1e-2 Mg / ha
    agb_per_area <- x[['agb_weight']] / (x[['agb_row_length']] * x[['row_spacing']]) * 1e-2

    # Relative component weights from plants that were partitioned, normalized
    # by the above-ground biomass from those plants
    relative_components <- lapply(
        x[['partitioning_component_weights']],
        function(pcw) {pcw / partitioning_agb_weight}
    ) # dimensionless from m / (m agb)

    # Mass per unit area for the partitioned components (in Mg / Ha)
    components_biocro <- lapply(
        relative_components,
        function(rc) {rc * agb_per_area}
    ) # Mg / ha

    # Leaf mass per leaf area (in g / m^2). We should only calculate this if
    # there is a partitioned leaf mass and a partitioned leaf area; even in that
    # case, if the leaf area is not positive, we still should not calculate LMA.
    LMA <- if(!is.null(x[['partitioning_component_weights']][[leaf_name]]) && !is.na(x[['partitioning_leaf_area']])) {
        if (x[['partitioning_leaf_area']] > 0) {
                x[['partitioning_component_weights']][[leaf_name]] /
                    x[['partitioning_leaf_area']] * 1e4 # g / m^2
        } else {
            NA
        }
    } else {
        NA
    }

    # Leaf area index. Units are dimensionless from
    # (g / m^2 ground) / (g / m^2 leaf). We should only calculate this if there
    # is a leaf mass per ground area and a partitioned leaf area; in that case,
    # LAI_from_LMA should be set to zero when the leaf area is zero.
    LAI_from_LMA <- if(!is.null(components_biocro[[leaf_name]]) && !is.na(x[['partitioning_leaf_area']])) {
        if (x[['partitioning_leaf_area']] > 0) {
            components_biocro[[leaf_name]] / LMA * 1e2
        } else {
            0.0
        }
    } else {
        NA
    }

    # Leaf area per plant. Units are cm^2 / plant.
    leaf_area_per_plant <- x[['partitioning_leaf_area']] / x[['partitioning_nplants']]

    # Leaf area index estimated from planting density. Units are dimensionless
    # from (plants / acre ground) * (cm^2 leaf / plant) * (1 m^2 / 1e4 cm^2) * (1 acre / 4047 m^2)
    LAI_from_planting_density <-
        x[['planting_density']] * leaf_area_per_plant * 1e-4 / 4047

    # Leaf area index estimated from measured population. Units are
    # dimensionless as for leaf area index estimated from measured population.
    LAI_from_measured_population <-
        measured_population * leaf_area_per_plant * 1e-4 / 4047

    # Specific leaf area in the units typically used in BioCro
    SLA <- 1 / LMA * 1e2 # ha / Mg

    # Biomass from litter trap in units typically used in BioCro
    trap_components_biocro <- lapply(
        x[['trap_component_weights']],
        function(tcw) {tcw / x[['trap_area']] * 1e-2}
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
        agb_per_plant_partitioning = agb_per_plant_partitioning,
        agb_per_plant_row = agb_per_plant_row,
        measured_population = measured_population,
        agb_per_area = agb_per_area,
        relative_components = relative_components,
        components_biocro = components_biocro,
        LMA = LMA,
        LAI_from_LMA = LAI_from_LMA,
        LAI_from_planting_density = LAI_from_planting_density,
        LAI_from_measured_population = LAI_from_measured_population,
        leaf_area_per_plant = leaf_area_per_plant,
        SLA = SLA,
        trap_components_biocro = trap_components_biocro,
        all_components_biocro = all_components_biocro
    )

    for (name in names(new_info)) {
        x[[name]] <- new_info[[name]]
    }

    return(x)
}
