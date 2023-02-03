test_that("an empty harvest_point is possible", {
    expect_no_error(harvest_point())
})

test_that("harvest_point produces harvest_point objects", {
    expect_s3_class(harvest_point(), 'harvest_point')
})
