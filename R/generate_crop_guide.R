crop_guide_text <-
'---
title: "%1$s Guide (BioCroField)"
output: pdf_document
geometry: top=0.5in,bottom=0.75in,left=0.75in,right=0.75in
---

%2$s

# Harvesting and Partitioning %1$s Tissue

- **Essential Tissue Types**: Every harvest should include above-ground biomass,
  leaf, stem, and root tissue. When the plants are young, this might be all of
  the tissue types. As the plants enter reproductive stages, additional types
  might appear.

- **Plant Litter**: Any senesced tissue still attached to the plants themselves
  is considered to be "plant litter." Plant litter should be included when
  collecting above-ground biomass samples. Plant litter from partitioned plants
  should be placed in a bag labeled "litter" or "plant litter."

%3$s

# Weighing the Partitioned %1$s Tissue

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

%4$s

- **Unclear Cases**: If you are unsure about anything while weighing, please
  contact the responsible person listed on the harvest record sheet.
'

notes_template <- '**Notes**: %s'

possible_tissues_template <-
'The following is a list of all possible tissue components that should be
weighed, although not all of them will be present at every harvest: %s'

harvesting_litter_trap_text <-
'Any senesced tissue in the trap should be placed in a bag labeled "trap litter"
to distinguish it from the "plant litter" described above. The trap might not
contain any litter when the plants are young.'

weighing_litter_trap_text <-
'The litter trap contents should be sorted into components as necessary,
discarding any soil or foreign material. Each component should be separately
weighed and recorded in the "litter trap components" section of the harvest log
sheet.'

generate_crop_guide <- function(
    crop_name,
    uses_litter_trap,
    notes,
    harvesting_specific_tissues,
    weighing_specific_tissues,
    all_possible_weights,
    build = FALSE,
    output_dir = '.',
    clean = TRUE
)
{
    # Create the overview text if necessary
    if (notes != '') {
        notes <- sprintf(
            notes_template,
            notes
        )
    }

    if (!uses_litter_trap) {
        notes <- paste(
            notes,
            'Because no litter traps are used, harvest record sheets for this',
            'crop should not contain any entries in the "litter trap component"',
            'section, and the "Litter trap area" box should be left blank.'
        )
    }

    # Collect info about harvesting
    if (uses_litter_trap) {
        harvesting_specific_tissues <- c(
            list(`Litter Trap` = harvesting_litter_trap_text),
            harvesting_specific_tissues
        )
    }

    harvesting_specific_tissues_info <- if (length(harvesting_specific_tissues) > 0) {
        paste0(
            '- **', names(harvesting_specific_tissues), '**: ', harvesting_specific_tissues
        )
    } else {
        ''
    }

    # Collect info about possible tissue component weights
    all_weight_components <- c(
        all_possible_weights[['living']],
        paste(all_possible_weights[['litter']], 'Litter (plant)')
    )

    if (uses_litter_trap) {
        all_weight_components <- c(
            all_weight_components,
            paste(all_possible_weights[['litter']], 'Litter (trap)')
        )
    }

    # Collect info about weighing
    if (uses_litter_trap) {
        weighing_specific_tissues <- c(
            list(`Litter Trap` = weighing_litter_trap_text),
            weighing_specific_tissues
        )
    }

    weighing_specific_tissues <- c(
        weighing_specific_tissues,
        list(`All Possible Components` = sprintf(
            possible_tissues_template,
            paste(all_weight_components, collapse = ', ')
        ))
    )

    weighing_specific_tissues_info <- if (length(weighing_specific_tissues) > 0 ) {
        paste0(
            '- **', names(weighing_specific_tissues), '**: ', weighing_specific_tissues
        )
    } else {
        ''
    }

    # Generate the Rmarkdown document text
    guide_markdown_text <- sprintf(
        crop_guide_text,
        crop_name,
        notes,
        paste(harvesting_specific_tissues_info, collapse = '\n\n'),
        paste(weighing_specific_tissues_info, collapse = '\n\n')
    )

    # Build the PDF, if desired
    if (build) {
        rmd_fname <- paste0(tolower(crop_name), '_guide.Rmd')
        rmd_fname <- gsub(' ', '_', rmd_fname)
        writeLines(guide_markdown_text, rmd_fname)
        rmarkdown::render(rmd_fname, output_dir = output_dir, clean = clean)
        if (clean) {file.remove(rmd_fname)}
    }

    # Return the markdown text
    return(invisible(guide_markdown_text))
}
