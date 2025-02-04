# Function to suppress library loading messages
suppress_lib_loading <- function(package) {
  suppressMessages(library(package, character.only = TRUE))
}

# Load required libraries
suppress_lib_loading('ape')
suppress_lib_loading('ggtree')
suppress_lib_loading('optparse')

# Define command-line options
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL, 
              help = "Input Newick tree file (relative or absolute path)", metavar = "file"),
  make_option(c("-o", "--output"), type = "character", default = "tree_plot.pdf", 
              help = "Output PDF file (relative or absolute path) [default='tree_plot.pdf']", metavar = "file")
)

# Parse arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check if input file is provided
if (is.null(opt$input)) {
  print_help(opt_parser)
  stop("Error: An input Newick file must be provided.", call. = FALSE)
}

# Convert relative paths to absolute paths
input_file <- normalizePath(opt$input, mustWork = TRUE)
output_file <- normalizePath(opt$output, mustWork = FALSE)

# Read the phylogenetic tree
tree <- read.tree(input_file)

# Create the plot
p <- ggtree(tree) +
  geom_text2(aes(subset = !is.na(label), label = label), hjust = -0.3) + # Display bootstrap values
  geom_treescale()  # Add a scale bar

# Save to PDF
pdf(output_file, width = 8, height = 6)
print(p)
dev.off()

# Print a message indicating successful completion
cat("Phylogenetic tree saved to", output_file, "\n")
