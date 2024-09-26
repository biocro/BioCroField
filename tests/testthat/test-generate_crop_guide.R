stored_markdown <-
'---
title: "Soybean Guide (BioCroField)"
output: pdf_document
geometry: top=0.5in,bottom=0.75in,left=0.75in,right=0.75in
---

**Notes**: This is an incomplete example.

# Harvesting and Partitioning Soybean Tissue

- **Essential Tissue Types**: Every harvest should include above-ground biomass,
  leaf, stem, and root tissue. When the plants are young, this might be all of
  the tissue types. As the plants enter reproductive stages, additional types
  might appear.

- **Plant Litter**: Any senesced tissue still attached to the plants themselves
  is considered to be "plant litter." Plant litter should be included when
  collecting above-ground biomass samples. Plant litter from partitioned plants
  should be placed in a bag labeled "litter" or "plant litter."

- **Litter Trap**: Any senesced tissue in the trap should be placed in a bag labeled "trap litter"
to distinguish it from the "plant litter" described above. The trap might not
contain any litter when the plants are young.

- **Leaves**: These should always be harvested.

- **Stems**: These should also always be harvested.

# Weighing the Partitioned Soybean Tissue

- **Roots**: Roots are cleaned in the field before drying, but they are usually
  still a bit dirty. Before weighing the roots, remove any soil or other
  obviously foreign material. A small screwdriver or a capped pen is often
  useful for this purpose. Be careful, and try to avoid damaging the roots
  themselves, because any small pieces that fall off might be difficult to
  recover and weigh.

- **Plant Litter**: The plant litter should be sorted into components as
  necessary, discarding any soil or foreign material. Each component should be
  separately weighed and recorded in the "partitioned plant components" section
  of the harvest log sheet. The name of these components should clearly indicate
  they represent litter; for example, **Leaf Litter**.

- **Litter Trap**: The litter trap contents should be sorted into components as necessary,
discarding any soil or foreign material. Each component should be separately
weighed and recorded in the "litter trap components" section of the harvest log
sheet.

- **Leaves**: Only weigh the green ones. Brown ones count as litter.

- **Stems**: Just open the bag and weigh what you find inside.

- **All Possible Components**: The following is a list of all possible tissue components that should be
weighed, although not all of them will be present at every harvest: Roots, Leaves, Stems, Pods, Leaf Litter (plant), Stem Litter (plant), Leaf Litter (trap), Stem Litter (trap)

- **Unclear Cases**: If you are unsure about anything while weighing, please
  contact the responsible person listed on the harvest record sheet.
'

test_that('Crop guide rmarkdown content has not changed', {
    markdown_file_contents <- generate_crop_guide(
        crop_name = 'Soybean',
        uses_litter_trap = TRUE,
        notes = 'This is an incomplete example.',
        harvesting_specific_tissues = list(
          Leaves = 'These should always be harvested.',
          Stems = 'These should also always be harvested.'
        ),
        weighing_specific_tissues = list(
          Leaves = 'Only weigh the green ones. Brown ones count as litter.',
          Stems = 'Just open the bag and weigh what you find inside.'
        ),
        all_possible_weights = list(
          living = c('Roots', 'Leaves', 'Stems', 'Pods'),
          litter = c('Leaf', 'Stem')
        )
    )

    expect_equal(markdown_file_contents, stored_markdown)
})
