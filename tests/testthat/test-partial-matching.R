# Partial matching when accessing list elements can cause problems. For example,
# if values of `leaf_litter` but not `leaf` are supplied when creating a
# `harvest_point` object, then a nonsensical value of `LMA` will be calculated
# because `partitioning_component_weights$leaf_litter` will be a partial match
# for the (unavailable) `partitioning_component_weights$leaf`.

test_that("`leaf_litter` is not a partial match for `leaf`", {
    expect_true(
        is.na(process(harvest_point(
            partitioning_component_weights = list(leaf_litter = 1),
            partitioning_leaf_area = 2
        ))$LMA)
    )
})

test_that("alternate leaf names can be provided", {
    expect_equal(
        process(
            harvest_point(
                partitioning_component_weights = list(main_leaf = 1),
                partitioning_leaf_area = 2
            ),
            leaf_name = 'main_leaf'
        )$LMA,
        process(harvest_point(
            partitioning_component_weights = list(leaf = 1),
            partitioning_leaf_area = 2
        ))$LMA
    )
})
