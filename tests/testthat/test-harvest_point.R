test_that("an empty harvest_point is possible", {
    expect_no_error(harvest_point())
})

test_that("harvest_point produces harvest_point objects", {
    expect_s3_class(harvest_point(), 'harvest_point')
})

test_that("Certain inputs must be length 1", {
    expect_error(
        harvest_point(
            agb_components = c('a', 'b'),
            partitioning_component_weights = list(a = 1, b = 2)
        ),
        NA
    )

    expect_error(
        harvest_point(crop = list()),
        "The following inputs should have length 1, but do not: crop"
    )
})

test_that("Certain inputs must be numeric, character, or NA", {
    expect_error(harvest_point(crop = 1), NA)

    expect_error(harvest_point(crop = 'a'), NA)

    expect_error(harvest_point(crop = NA), NA)

    expect_error(
        harvest_point(crop = list(1)),
        "The following inputs should be numeric, character, or NA, but are not: crop"
    )
})

test_that("Certain inputs must be numeric or NA", {
    expect_error(harvest_point(year = 1), NA)

    expect_error(
        harvest_point(year = 'a'),
        "The following inputs should be numeric or NA, but are not: year"
    )

    expect_error(harvest_point(year = NA), NA)

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

    expect_error(
        harvest_point(
            agb_components = 'a',
            partitioning_component_weights = list(a = 1)
        ),
        NA
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
    expect_error(
        harvest_point(partitioning_component_weights = list(leaf = 0), partitioning_leaf_area = 0),
        NA
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

test_that("Extra arguments must be included as `extra`", {
    hp <- harvest_point(construct = 'blah')
    expect_false(is.null(hp$extra$construct))
})
