access_sheet <- function(sheet_name, sheet_type = 'pdf', open_sheet = TRUE) {
    extension <- if (sheet_type == 'pdf') {
        '.pdf'
    } else if (sheet_type == 'word') {
        '.docx'
    } else {
        stop('sheet_type must be "pdf" or "word"')
    }

    fname <- paste0(sheet_name, extension)

    fpath <- system.file(
        file.path('data_record_sheets', fname),
        package = 'BioCroField',
        mustWork = TRUE
    )

    if (open_sheet) {
        system(paste0('open "', fpath, '"'))
    }

    return(fpath)
}
