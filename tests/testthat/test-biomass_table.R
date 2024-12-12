test_that("an empty harvest_point can be converted to a table", {
    expect_no_error(biomass_table(process(harvest_point())))
})

test_that("process.harvest_point produces data.frame objects", {
    expect_s3_class(biomass_table(process(harvest_point())), 'data.frame')
})

test_that("an unprocessed empty harvest_point can be converted to a table", {
    expect_no_error(biomass_table(harvest_point()))
})

test_that("Additional harvest_point arguments are included in the final table", {
    expect_no_error(biomass_table(process(harvest_point(construct = 'blah'))))

    biomass <- biomass_table(
        process(harvest_point(stem_comment = 'blah')),
        process(harvest_point(leaf_comment = 'yadda'))
    )

    expect_true(all(c('stem_comment', 'leaf_comment') %in% colnames(biomass)))

    expect_identical(biomass$leaf_comment, c(NA, 'yadda'))

    expect_identical(biomass$stem_comment, c('blah', NA))
})

test_that("Some table columns are specified by the user", {
    essential_columns <- c(
        'crop',
        'variety',
        'location',
        'plot',
        'year',
        'doy',
        'hour',
        'time',
        'SLA',
        'LMA',
        'LAI_from_LMA',
        'row_spacing',
        'plant_spacing',
        'planting_density'
    )

    optional_columns <- c(
        'LAI_from_planting_density',
        'LAI_from_measured_population',
        'agb_per_area',
        'agb_per_plant_row',
        'agb_per_plant_partitioning',
        'measured_population'
    )

    hp <- process(harvest_point())

    # Use default arguments
    biomass_table_1 <- biomass_table(hp)

    expect_true(
        all(essential_columns %in% colnames(biomass_table_1))
    )

    expect_true(
        all(optional_columns %in% colnames(biomass_table_1))
    )

    # Don't include any extra columns
    biomass_table_2 <- biomass_table(hp, other_columns = character())

    expect_true(
        all(essential_columns %in% colnames(biomass_table_2))
    )

    expect_true(
        all(!optional_columns %in% colnames(biomass_table_2))
    )
})
