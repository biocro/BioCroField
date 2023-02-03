hp <- test_that("an empty harvest_point is possible", {
    expect_no_error(harvest_point())
})

test_that("harvest_point produces harvest_point objects", {
    expect_type(hp, 'harvest_point')
})
