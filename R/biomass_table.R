biomass_table <- function(..., zero_when_missing = c()) {
    x <- list(...)

    types <- lapply(x, class)
    if (length(unique(types)) > 1) {
        stop('all inputs must have the same type')
    }

    UseMethod('biomass_table', x[[1]])
}

biomass_table.harvest_point <- function(..., zero_when_missing = c()) {
    x <- list(...) # a list of harvest_point objects

    # Get the names of all the plant components that we have measurements for
    all_components <- unique(unlist(lapply(
        x,
        function(hpp) {names(hpp$all_components_biocro)}
    )))

    # Specify all the column names for the data table
    cnames <- c(
        'year', 'doy', 'hour', 'time',
        all_components,
        'LAI', 'SLA',
        'agb_per_plant_row', 'agb_per_plant_partitioning'
    )

    # Form a data frame
    biomass <- stats::setNames(
        data.frame(matrix(
            NA,
            nrow = length(x),
            ncol = 8 + length(all_components)
        )),
        cnames
    )

    # Fill in the rows
    for (i in seq_along(x)) {
        hpp <- x[[i]]
        biomass$year[i] <- hpp$year
        biomass$doy[i] <- hpp$doy
        biomass$hour[i] <- hpp$hour
        biomass$time[i] <- hpp$time
        for (comp in names(hpp$all_components_biocro)) {
            biomass[[comp]][i] <- hpp$all_components_biocro[[comp]]
        }
        biomass$LAI[i] <- hpp$LAI
        biomass$SLA[i] <- hpp$SLA
        biomass$agb_per_plant_row[i] <- hpp$agb_per_plant_row
        biomass$agb_per_plant_partitioning[i] <- hpp$agb_per_plant_partitioning
    }

    # Some components should be set to zero when they weren't measured
    for (comp in zero_when_missing) {
        comp_val <- biomass[[comp]]
        comp_val[is.na(comp_val)] <- 0
        biomass[[comp]] <- comp_val
    }

    return(biomass)
}
