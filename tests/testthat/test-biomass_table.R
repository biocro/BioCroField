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
