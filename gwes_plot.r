# ----------------------------------------------------------------------
# Genome-wide epistasis studies (GWES) Manhattan plot script
# Copyright (c) 2018-2019 Juri Kuronen and Santeri Puranen.
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# Filepaths.
# ----------------------------------------------------------------------

# Full filepath for SpydrPick's output.
input_full_filepath <- ""

# Plot output directory and name.
plot_output_directory_path <- getwd()
plot_output_filename_prefix <- "gwes_plot"

# ----------------------------------------------------------------------
# Plotting parameters.
# ----------------------------------------------------------------------

# Plot sizes
plot_width <- 1920
plot_height <- 1080
plot_pointsize <- 16

# Number of edges to draw (0 - draw all).
n_edges <- 0

# Linkage disequilibrium distance (0 - not drawn).
ld_dist <- 0

# Estimated outlier thresholds (0 - not drawn).
outlier_threshold <- 0
extreme_outlier_threshold <- 0

# Colors.
color_direct <- rgb(0, 115, 190, maxColorValue = 255)
color_indirect <- rgb(192, 192, 192, maxColorValue = 255)

# Various.
plot_symbol <- 19 # 19 - solid circle.
cex_direct <- 0.2
cex_indirect <- 0.1
cex_legend <- 1.2

# Disable scientific notation
options(scipen=999)

# ----------------------------------------------------------------------
# Read input.
# ----------------------------------------------------------------------

time_reading_start  <- proc.time()
input <- read.csv(input_full_filepath, header = FALSE, sep = " ") # May take a few minutes.
if (n_edges <= 0 || n_edges > dim(input)[1]) { n_edges <- dim(input)[1] }
time_reading_end <- proc.time()
time_reading <- (time_reading_end - time_reading_start)[[3]]

# ----------------------------------------------------------------------
# Create plot image. May take a few minutes.
# ----------------------------------------------------------------------

time_plotting_start <- proc.time()

min_mi <- min(input[1:n_edges, 5])
max_mi <- max(input[1:n_edges, 5])
max_distance <- max(input[1:n_edges, 3])
exponent <- round(log10(max_distance)) - 1

# Get unique output filename.
output_full_filepath <- paste(plot_output_directory_path, "/", plot_output_filename_prefix, "_", plot_width, "x", plot_height, "_", n_edges, "edges.png", sep="")
output_file_unique_idx <- 1
while (file.exists(output_full_filepath)) {
  output_full_filepath <- paste(plot_output_directory_path, "/", plot_output_filename_prefix, "_", plot_width, "x", plot_height, "_", n_edges, "edges.", output_file_unique_idx, ".png", sep="")
  output_file_unique_idx <- output_file_unique_idx + 1
}

png(output_full_filepath, width = plot_width, height = plot_height, pointsize = plot_pointsize)
plot(input[!input[, 4], 3], input[!input[, 4], 5], col = color_indirect, type = "p", pch = plot_symbol, cex = cex_indirect, 
     xlim = c(0, max_distance), ylim = c(min_mi, max_mi), xaxs = "i", yaxs = "i",
     xlab = "", ylab = "", xaxt = "n", yaxt = "n", bty = "n")
lines(input[as.logical(input[, 4]), 3], input[as.logical(input[, 4]), 5], col = color_direct, type = "p", pch = plot_symbol, cex = cex_direct)
axis(1, at = seq(0, max_distance, 10^exponent), tick = FALSE, labels = seq(0, max_distance / 10^exponent), line = -0.8)
axis(2, at = seq(0.05, 1, 0.05), labels = FALSE, tcl = -0.5)
axis(2, at = seq(0.1, 1, 0.1), labels = seq(0.1, 1, 0.1), las = 1, tcl = -0.5)
title(xlab = "Distance between positions (bp)", line = 1.2)
title(xlab = substitute(x10^exp, list(exp = exponent)), line = 1.4, adj = 1)
title(ylab = "Mutual information", line = 2.5)
if (ld_dist > 0) { segments(ld_dist, min_mi, ld_dist, 1, col = "red", lty = 2) } # Linkage disequilibrium distance.
if (outlier_threshold > 0) {
  segments(0, outlier_threshold, max_distance, outlier_threshold, col = "red", lty = 2) 
  text(0, outlier_threshold, "*", col = "red", pos = 2, offset = 0.2, cex = 1, xpd = NA)
}
if (extreme_outlier_threshold > 0) { # Extreme outlier threshold.
  segments(0, extreme_outlier_threshold, max_distance, extreme_outlier_threshold, col = "red", lty = 2) 
  text(0, extreme_outlier_threshold, "**", col = "red", pos = 2, offset = 0.2, cex = 1, xpd = NA)
}
legend(x = max_distance, y = max_mi, cex = cex_legend, pch = plot_symbol, bty = "n", xjust = 1.2, yjust = 1.2,
       c("Indirect", "Direct"), col = c(color_indirect, color_direct))
dev.off()
time_plotting_end <- proc.time()
time_plotting <- (time_plotting_end - time_plotting_start)[[3]]
