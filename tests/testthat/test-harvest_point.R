test_that("an empty harvest_point is possible", {
    expect_no_error(harvest_point())
})

test_that("harvest_point produces harvest_point objects", {
    expect_s3_class(harvest_point(), 'harvest_point')
})

test_that("Certain inputs must be length 1", {
    expect_no_error(
        harvest_point(
            agb_components = c('a', 'b'),
            partitioning_component_weights = list(a = 1, b = 2)
        )
    )

    expect_error(
        harvest_point(crop = list()),
        "The following inputs should have length 1, but do not: crop"
    )
})

test_that("Certain inputs must be numeric, character, or NA", {
    expect_no_error(harvest_point(crop = 1))

    expect_no_error(harvest_point(crop = 'a'))

    expect_no_error(harvest_point(crop = NA))

    expect_error(
        harvest_point(crop = list(1)),
        "The following inputs should be numeric, character, or NA, but are not: crop"
    )
})

test_that("Certain inputs must be numeric or NA", {
    expect_no_error(harvest_point(year = 1))

    expect_error(
        harvest_point(year = 'a'),
        "The following inputs should be numeric or NA, but are not: year"
    )

    expect_no_error(harvest_point(year = NA))

    expect_error(
        harvest_point(year = list(1)),
        "The following inputs should be numeric or NA, but are not: year"
    )
})

test_that("Certain inputs must be positive when they are numeric", {
    expect_error(
        harvest_point(year = -1),
        "The following inputs are numeric and therefore should be positive, but are not: year"
    )
})

test_that("Certain inputs must be character", {
    expect_error(
        harvest_point(agb_components = 1),
        "The following inputs should be character, but are not: agb_components"
    )

    expect_no_error(
        harvest_point(
            agb_components = 'a',
            partitioning_component_weights = list(a = 1)
        )
    )

    expect_error(
        harvest_point(agb_components = NA),
        "The following inputs should be character, but are not: agb_components"
    )
})


test_that("Certain inputs must be lists", {
    expect_error(
        harvest_point(partitioning_component_weights = 2, trap_component_weights = 1),
        "The following inputs should be lists of named elements, but are not: partitioning_component_weights, trap_component_weights"
    )
})

test_that("Certain inputs must be lists with named elements", {
    expect_error(
        harvest_point(trap_component_weights = list(1)),
        "The following inputs should be lists of named elements, but are not: trap_component_weights"
    )

    expect_error(
        harvest_point(partitioning_component_weights = list(1)),
        "The following inputs should be lists of named elements, but are not: partitioning_component_weights"
    )

    expect_error(
        harvest_point(trap_component_weights = list(1, 2)),
        "The following inputs should be lists of named elements, but are not: trap_component_weights"
    )

    expect_error(
        harvest_point(trap_component_weights = list(a = 1, 2)),
        "The following inputs should be lists of named elements, but are not: trap_component_weights"
    )

    expect_error(
        harvest_point(trap_component_weights = list(1, a = 2)),
        "The following inputs should be lists of named elements, but are not: trap_component_weights"
    )
})

test_that("`agb_components` must be included in `partitioning_component_weights`", {
    expect_error(
        harvest_point(agb_components = c('bad1', 'bad2')),
        "The following elements of `agb_components` are not present in `partitioning_component_weights`: bad1, bad2"
    )
})

test_that("Leaf area can be zero if and only if leaf mass is also zero", {
    expect_no_error(
        harvest_point(partitioning_component_weights = list(leaf = 0), partitioning_leaf_area = 0)
    )

    expect_error(
        harvest_point(partitioning_component_weights = list(leaf = 1), partitioning_leaf_area = 0),
        "It is not possible for a leaf with zero area to have a nonzero mass"
    )

    expect_error(
        harvest_point(partitioning_component_weights = list(leaf = 0), partitioning_leaf_area = 1),
        "It is not possible for a leaf with zero mass to have a nonzero area"
    )
})

test_that("Additional arguments must be included as `additional_arguments`", {
    hp <- harvest_point(construct = 'blah')
    expect_false(is.null(hp$additional_arguments$construct))
})

test_that("Additional arguments must have names", {
    expect_error(
        harvest_point(
            crop = NA,
            variety = NA,
            location = NA,
            plot = NA,
            year = NA,
            doy = NA,
            hour = 12,
            target_population = NA,
            row_spacing = NA,
            partitioning_nplants = NA,
            partitioning_leaf_area = NA,
            partitioning_component_weights = list(),
            agb_nplants = NA,
            agb_components = character(),
            agb_row_length = NA,
            agb_weight = NA,
            trap_area = NA,
            trap_component_weights = list(),
            'bad'
        ),
        "The following inputs should be lists of named elements, but are not: additional_arguments"
    )
})

test_that("Additional arguments must have length 1 and be numeric, character, or NA", {
    expect_no_error(harvest_point(construct = NA))

    expect_no_error(harvest_point(construct = '123ABC-9'))

    expect_no_error(harvest_point(construct = 0.3))

    expect_error(
        harvest_point(construct = c(1, 1)),
        "The following inputs should have length 1, but do not: construct"
    )

    expect_error(
        harvest_point(construct = list()),
        "The following inputs should have length 1, but do not: construct"
    )
})
