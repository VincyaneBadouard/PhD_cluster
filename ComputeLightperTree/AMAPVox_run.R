# AMAPVox run

library(xml2)

# Cluster paths
# path <- '/cirad_lotois/work/users/VincyaneBadouard/Lidar/ALS2023/HighAltitudeFlight/ByTree_Input/'
path <- '/lustre/badouardv/ForTrees/'
# path <- '//amap-data.cirad.fr/work/users/VincyaneBadouard/Lidar/ALS2023/HighAltitudeFlight/ForTrees/' # local path

# Edit xml file ----------------------------------------------------------------
xml_file0 <- read_xml(paste(path,
                            "xml/P16_2023_25ha_buffer_HighAlt_Vox_intensity1m_cluster.xml", sep=''))
# Input
## laz
# Lazin <- paste(path,"LAZ/P16_2023_25ha_HighAlt_buffer50m_intensitycor.laz", sep='')
# ## traj
# trajin <- paste(path,"traj/trajecto1000m.txt", sep='')
# ## DTM
# DTMin <- paste(path,"MNT/dtm2023_HighAlt_25ha_buffer.asc", sep='')
# 
# # Output path
# Outputpath <- paste(path,
#                     "Vox/P16_2023_25ha_buffer_HighAlt_Vox_equalecho1m.vox", sep='')
# 
# # get node configuration/process
# process <- xml_children(xml_file0)[[1]]
# 
# # update current input file
# input_node <- xml_child(process, "input_file")
# xml_attr(input_node, "src") <- VXin
# 
# # update current output file
# output_node <- xml_child(xml_child(process, "output_files"))
# xml_attr(output_node, "src") <- Outputpath


# Run with the configuration file ----------------------------------------------
AMAPVox::run(xml = path, jvm.option = "-Xms16g")
