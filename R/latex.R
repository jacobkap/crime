# z <- mtcars[1:6, 1:6]
# z$mpg <- rownames(z)
# names(z)[1] <- ""
# multi_column <- c(" " = 1, "column1" = 2, "column2" = 3)

#make_latex_tables("test", "title", "label", z, "caption", multi_column, "NOTE ")
make_latex_tables <- function(file_name,
                              table_title,
                              table_reference_label,
                              data,
                              panel_caption,
                              multi_column = NULL,
                              footnote = "") {
  if (!grepl(".tex$", file_name)) {
    file_name <- paste0(file_name, ".tex")
  }
  sink(file_name)


  writeLines("\\clearpage")
  writeLines("\\begin{table}[H]")
  writeLines("\\centering")
  writeLines(paste0("\\caption{", table_title, "}"))
  writeLines("\\begin{subtable}[t]{\\linewidth}")
  writeLines(paste0("\\label{", table_reference_label, "}"))


  if (is.data.frame(data)) {
    make_latex_table_panel(data, panel_caption)
  } else if (is.list(data) && !is.data.frame(data)) {
    for (i in 1:length(data)) {
      make_latex_table_panel(data[[i]], names(data)[i])
    }
  }

  # End table
  writeLines("\\vspace{-6mm}")
  writeLines(paste0("\\floatfoot{", footnote, "}"))

  writeLines("\\end{subtable}")
  writeLines("\\end{table}")

  sink()

}

make_big_ci_brackets <- function(.data) {
  .data <- gsub("\\[", "\big\\[", .data)
  .data <- gsub("\\]", "\big\\]", .data)
  return(.data)
}

make_b_to_beta <- function(.data) {
  .data <- gsub("^b$", "$\\hat{\beta}$", .data)
  .data <- strsplit(x = .data, split = "^\\$")[[1]][2]
  .data <- paste0("$\\", .data)
  return(.data)
}


get_column_alignments <- function(data) {
  alignment <- paste0("l", paste0(rep("r",
                                      times = (ncol(data) - 1)),
                                  collapse = ""))
  return(alignment)
}

make_latex_table_panel <- function(data, panel_caption, muli_column) {
  alignment <- get_column_alignments(data)
  writeLines(paste0("\\begin{tabular}{@{\\extracolsep{5pt}}",
                    alignment, "}"))

  if (!is.null(multi_column)) {
    for (i in 1:length(multi_column)) {
      multi_column_row <- paste0("\\multicolumn{",
                                 unname(multi_column)[i],
                                 "}{l}{\\textbf{",
                                 names(multi_column[i]),
                                 "}} &")
      if (i == length(multi_column)) {
        multi_column_row <- gsub("&$", "\\\\\\\\", multi_column_row)
      }
      writeLines(multi_column_row)
    }
  }

  writeLines("\\toprule")

  headers <- paste0("\\thead{", names(data), "} &", collapse = " ")
  headers <- gsub("&$", "\\\\\\\\", headers)

  writeLines(headers)
  writeLines("\\midrule")

  for (i in 1:nrow(data)) {
    row_data <- data[i, ]
    row_data <- make_big_ci_brackets(row_data)
    row_data <- make_b_to_beta(row_data)
    row_data <- paste0(data[i, ], " &", collapse = " ")
    row_data <- gsub("&$", "\\\\\\\\", row_data)
    writeLines(row_data)
  }
  writeLines("\\end{tabular}")
  writeLines(paste0("\\caption{", panel_caption, "}"))
}
