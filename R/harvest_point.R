# This file defines a constructor for the harvest_point class and some essential
# S3 methods. A `harvest_point` is just a list with a particular set of named
# elements that together specify a full set of biomass measurements from one
# harvest.

# Constructor
harvest_point <- function(
    crop = NA,
    variety = NA,
    location = NA,
    plot = NA,
    year = NA,
    doy = NA,
    hour = 12,
    row_spacing = NA,
    partitioning_nplants = NA,
    partitioning_leaf_area = NA,
    partitioning_component_weights = list(),
    agb_nplants = NA,
    agb_components = list(),
    agb_row_length = NA,
    agb_weight = NA,
    trap_area = NA,
    trap_component_weights = list(),
    ...
)
{
    # TO-DO:
    # - Actually make these checks.
    # - Check to make sure the `agb_components` are included in the
    #   `partitioning_component_weights`.
    # - Check to make sure numeric values are positive.
    # - Supply more defaults.
    should_be_numeric <- list(
        year = year,
        doy = doy,
        hour = hour,
        row_spacing = row_spacing,
        partitioning_nplants = partitioning_nplants,
        partitioning_leaf_area = partitioning_leaf_area,
        agb_nplants = agb_nplants,
        agb_row_length = agb_row_length,
        agb_weight = agb_weight,
        trap_area = trap_area
    )

    should_be_character <- list(
        crop = crop,
        variety = variety,
        location = location,
        plot = plot,
        agb_components = agb_components
    )

    should_be_list_named_numeric <- list(
        partitioning_component_weights = partitioning_component_weights,
        trap_component_weights = trap_component_weights
    )

    # Assemble all the information into a list of named elements
    hp <- list(
        crop = crop,
        variety = variety,
        location = location,
        plot = plot,
        year = year,
        doy = doy,
        hour = hour,
        row_spacing = row_spacing,
        partitioning_nplants = partitioning_nplants,
        partitioning_leaf_area = partitioning_leaf_area,
        partitioning_component_weights = partitioning_component_weights,
        agb_components = agb_components,
        agb_nplants = agb_nplants,
        agb_row_length = agb_row_length,
        agb_weight = agb_weight,
        trap_area = trap_area,
        trap_component_weights = trap_component_weights,
        ...
    )

    # Specify the class and return the object
    class(hp) <- c("harvest_point", class(hp))
    return(hp)

}

# Check if an object is an harvest_point
is.harvest_point <- function(x) {
    # Make sure the class of x includes `harvest_point`
    inherits(x, "harvest_point")
}
