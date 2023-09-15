add_seed_biomass <- function(
    biomass_df,
    year = NA,
    doy = NA,
    hour = 12,
    seed_mass = NA,
    planting_density = NA,
    zero_when_missing = character(),
    component_fractions = list(),
    ...
)
{
    # Get any additional arguments
    additional_arguments = list(...)

    # Make sure the component fractions and extra arguments are provided as
    # lists with names
    named_list_required <- list(
        component_fractions = component_fractions,
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
            year = year,
            doy = doy,
            hour = hour,
            seed_mass = seed_mass,
            planting_density = planting_density
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
    should_be_ncna <- additional_arguments

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
        seed_mass = seed_mass,
        planting_density = planting_density
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

    # Make sure the component fractions add to 1
    if (length(component_fractions) > 0 && !isTRUE(all.equal(sum(as.numeric(component_fractions)), 1))) {
        stop('The component_fractions must add to 1')
    }

    # If the components are not included in the data frame, add them as new
    # columns initialized to NA.
    for (comp in c('initial_seed', names(component_fractions), names(additional_arguments))) {
        if (!comp %in% colnames(biomass_df)) {
            biomass_df[[comp]] <- NA
        }
    }

    # Initialize a single-row data frame with the same number of columns as
    # biomass_df, but with all values set to NA
    initial_biomass <- biomass_df[1, ]
    initial_biomass[1, ] <- NA

    # Reset the crop name, variety, and location, which we can safely assume to
    # be the same across the entire data frame
    initial_biomass[['crop']] <- biomass_df[1, 'crop']
    initial_biomass[['variety']] <- biomass_df[1, 'variety']
    initial_biomass[['location']] <- biomass_df[1, 'location']

    # Specify the time
    initial_biomass[['year']] <- year
    initial_biomass[['doy']] <- doy
    initial_biomass[['hour']] <- hour
    initial_biomass[['time']] <-
        initial_biomass[['doy']] + initial_biomass[['hour']] / 24.0

    # Reset certain columns to zero; there is no leaf area when the plant is a
    # seed, so also make sure to set all LAI estimates to zero
    should_be_zero <- c(
        zero_when_missing,
        'LAI_from_LMA',
        'LAI_from_planting_density',
        'LAI_from_measured_population'
    )

    for (comp in should_be_zero) {
        initial_biomass[[comp]] <- 0.0
    }

    # Set the population, which was specified when calling this function
    initial_biomass[['measured_population']] <- planting_density

    # Get the total initial biomass and store it in the new row
    total_initial_biomass <- seed_mass * planting_density * 2.47e-6
    initial_biomass[['initial_seed']] <- total_initial_biomass

    # Set some column values as fractions of the initial seed mass
    for (comp in names(component_fractions)) {
        initial_biomass[[comp]] <-
            total_initial_biomass * component_fractions[[comp]]
    }

    # Store the additional arguments
    for (arg in names(additional_arguments)) {
        initial_biomass[[arg]] <- additional_arguments[[arg]]
    }

    # Add the initial values as the first row of the biomass data frame
    biomass_df <- rbind(initial_biomass, biomass_df)

    return(biomass_df)
}
