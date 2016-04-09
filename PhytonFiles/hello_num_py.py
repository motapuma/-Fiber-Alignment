#needed.. "Scipy" and "Image Module (PIL) Pillow"
#install conda for Scipy https://www.continuum.io/downloads
#install Pillow in terminal "pip install Pillow"
#install Pillow in terminal "pip install Pillow"


from helper_functions import read_images,show_images,create_fft
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import scipy.misc

print("Probing NumPy!")
daniel0_robin1 = 1

#f = scipy.misc.face(gray = True)
#scipy.misc.imsave('vaca.png', f) # uses the Image module (PIL)

# f=mpimg.imread('cyclic1-4.tif')

# plt.imshow(f) 
# plt.show()


image_list = read_images(daniel0_robin1)
# show_images(image_list)
fouriers = create_fft(image_list)
show_images(fouriers)