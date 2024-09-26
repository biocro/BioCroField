# This script generates crop-specific guide sheets with tips for harvesting and
# weighing.
#
# To run this script, type `source('build_crop_sheets.R')` from an R session
# running in this directory.

# Load required packages
library(BioCroField)

# Specify the output directory
outdir <- 'sheets'

# Specify possible tissue types
bean_possible_weights <- list(
    living = c(
        'Roots', 'Stems', 'Leaves', 'Flowers', 'Pods', 'Pods - Seeds',
        'Pods - Shells'
    ),
    litter = c('Leaf', 'Stem', 'Pod')
)

maize_possible_weights <- list(
    living = c(
        'Roots', 'Stems', 'Leaves', 'Tassels', 'Unfertilized Ears', 'Ears',
        'Ears - Husks', 'Ears - Kernels', 'Ears - Cobs'
    ),
    litter = c('Leaf', 'Tassel')
)

sorghum_possible_weights <- list(
    living = c(
        'Roots', 'Stems', 'Leaves', 'Panicles', 'Panicles - Grain',
        'Panicles - Flowers', 'Panicles - Stem'
    ),
    litter = 'Leaf'
)

# Specify other key pieces of crop-specific information
grass_notes <-
'Litter traps have been ineffective at capturing senesced tissue from this crop,
so they are not used.'

grass_leaf_harvesting <-
'Leaves should be cut or torn at the leaf collar, or otherwise where they meet
the main stem.'

grass_litter_weighing <-
'Remember to record the litter weight in the "plant" section of the harvest sheet
because litter is collected on a plant basis. Before weighing, check to make
sure no large clumps of soil or other foreign material are included with the
litter.'

grass_root_harvesting <-
'Brace roots typically appear as the plants get older. The main stem should be
cut just above the lowest set of brace roots. It may be necessary to also cut
through some brace roots if there is a second set above the lowest set. Anything
below the cut is considered to be root tissue.'

maize_ear_harvesting <-
'Large fertilized ears can be simply snapped off the stem. Unfertilized ears are
also harvested. They can be difficult to find if they have not emerged or
produced silks, but they can nevertheless be cut out of the stems.'

maize_ear_weighing <-
'Unfertilized ears should be recorded as **Unfertilized Ears**. Fertilized
ears should be weighed intact first (including husks) and recorded as **Ears**.
Next, the fertilized ears should be husked, and the husks should be weighed.
Finally, if possible, the kernels should be removed from the cobs and weighed.
Record these weights as **Ears - Husk**, **Ears - Kernels**, and **Ears - Cobs**
to indicate that they were derived from the intact ears.'

maize_tassel_harvesting <-
'The stem should be cut just below the first flowers of the tassel. Tassels
harvested this way include a portion of the main stem, but its mass is generally
negligible and can be ignored.'

sorghum_panicle_harvesting <-
'The stem should be cut just below the first flowers of the panicle. Panicles
harvested this way therefore include a portion of the main stem; this can be
separated during weighing. When the plants are in the boot stage, it may be
possible to cut out the panicle even though it has not yet emerged.'

sorghum_panicle_weighing <-
'Panicles should be weighed intact first and recorded as **Panicles**. Next, if
possible, the grain should be threshed (removed from the rest of the panicle)
and weighed separately. Threshing can be done manually by repeatedly squeezing
the panicle. Then, the small panicle branches and the attached spikelets should
be removed and weighed separately. Finally, the remaining stem section should be
weighed. Record these weights as **Panicle - Grain**, **Panicle - Flowers**, and
**Panicle - Stem** to indicate that they were derived from the intact panicles.'

bean_petiole_harvesting <-
'For BioCro purposes, petioles are considered to be part of the stem, even though
they are anatomically part of the leaf. We do this because the "leaf" tissue
component of a BioCro simulation only refers to photosynthesizing tissue, and
petioles are not expected to contribute much to total canopy photosynthesis.'

bean_flower_harvesting <-
'Flowers are treated as a distinct tissue type when pods have not appeared yet.
Once pods have appeared, any flowers should be grouped together with the pods.'

bean_pod_weighing <-
'Pods should be weighed intact first and recorded as **Pods**. Then, if possible,
they should be shelled so the seeds and shells can be weighed (and recorded)
separately. This may be not be possible if the pods are too small. Record the
seeds and shells as **Pods - Seeds** and **Pods - Shells** on the harvest record
sheet to indicate that the seeds and shells were derived from the pods.'

default_weighing <- 'No special instructions. Just weigh them!'

# Create the crop guide PDFs
generate_crop_guide(
    crop_name = 'Soybean',
    uses_litter_trap = TRUE,
    notes = 'This crop produces large quantities of litter, so litter traps are always used.',
    harvesting_specific_tissues = list(
        Petioles = bean_petiole_harvesting,
        Flowers = bean_flower_harvesting
    ),
    weighing_specific_tissues = list(
        Stems = default_weighing,
        Leaves = default_weighing,
        Pods = bean_pod_weighing
    ),
    all_possible_weights = bean_possible_weights,
    build = TRUE,
    output_dir = outdir
)

generate_crop_guide(
    crop_name = 'Grain Sorghum',
    uses_litter_trap = FALSE,
    notes = grass_notes,
    harvesting_specific_tissues = list(
        Roots = grass_root_harvesting,
        Leaves = grass_leaf_harvesting,
        Panicles = sorghum_panicle_harvesting
    ),
    weighing_specific_tissues = list(
        Stems = default_weighing,
        Leaves = default_weighing,
        Panicles = sorghum_panicle_weighing
    ),
    all_possible_weights = sorghum_possible_weights,
    build = TRUE,
    output_dir = outdir
)

generate_crop_guide(
    crop_name = 'Maize',
    uses_litter_trap = FALSE,
    notes = grass_notes,
    harvesting_specific_tissues = list(
        Roots = grass_root_harvesting,
        Leaves = grass_leaf_harvesting,
        Ears = maize_ear_harvesting,
        Tassels = maize_tassel_harvesting
    ),
    weighing_specific_tissues = list(
        Stems = default_weighing,
        Leaves = default_weighing,
        Ears = maize_ear_weighing,
        Tassels = default_weighing
    ),
    all_possible_weights = maize_possible_weights,
    build = TRUE,
    output_dir = outdir
)

generate_crop_guide(
    crop_name = 'Cowpea',
    uses_litter_trap = FALSE,
    notes = 'This crop does not senesce much before the final harvest when grown in the tropics, so no litter traps are used.',
    harvesting_specific_tissues = list(
        Petioles = bean_petiole_harvesting,
        Flowers = bean_flower_harvesting
    ),
    weighing_specific_tissues = list(
        Stems = default_weighing,
        Leaves = default_weighing,
        Pods = bean_pod_weighing
    ),
    all_possible_weights = bean_possible_weights,
    build = TRUE,
    output_dir = outdir
)
