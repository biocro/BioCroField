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
        3.0
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

test_that("agb_per_area is calculated only when possible", {
    expect_na(hpp$agb_per_area)

    expect_na(process(harvest_point(agb_weight = 1))$agb_per_area)

    expect_na(process(harvest_point(agb_row_length = 1))$agb_per_area)

    expect_na(process(harvest_point(row_spacing = 1))$agb_per_area)

    expect_equal(
        process(harvest_point(agb_weight = 10, agb_row_length = 2, row_spacing = 0.5))$agb_per_area,
        0.1
    )
})

test_that("relative_components are calculated only when possible", {
    expect_identical(hpp$relative_components, list())

    expect_equal(
        process(harvest_point(
            agb_components = c('a', 'b'),
            partitioning_component_weights = list(a = 1, b = 3)
        ))$relative_components,
        list(a = 0.25, b = 0.75)
    )
})

test_that("components_biocro are calculated only when possible", {
    expect_identical(hpp$components_biocro, list())

    expect_identical(
        process(harvest_point(
            agb_components = c('a', 'b'),
            partitioning_component_weights = list(a = 1, b = 3)
        ))$components_biocro,
        list(a = as.numeric(NA), b = as.numeric(NA))
    )

    expect_identical(
        process(harvest_point(
            agb_weight = 10, agb_row_length = 2, row_spacing = 0.5
        ))$components_biocro,
        list()
    )

    expect_equal(
        process(harvest_point(
            agb_weight = 10, agb_row_length = 2, row_spacing = 0.5,
            agb_components = c('a', 'b'),
            partitioning_component_weights = list(a = 1, b = 3)
        ))$components_biocro,
        list(a = 0.025, b = 0.075)
    )
})

test_that("LMA is calculated only when possible", {
    expect_na(hpp$LMA)

    expect_na(process(harvest_point(partitioning_leaf_area = 1))$LMA)

    expect_na(process(harvest_point(partitioning_component_weights = list(leaf = 1)))$LMA)

    expect_equal(
        process(harvest_point(
            partitioning_leaf_area = 500,
            partitioning_component_weights = list(leaf = 1)
        ))$LMA,
        20
    )
})

test_that("LAI is calculated only when possible", {
    expect_na(hpp$LAI)

    expect_na(
        process(harvest_point(
            agb_components = c('leaf', 'stem'),
            partitioning_leaf_area = 500,
            partitioning_component_weights = list(leaf = 2, stem = 2, root = 0.5)
        ))$LAI
    )

    expect_na(
        process(harvest_point(
            agb_weight = 10, agb_row_length = 2, row_spacing = 0.5,
            partitioning_leaf_area = 500,
            partitioning_component_weights = list(leaf = 2, stem = 2, root = 0.5)
        ))$LAI
    )

    expect_na(
        process(harvest_point(
            agb_weight = 10, agb_row_length = 2, row_spacing = 0.5,
            agb_components = c('leaf', 'stem'),
            partitioning_component_weights = list(leaf = 2, stem = 2, root = 0.5)
        ))$LAI
    )

    # A leaf with zero mass and zero area should have zero LAI
    expect_equal(
        process(harvest_point(
            partitioning_leaf_area = 0,
            partitioning_component_weights = list(leaf = 0, stem = 2, root = 0.5)
        ))$LAI,
        0.0
    )

    expect_equal(
        process(harvest_point(
            agb_weight = 10, agb_row_length = 2, row_spacing = 0.5,
            agb_components = c('leaf', 'stem'),
            partitioning_leaf_area = 500,
            partitioning_component_weights = list(leaf = 2, stem = 2, root = 0.5)
        ))$LAI,
        0.125
    )
})

test_that("SLA is calculated only when possible", {
    expect_na(hpp$SLA)

    expect_na(process(harvest_point(partitioning_leaf_area = 1))$SLA)

    expect_na(process(harvest_point(partitioning_component_weights = list(leaf = 1)))$SLA)

    expect_equal(
        process(harvest_point(
            partitioning_leaf_area = 500,
            partitioning_component_weights = list(leaf = 1)
        ))$SLA,
        5
    )
})
