pacman::p_load(fs, yaml, stringr, zip)

# Function to add YAML features and remove download button
add_yaml_features_and_remove_button <- function(file_path, new_features) {
  content <- readLines(file_path, warn = FALSE)
  yaml_start <- which(content == "---")[1]
  yaml_end <- which(content == "---")[2]
  
  if (is.na(yaml_end)) {
    warning(paste("No YAML found in", file_path))
    return(content)
  }
  
  existing_yaml <- yaml.load(paste(content[(yaml_start + 1):(yaml_end - 1)], collapse = "\n"))
  updated_yaml <- modifyList(existing_yaml, new_features, keep.null = TRUE)
  updated_yaml_str <- as.yaml(updated_yaml, handlers = list(logical=verbatim_logical))
  
  if (yaml_end < length(content)) {
    content_without_button <- content[(yaml_end + 1):length(content)]
    button_start <- which(grepl("<a.*class=\"button-download\"", content_without_button))
    button_end <- which(grepl("</a>", content_without_button))
    
    if (length(button_start) > 0 && length(button_end) > 0) {
      button_end <- button_end[button_end > button_start][1]
      if (!is.na(button_end)) {
        content_without_button <- content_without_button[-(button_start:button_end)]
      }
    }
  } else {
    content_without_button <- character(0)
  }
  
  new_content <- c(
    "---",
    strsplit(updated_yaml_str, "\n")[[1]],
    "---",
    content_without_button
  )
  
  return(new_content)
}


source_dirs <- c("./1-Getting_Started", "./2-Descriptive_Statistics", "./3-Data_Wrangling_Visualization", "./7-Semester_Project")

yaml_to_add <- list(
  format = list(
    html = list(
      `self-contained` = TRUE,
      `embed-resources` = TRUE
    )
  )
)

for(i in 1:length(source_dirs)){
  dest_dir <- paste("./Student_Work", str_remove_all(source_dirs[i], "./"), sep='/')
  dir_create(dest_dir)
  
  qmd_files <- dir_ls(source_dirs[i], glob = "*.qmd")
  
  for (file in qmd_files) {
    dest_file <- path(dest_dir, path_file(file))
    file_copy(file, dest_file, overwrite = TRUE)
    new_content <- add_yaml_features_and_remove_button(dest_file, yaml_to_add)
    writeLines(new_content, dest_file)
    cat("Processed:", path_file(file), "\n")
  }
  
  cat("All files have been copied, modified, and had download buttons removed.\n")
}


############# Zip the folder

zip_directory <- function(dir_path, zip_name = NULL) {
  # Normalize directory path
  dir_path <- path_norm(dir_path)
  
  # Check if directory exists
  if (!dir.exists(dir_path)) {
    stop("Directory does not exist:", dir_path)
  }
  
  # If no zip name provided, use directory name
  if (is.null(zip_name)) {
    zip_name <- paste0(path_file(dir_path), ".zip")
  }
  
  # Create zip file path in parent directory
  zip_path <- path_norm(file.path(path_dir(dir_path), zip_name))
  
  # Change working directory to parent directory
  old_wd <- getwd()
  on.exit(setwd(old_wd))  # Ensure we return to original directory
  setwd(path_dir(dir_path))
  
  # Create zip file using relative path
  zip(
    zipfile = zip_name,
    files = path_file(dir_path),
    mode = "mirror",
    recurse = TRUE
  )
  
  cat("Created zip file:", zip_path, "\n")
}

zip_directory("Student_Work")

