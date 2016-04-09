import glob
import scipy.misc
import math
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
from PIL import Image

def read_images(daniel0_robin1):
	image_list = []
	directory = '../FiberImages/DanielRowsonImages/*.tif'  if  daniel0_robin1 == 0  else  '../FiberImages/RobinImages/oneEachGroup/*.tif'

	for filename in glob.glob(directory): 
		i = Image.open(filename)
		im = i.convert('L')
		image_list.append(im)
	return image_list

def m_and_n_for(nEle):
	m =0
	n =0

	if nEle ==9:
		m =3
		n =3
	elif nEle==6:
		m =3
		n =2
	elif nEle==4:
		m =2
		n =2
	elif nEle==1:
		m =1
		n =1
	else:
		m = 2
		n = math.ceil(nEle/m)
	return [m,n]

def show_images(image_list):
	m_and_n = m_and_n_for(len(image_list))
	count = 1

	for image in image_list: 
		plt.subplot(m_and_n[0],m_and_n[1],count)
		plt.imshow(image)
		count += 1

	plt.show()

def create_fft(image_list):
	
	count = 1
	m_and_n = m_and_n_for(len(image_list))
	#image_list = [mpimg.imread('messi.jpg')]

	for image in image_list: 
		
		f = np.fft.fft2(image)
		fshift = np.fft.fftshift(f)
		magnitude_spectrum = 20*np.log(np.abs(fshift))
		plt.subplot(m_and_n[0],m_and_n[1],count)
		# plt.imshow(magnitude_spectrum, cmap = 'gray')
		plt.imshow(magnitude_spectrum)
		count += 1
	plt.show()




	


