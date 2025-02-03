# Load required libraries
library(ape)
library(ggtree)
library(optparse)

# Define command-line options
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL, 
              help = "Input Newick tree file", metavar = "file"),
  make_option(c("-o", "--output"), type = "character", default = "tree_plot.pdf", 
              help = "Output PDF file", metavar = "file")
)

# Parse arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check if input file is provided
if (is.null(opt$input)) {
  print_help(opt_parser)
  stop("Error: An input Newick file must be provided.", call. = FALSE)
}

# Read the phylogenetic tree
tree <- read.tree(opt$input)

# Create the plot
p <- ggtree(tree) +
  geom_tiplab() +  # Display tip labels
  geom_text2(aes(subset = !is.na(node) & node > length(tree$tip.label), 
                 label = bootstrap), hjust = -0.3) + # Display bootstrap values
  geom_treescale()  # Add a scale bar

# Save to PDF
pdf(opt$output, width = 8, height = 6)
print(p)
dev.off()

# Print a message indicating successful completion
cat("Phylogenetic tree saved to", opt$output, "\n")
