#needed.. "Scipy" and "Image Module (PIL) Pillow"
#install conda for Scipy https://www.continuum.io/downloads
#install Pillow in terminal "pip install Pillow"
#install Pillow in terminal "pip install Pillow"
from helper_functions import *
from circle_degree_helper import *
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import scipy.misc

daniel0_robin1 = 1 #choose 0 to assess Daniels Images.. Or 1 to look robins imabes

image_list = read_images(daniel0_robin1,1)# Choose -1 to analyse all images, or write the amount of images you want to asses
fouriers   = create_fft(image_list)
#show_images(fouriers)

rotated    = rotate_images(fouriers)
#show_images(rotated)
[with_degrees_images, results] = draw_degrees_on_figures(rotated,1)
#show_images(with_degrees_images)

print("Length Values: " + str( len(results[0]) ) )

plot_angle_distribution(results)


