# Load necessary libraries
library(sangeranalyseR)
library(tidyverse)
library(optparse)

# Define command line arguments
option_list <- list(
  make_option(c("-d", "--directory"), type = "character", default = NULL, help = "Directory containing .ab1 files", metavar = "character"),
  make_option(c("-t", "--trim_method"), type = "character", default = "M2", help = "Trimming method (default is 'M2')", metavar = "character"),
  make_option(c("-m1", "--m1_cutoff"), type = "numeric", default = NULL, help = "M1 Trimming Cutoff", metavar = "numeric"),
  make_option(c("-m2", "--m2_cutoff_quality"), type = "numeric", default = 40, help = "M2 Cutoff Quality Score (default is 40)", metavar = "numeric"),
  make_option(c("-w", "--m2_sliding_window_size"), type = "numeric", default = 5, help = "M2 Sliding Window Size (default is 5)", metavar = "numeric"),
  make_option(c("-b", "--base_num_per_row"), type = "numeric", default = 100, help = "Base number per row (default is 100)", metavar = "numeric"),
  make_option(c("-h", "--height_per_row"), type = "numeric", default = 200, help = "Height per row (default is 200)", metavar = "numeric"),
  make_option(c("-s", "--signal_ratio_cutoff"), type = "numeric", default = 0.33, help = "Signal Ratio Cutoff (default is 0.33)", metavar = "numeric"),
  make_option(c("-o", "--output_dir"), type = "character", default = NULL, help = "Directory to save output fasta files", metavar = "character")
)

# Parse command line arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check that required arguments are provided
if (is.null(opt$directory) || is.null(opt$output_dir)) {
  print_help(opt_parser)
  stop("Please provide both the directory containing .ab1 files and the output directory for the fasta files.", call. = FALSE)
}

# Set the working directory
setwd(this.path::here())

# List all .ab1 files in the specified directory
ab1_files <- list.files(path = opt$directory, pattern = "\\.ab1$", full.names = TRUE)

# Loop through each .ab1 file and apply the SangerRead function
for (file in ab1_files) {
  sangerRead <- SangerRead(
    readFeature           = "Reverse Read",
    readFileName          = file,
    geneticCode           = GENETIC_CODE,
    TrimmingMethod        = opt$trim_method,
    M1TrimmingCutoff      = opt$m1_cutoff,
    M2CutoffQualityScore  = opt$m2_cutoff_quality,
    M2SlidingWindowSize   = opt$m2_sliding_window_size,
    baseNumPerRow         = opt$base_num_per_row,
    heightPerRow          = opt$height_per_row,
    signalRatioCutoff     = opt$signal_ratio_cutoff,
    showTrimmed           = TRUE
  )
  
  # Write the output fasta file to the specified directory
  output_file <- file.path(opt$output_dir, paste0(tools::file_path_sans_ext(basename(file)), ".fasta"))
  writeFasta(sangerRead, outputDir = opt$output_dir)
  cat("Fasta file written to:", output_file, "\n")
}
