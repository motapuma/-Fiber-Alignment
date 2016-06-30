#needed.. "Scipy" and "Image Module (PIL) Pillow"
#install conda for Scipy https://www.continuum.io/downloads
#install Pillow in terminal "pip install Pillow"
#install Pillow in terminal "pip install Pillow"
#install SCIKIT-IMAGE terminal "pip install -U scikit-image"
from helper_functions import *
from circle_degree_helper import *
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import scipy.misc

daniel0_robin1 = 1 #choose 0 to assess Daniels Images.. Or 1 to look robins imabes

image_list = read_images(daniel0_robin1,1)# Choose -1 to analyse all images, or write the amount of images you want to asses
#show_images(image_list)
fouriers   = create_fft(image_list)
#show_images(fouriers)

filtrated_fouriers =  filtrate_images(fouriers)

rotated    = rotate_images(filtrated_fouriers)

#show_images(rotated)
[with_degrees_images, results] = draw_degrees_on_figures(rotated,1)
#show_images(with_degrees_images)

##print("Length Values: " + str( len(results[0]) ) )

smoothed_results    = smooth_results(results)
statistical_results = get_statistical_results(smoothed_results)

plot_angle_distribution(smoothed_results,statistical_results)


