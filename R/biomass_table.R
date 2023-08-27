biomass_table <- function(..., zero_when_missing = character()) {
    x <- list(...)

    types <- lapply(x, class)
    if (length(unique(types)) > 1) {
        stop('all inputs must have the same type')
    }

    UseMethod('biomass_table', x[[1]])
}

biomass_table.harvest_point <- function(..., zero_when_missing = character()) {
    x <- list(...) # a list of harvest_point objects

    # Make sure certain inputs are character
    should_be_c <- list(
        zero_when_missing = zero_when_missing
    )

    c_bad <- sapply(should_be_c, function(x) {!is.character(x)})

    if (any(c_bad)) {
        msg <- paste(
            'The following inputs should be character, but are not:',
            paste(names(should_be_c)[c_bad], collapse = ', ')
        )
        stop(msg)
    }

    # Get the names of all the plant components that we have measurements for
    all_components <- unique(unlist(lapply(
        x,
        function(hpp) {names(hpp[['all_components_biocro']])}
    )))

    # Get the names of all the additional arguments that were supplied when the
    # harvest_point objects were created
    additional_arguments <- unique(unlist(lapply(
        x,
        function(hpp) {names(hpp[['additional_arguments']])}
    )))

    # Specify all the column names for the data table
    initial_columns <-
        c('crop', 'variety', 'location', 'plot', 'year', 'doy', 'hour', 'time')

    final_columns <- c(
        'SLA',
        'LAI_from_LMA',
        'LAI_from_planting_density',
        'LAI_from_measured_population',
        'agb_per_plant_row',
        'agb_per_plant_partitioning',
        'population'
    )

    cnames <-
        c(initial_columns, all_components, final_columns, additional_arguments)

    # Form a data frame
    biomass <- stats::setNames(
        data.frame(matrix(
            NA,
            nrow = length(x),
            ncol = length(cnames)
        )),
        cnames
    )

    # Fill in the rows
    for (i in seq_along(x)) {
        hpp <- x[[i]]

        for (name in c(initial_columns, final_columns)) {
            if (name %in% names(hpp)) {
                biomass[i, name] <- hpp[[name]]
            }
        }

        for (comp in names(hpp[['all_components_biocro']])) {
            biomass[i, comp] <- hpp[['all_components_biocro']][[comp]]
        }

        for (arg in additional_arguments) {
            if (arg %in% names(hpp[['additional_arguments']])) {
                biomass[i, arg] <- hpp[['additional_arguments']][[arg]]
            }
        }
    }

    # Some components should be set to zero when they weren't measured
    for (comp in zero_when_missing) {
        comp_val <- biomass[[comp]]
        comp_val[is.na(comp_val)] <- 0
        biomass[[comp]] <- comp_val
    }

    return(biomass)
}
