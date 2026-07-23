# Define the root directory to start searching from
# "." represents the current working directory. You can change this to a specific path.
target_dir <- "."

# Define the text you want to search for and what to replace it with
search_string  <- "Brother Cannon's"
replace_string <- "Stat 225"

# 1. Recursively find all .qmd files in the directory structure
qmd_files <- list.files(
  path = target_dir,
  pattern = "\\.qmd$",
  ignore.case = TRUE,
  recursive = TRUE,
  full.names = TRUE
)

# Print a quick summary of what was found
cat(sprintf("Found %d .qmd file(s) to process.\n\n", length(qmd_files)))

# 2. Loop through each file and perform the replacement
for (file_path in qmd_files) {
  # Read the contents of the file line by line
  file_contents <- readLines(file_path, warn = FALSE)
  
  # Check if the search string exists in the file before rewriting
  if (any(grepl(search_string, file_contents, fixed = TRUE))) {
    
    # Replace the text. 
    # (fixed = TRUE is used for speed and to avoid regex character escaping issues)
    updated_contents <- gsub(
      pattern = search_string, 
      replacement = replace_string, 
      x = file_contents, 
      fixed = TRUE
    )
    
    # Write the updated content back to the file
    writeLines(updated_contents, file_path)
    cat(sprintf("Updated: %s\n", file_path))
    
  } else {
    cat(sprintf("No matches in: %s\n", file_path))
  }
}

cat("\nSearch and replace operation completed!\n")