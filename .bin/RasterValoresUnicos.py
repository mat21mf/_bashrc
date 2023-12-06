#!/usr/bin/python -tt
#-*- coding: UTF-8 -*-

'''
#####################################################################
This script is designed to compute unique values of the given raster
#####################################################################
'''

from osgeo import gdal
import sys
import math

args = sys.argv
if len(args)==0:
    print("Al menos un argumento debe ser suministrado.")

### path = "/home/matbox/Documents/TrabajosExtra/DriveBiotopos/Matias_Rebolledo/Raster/CapasFAU23_5/grupo03MaskSample/DEM_reclass_grupo03.tif"
### path = "/home/matbox/Documents/TrabajosExtra/DriveBiotopos/Rasters/Resultados_Kmeans/grupo03MaskSample/grupo03MaskSample_Coord_kmn0007_var08_cluster_gdal.tif"
### path = "/home/matbox/Documents/TrabajosExtra/DriveBiotopos/Rasters/Resultados_Kmeans/grupo03MaskSample/grupo03MaskSample_Coord_kmn0007_var08_cluster_gdal_calc.tif"
### path = "/home/matbox/Documents/TrabajosExtra/DriveBiotopos/Rasters/Resultados_Kmeans/grupo03MaskSample/grupo03MaskSample_Coord_kmn0007_var08_cluster_gdal_byte.tif"

def ContarValoresUnicos( path ):

    gdalData = gdal.Open(path)
    if gdalData is None:
      sys.exit( "ERROR: can't open raster" )
    
    # get width and heights of the raster
    xsize = gdalData.RasterXSize
    ysize = gdalData.RasterYSize
    
    # get number of bands
    bands = gdalData.RasterCount
    
    # process the raster
    for i in xrange(1, bands + 1):
      band_i = gdalData.GetRasterBand(i)
      raster = band_i.ReadAsArray()
    
      # create dictionary for unique values count
      count = {}
    
      # count unique values for the given band
      for col in range( xsize ):
        for row in range( ysize ):
          cell_value = raster[row, col]
    
          # check if cell_value is NaN
          if math.isnan(cell_value):
            cell_value = 'Null'
    
          # add cell_value to dictionary
          try:
            count[cell_value] += 1
          except:
            count[cell_value] = 1
    
      # print results sorted by cell_value
      for key in sorted(count.iterkeys()):
          print "band #%s - %s: %s" %(i, key, count[key])
    
if __name__ == "__main__":
    ContarValoresUnicos(
    path   = args[1]
    )
