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
    planting_density = NA,
    row_spacing = NA,
    plant_spacing = NA,
    partitioning_nplants = NA,
    partitioning_leaf_area = NA,
    partitioning_component_weights = list(),
    agb_nplants = NA,
    agb_components = character(),
    agb_row_length = NA,
    agb_weight = NA,
    trap_area = NA,
    trap_component_weights = list(),
    ...
)
{
    # Get any additional arguments
    additional_arguments = list(...)

    # Make sure the component weights and the extras are lists and have names
    named_list_required <- list(
        partitioning_component_weights = partitioning_component_weights,
        trap_component_weights = trap_component_weights,
        additional_arguments = additional_arguments
    )

    list_bad <- sapply(named_list_required, function(x) {!is.list(x)})

    names_bad <- sapply(named_list_required, function(x) {
        if (length(x) > 0) {
            if (is.null(names(x))) {
                TRUE
            } else {
                any(sapply(names(x), function(n) {is.na(n) || is.null(n) || n == ""}))
            }
        } else {
            FALSE
        }
    })

    named_list_bad <- list_bad | names_bad

    if (any(named_list_bad)) {
        msg <- paste(
            'The following inputs should be lists of named elements, but are not:',
            paste(names(named_list_required)[named_list_bad], collapse = ', ')
        )
        stop(msg)
    }

    # Make sure certain inputs have length 1
    should_have_length_1 <- c(
        list(
            crop = crop,
            variety = variety,
            location = location,
            plot = plot,
            year = year,
            doy = doy,
            hour = hour,
            planting_density = planting_density,
            row_spacing = row_spacing,
            plant_spacing = plant_spacing,
            partitioning_nplants = partitioning_nplants,
            partitioning_leaf_area = partitioning_leaf_area,
            agb_nplants = agb_nplants,
            agb_row_length,
            agb_weight,
            trap_area
        ),
        additional_arguments
    )

    length_bad <- sapply(should_have_length_1, function(x) {length(x) != 1})

    if (any(length_bad)) {
        msg <- paste(
            'The following inputs should have length 1, but do not:',
            paste(names(should_have_length_1)[length_bad], collapse = ', ')
        )
        stop(msg)
    }

    # Make sure certain inputs are numeric, character, or NA
    should_be_ncna <- c(
        list(
            crop = crop,
            variety = variety,
            location = location,
            plot = plot
        ),
        additional_arguments
    )

    ncna_bad <- sapply(should_be_ncna, function(x) {
        !is.numeric(x) && !is.character(x) && !is.na(x)
    })

    if (any(ncna_bad)) {
        msg <- paste(
            'The following inputs should be numeric, character, or NA, but are not:',
            paste(names(should_be_ncna)[ncna_bad], collapse = ', ')
        )
        stop(msg)
    }

    # Make sure certain inputs are numeric or NA; if they are numeric, they
    # should also be positive
    should_be_nna <- list(
        year = year,
        doy = doy,
        hour = hour,
        planting_density = planting_density,
        row_spacing = row_spacing,
        plant_spacing = plant_spacing,
        partitioning_nplants = partitioning_nplants,
        partitioning_leaf_area = partitioning_leaf_area,
        agb_nplants = agb_nplants,
        agb_row_length,
        agb_weight,
        trap_area
    )

    nna_bad <- sapply(should_be_nna, function(x) {
        !is.numeric(x) && !is.na(x)
    })

    if (any(nna_bad)) {
        msg <- paste(
            'The following inputs should be numeric or NA, but are not:',
            paste(names(should_be_nna)[nna_bad], collapse = ', ')
        )
        stop(msg)
    }

    neg_bad <- sapply(should_be_nna, function(x) {
        is.numeric(x) && x < 0
    })

    if (any(neg_bad)) {
        msg <- paste(
            'The following inputs are numeric and therefore should be positive, but are not:',
            paste(names(should_be_nna)[neg_bad], collapse = ', ')
        )
        stop(msg)
    }

    # Make sure certain inputs are character
    should_be_c <- list(
        agb_components = agb_components
    )

    c_bad <- sapply(should_be_c, function(x) {!is.character(x)})

    if (any(c_bad)) {
        msg <- paste(
            'The following inputs should be character, but are not:',
            paste(names(should_be_c)[c_bad], collapse = ', ')
        )
        stop(msg)
    }

    # Make sure the agb_components are included in the
    # partitioning_component_weights
    agb_component_bad <- sapply(agb_components, function(x) {
        !x %in% names(partitioning_component_weights)
    })

    if (any(agb_component_bad)) {
        msg <- paste(
            'The following elements of `agb_components` are not present in `partitioning_component_weights`:',
            paste(agb_components[agb_component_bad], collapse = ', ')
        )
        stop(msg)
    }

    # Do not allow a leaf with zero area but nonzero mass
    if (!is.na(partitioning_leaf_area) && partitioning_leaf_area == 0 &&
        !is.null(partitioning_component_weights[['leaf']]) &&
        !is.na(partitioning_component_weights[['leaf']]) &&
            partitioning_component_weights[['leaf']] > 0) {
        stop("It is not possible for a leaf with zero area to have a nonzero mass")
    }

    # Do not allow a leaf with zero mass but nonzero area
    if (!is.na(partitioning_leaf_area) && partitioning_leaf_area > 0 &&
        !is.null(partitioning_component_weights[['leaf']]) &&
        !is.na(partitioning_component_weights[['leaf']]) &&
            partitioning_component_weights[['leaf']] == 0) {
        stop("It is not possible for a leaf with zero mass to have a nonzero area")
    }

    # If the user specified values of planting_density, row_spacing, and
    # plant_spacing, check to make sure they are consistent with each other (to
    # within 2 percent). Here we use 1 acre = 4047 m^2 in these calculations.
    if (!any(is.na(c(planting_density, row_spacing, plant_spacing)))) {
        if (abs(1 - planting_density * row_spacing * plant_spacing / 4047) > 0.02) {
            stop('The supplied values of planting_density, row_spacing, and plant_spacing are not consistent with each other.')
        }
    }

    # Calculate missing plant density parameters if possible. Here we use
    # 1 acre = 4047 m^2 in these calculations.
    if (!is.na(planting_density) && !is.na(row_spacing)) {
        # Here we know the planting density (in plants per acre) and the row
        # spacing (in m), so we can calculate the spacing between plants along
        # the rows (in m).
        plant_spacing <- 4047 / (planting_density * row_spacing)
    } else if (!is.na(row_spacing) && !is.na(plant_spacing)) {
        # Here we know the row spacing (in m) and the spacing between plants
        # along the rows (in m), so we can calculate the planting density (in
        # plants per acre).
        planting_density <- 4047 / (row_spacing * plant_spacing)
    } else if (!is.na(planting_density) && !is.na(plant_spacing)) {
        # Here we know the planting density (in plants per acre) and the spacing
        # between plants along the rows (in m), so we can calculate the row
        # spacing (in m).
        row_spacing <- 4047 / (planting_density * plant_spacing)
    }

    # Assemble all the information into a list of named elements
    hp <- list(
        crop = crop,
        variety = variety,
        location = location,
        plot = plot,
        year = year,
        doy = doy,
        hour = hour,
        planting_density = planting_density,
        row_spacing = row_spacing,
        plant_spacing = plant_spacing,
        partitioning_nplants = partitioning_nplants,
        partitioning_leaf_area = partitioning_leaf_area,
        partitioning_component_weights = partitioning_component_weights,
        agb_components = agb_components,
        agb_nplants = agb_nplants,
        agb_row_length = agb_row_length,
        agb_weight = agb_weight,
        trap_area = trap_area,
        trap_component_weights = trap_component_weights,
        additional_arguments = additional_arguments
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
