# Make an example biomass data table to use for testing
biomass <- biomass_table(process(harvest_point()))

test_that("We can add blank seed mass to a blank biomass table", {
    expect_no_error(add_seed_biomass(biomass))
})

test_that("We can add seed mass to a blank biomass table", {
    expect_no_error(add_seed_biomass(
        biomass, seed_mass = 0.1,
        planting_density = 30000
    ))
})

test_that("Seed fractions must add to 1", {
    expect_error(
        add_seed_biomass(
            biomass,
            component_fractions = list(seed = 0.9)
        ),
        "The component_fractions must add to 1"
    )
})
