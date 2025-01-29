#!/usr/bin/env Rscript

# Function to suppress library loading messages
suppress_lib_loading <- function(package) {
  suppressMessages(library(package, character.only = TRUE))
}

# Load necessary libraries without messages
suppress_lib_loading("sangeranalyseR")
suppress_lib_loading("tidyverse")
suppress_lib_loading("optparse")

# Define command line arguments with unique short flags
option_list <- list(
  make_option(c("-d", "--directory"), type = "character", default = NULL, help = "Directory containing .ab1 files. Please provide the full path.", metavar = "character"),
  make_option(c("-q", "--m2_cutoff_quality"), type = "numeric", default = 40, help = "M2 Cutoff Quality Score [default=40]", metavar = "numeric"),
  make_option(c("-w", "--m2_sliding_window_size"), type = "numeric", default = 5, help = "M2 Sliding Window Size [default=5]", metavar = "numeric"),
  make_option(c("-b", "--base_num_per_row"), type = "numeric", default = 100, help = "Base number per row [default=100]", metavar = "numeric"),
  make_option(c("-r", "--height_per_row"), type = "numeric", default = 200, help = "Height per row [default=200]", metavar = "numeric"),
  make_option(c("-s", "--signal_ratio_cutoff"), type = "numeric", default = 0.33, help = "Signal Ratio Cutoff [default=0.33]", metavar = "numeric"),
  make_option(c("-o", "--output_dir"), type = "character", default = NULL, help = "Directory to save output fasta files. Please provide the full path.", metavar = "character")
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
    TrimmingMethod        = "M2",
    M1TrimmingCutoff      = NULL,
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
