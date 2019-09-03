# to use this function from another file, run: source("scatter_marg_hist.R")

# This is just wrapped into a function from the following articles, all credits go to the authors of:
#  1) http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/78-perfect-scatter-plots-with-correlation-and-marginal-histograms/
#  2) https://twitter.com/ClausWilke/status/900776341494276096

library(cowplot)
library(ggpubr)

scatter_marg_hist <- function(dataframe, x_column, y_column, fill_column, palette = "jco") {
# example: scatter_marg_hist(iris, Sepal.Length, Sepal.Width, Species)

    # Main plot
    pmain <- ggplot(dataframe, aes_string(x = x_column, y = y_column, color = fill_column))+
      geom_point()+
      ggpubr::color_palette(palette)

    # Marginal densities along x axis:
    xdens <- axis_canvas(pmain, axis = "x")+
      geom_density(data = dataframe, aes_string(x = x_column, fill = fill_column),
                  alpha = 0.7, size = 0.2)+
      ggpubr::fill_palette(palette)

    # Marginal densities along y axis:
    ydens <- axis_canvas(pmain, axis = "y", coord_flip = TRUE)+
      geom_density(data = dataframe, aes_string(x = y_column, fill = fill_column),
                    alpha = 0.7, size = 0.2)+
      coord_flip()+
      ggpubr::fill_palette(palette)

    # Combine all 3 plots:
    p1 <- insert_xaxis_grob(pmain, xdens, grid::unit(.2, "null"), position = "top")
    p2 <- insert_yaxis_grob(p1, ydens, grid::unit(.2, "null"), position = "right")
    ggdraw(p2)

    # Actually show the plot. You may or may not want this.
    plot(p2)
}
