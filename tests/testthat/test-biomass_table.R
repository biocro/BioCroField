test_that("an empty harvest_point can be converted to a table", {
    expect_no_error(biomass_table(process(harvest_point())))
})

test_that("process.harvest_point produces data.frame objects", {
    expect_s3_class(biomass_table(process(harvest_point())), 'data.frame')
})

test_that("an unprocessed empty harvest_point can be converted to a table", {
    expect_no_error(biomass_table(harvest_point()))
})
