test_that("We can add blank seed mass to a blank biomass table", {
    expect_no_error(add_seed_biomass(biomass_table(harvest_point())))

    expect_no_error(add_seed_biomass(biomass_table(process(harvest_point()))))
})

test_that("We can add seed mass to a blank biomass table", {
    expect_no_error(add_seed_biomass(
        biomass_table(harvest_point()),
        seed_mass = 0.1,
        planting_density = 30000
    ))

    expect_no_error(add_seed_biomass(
        biomass_table(process(harvest_point())),
        seed_mass = 0.1,
        planting_density = 30000
    ))
})

test_that("Seed fractions must add to 1", {
    expect_error(
        add_seed_biomass(
            biomass_table(process(harvest_point())),
            component_fractions = list(seed = 0.9)
        ),
        "The component_fractions must add to 1"
    )
})

test_that("Seed biomass is properly added to tables", {
    biomass_df <- add_seed_biomass(
        biomass_table(process(harvest_point(planting_density = 100000))),
        component_fractions = list(seed = 0.9, fluff = 0.1),
        seed_mass = 10
    )

    expect_equal(
        biomass_df[1, 'seed'],
        2.223
    )

    expect_equal(
        biomass_df[1, 'fluff'],
        0.247
    )

    expect_equal(
        biomass_df[1, 'initial_seed'],
        2.47
    )
})
