## ---- include = FALSE---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7, 
  fig.height = 4
)

old <- options(width = 200)

## ----setup--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(rstoat)

## ---- eval = FALSE------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  mol_login("your.email@address.com", "password")

## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#download_sample_data("destination/path")
samples_directory <- download_sample_data()
list.files(samples_directory)

## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
head(get_products())
powerful_owl_sample <- read.csv("sample_data/powerful_owl_vignette.csv")
head(powerful_owl_sample)
simple_results <- start_annotation_simple(powerful_owl_sample[1:50,], "modis-lst_day-1000-1",
                                          coords = c("decimalLongitude", "decimalLatitude"),
                                          date = "eventDate")
head(simple_results)

## ----eval = FALSE-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  dataset_list <- my_datasets()
#  head(dataset_list)

## ---- eval = FALSE------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  get_products()
#  #start_annotation_batch("dataset_id", "Annotation Title", "Layer Code(s)")
#  # Here we retrive the UUID of the most recent datasets (the powerful owl and budgerigar), and start annotation on them
#  start_annotation_batch(dataset_list$dataset_id[1], "powerful_owl_vignette", c("modis-lst_day-1000-1", "modis-lst_day-1000-30"))
#  start_annotation_batch(dataset_list$dataset_id[2], "budgerigar_vignette", "modis-lst_day-1000-1")

## ---- eval = FALSE------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  job_list <- my_jobs()
#  head(job_list)

## ---- eval = FALSE------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  #job_details("annotation_id")
#  job_details(job_list$annotation_id[1])
#  
#  #job_species("annotation_id")
#  job_species(job_list$annotation_id[1])

## ---- eval = FALSE------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  #download_annotation("annotation_id", "optional/destination/directory")
#  ninox_result_dir <- download_annotation(job_list$annotation_id[1])
#  melopsittacus_result_dir <- download_annotation(job_list$annotation_id[2])

## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#dataframe_name <- read_output("path/to/your/downloaded/data/directory")

# This it the code you would use if you directly downloaded a successful annotation
#ninox <- read_output(ninox_result_dir)

# Instead, here we read the equivalent output from the sample data directory
ninox <- read_output(paste0(samples_directory, "/powerful_owl_results"))
head(ninox)

## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hist(ninox$modis_lst_day_1000_1-273.15, breaks = 50, xlab = "MODIS LST Day (degrees C)", ylab = "Count",
     main = "Ninox strenua: MODIS LST Day")
plot(as.Date(ninox$date.y), (ninox$modis_lst_day_1000_1-273.15),
     xlim = as.Date(c("2010-01-01", "2019-01-01")),
     xlab = "Year", ylab = "MODIS LST Day (degrees C)",
     main = "Ninox strenua: MODIS LST Day")
axis.Date(1, ninox$date, at=seq(as.Date("2009-01-01"), as.Date("2019-01-01"), by="years"))

## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
melopsittacus <- read_output(paste0(samples_directory, "/budgerigar_results"))
two_species <- rbind(melopsittacus[,1:10], ninox[,1:10])
plot((modis_lst_day_1000_1-273.15) ~ as.Date(date.y), data = two_species,
     col = as.numeric(factor(two_species$scientificname)),
     xlim = as.Date(c("2010-01-01", "2019-01-01")),
     pch = as.numeric(factor(two_species$scientificname)), cex = 0.4,
     xlab = "Year", ylab = "MODIS LST Day (degrees C)",
     main = "Powerful Owl vs Budgerigar MODIS LST Day")
axis.Date(1, two_species$date, at=seq(as.Date("2009-01-01"), as.Date("2019-01-01"), by="years"))
legend(x="topright", legend = as.character(levels(factor(two_species$scientificname))),
       pch = 1:length(levels(factor(two_species$scientificname))),
       col=1:length(levels(factor(two_species$scientificname))))

## ------------------------------------------------------------------------
plot(density(na.omit(ninox$modis_lst_day_1000_30-273.15)),col = "red",
     xlab = "MODIS LST Day (degrees C)",
     main = "Powerful Owl MODIS LST Day 1 vs 30-day t_buff")
lines(density(na.omit(ninox$modis_lst_day_1000_1-273.15)), col = "black")
legend(x="topright", legend = c("1-day t_buff", "30-day t_buff"),
       pch = 20,
       col=c("black", "red"))
options(old)

