test_that("an empty harvest_point can be processed", {
    expect_no_error(process(harvest_point()))
})

test_that("process.harvest_point produces harvest_point objects", {
    expect_s3_class(process(harvest_point()), 'harvest_point')
})
