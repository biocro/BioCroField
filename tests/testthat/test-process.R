expect_na <- function(x) {expect_true(is.na(x))}

test_that("an empty harvest_point can be processed", {
    expect_no_error(process(harvest_point()))
})

test_that("process.harvest_point produces harvest_point objects", {
    expect_s3_class(process(harvest_point()), 'harvest_point')
})

hpp <- process(harvest_point())

test_that("time is calculated only when possible", {
    expect_na(hpp$time)

    expect_equal(
        process(harvest_point(doy = 1, hour = 12))$time,
        1.5
    )
})

test_that("partitioning_agb_weight is calculated only when possible", {
    expect_na(hpp$partitioning_agb_weight)

    expect_equal(
        process(harvest_point(
            agb_components = c('a', 'b'),
            partitioning_component_weights = list(a = 1, b = 2)
        ))$partitioning_agb_weight,
        3
    )
})

test_that("agb_per_plant_row is calculated only when possible", {
    expect_na(hpp$agb_per_plant_row)

    expect_na(process(harvest_point(agb_weight = 1))$agb_per_plant_row)

    expect_na(process(harvest_point(agb_nplants = 1))$agb_per_plant_row)

    expect_na(process(harvest_point(agb_nplants = 1))$agb_per_plant_row)

    expect_equal(
        process(harvest_point(agb_weight = 1, agb_nplants = 2))$agb_per_plant_row,
        0.5
    )
})

test_that("population is calculated only when possible", {
    expect_na(hpp$population)

    expect_na(process(harvest_point(agb_nplants = 1))$population)

    expect_na(process(harvest_point(agb_row_length = 1))$population)

    expect_na(process(harvest_point(row_spacing = 1))$population)

    expect_equal(
        process(harvest_point(agb_nplants = 10, agb_row_length = 2, row_spacing = 0.5))$population,
        40470
    )
})

