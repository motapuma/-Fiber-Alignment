import glob
import scipy.misc
import math
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
from PIL import Image
from circle_degree_helper import *

def read_images(daniel0_robin1,limit):
	image_list = []
	directory = '../FiberImages/DanielRowsonImages/*.tif'  if  daniel0_robin1 == 0  else  '../FiberImages/RobinImages/oneEachGroup/*.tif'

	count =0

	for filename in glob.glob(directory): 

		if limit < 0 or count < limit:
			i = Image.open(filename)
			imag = i.convert('L')
			image_list.append(imag)
		count += 1

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
	
	fouriersList = []

	for image in image_list: 
		
		f = np.fft.fft2(image)
		fshift = np.fft.fftshift(f)
		#magnitude_spectrum = 20*np.log(np.abs(fshift))
		magnitude_spectrum = np.abs(fshift)
		magnitude_spectrum *= 255/np.max(magnitude_spectrum)


		fouriersList.append(magnitude_spectrum)

	return fouriersList

def rotate_images(image_list):
	
	rotated_images = []

	for image in image_list: 
		
		rotated = np.rot90(image)
		rotated_images.append(rotated)

	return rotated_images


def draw_degrees_on_figures(image_list,degrees_separation):
	with_degrees_images = []
	results = []
	for image in image_list: 
		
		[with_degree_img,result] = draw_degrees_lines(image, degrees_separation)
		with_degrees_images.append(with_degree_img)
		results.append(result)

	return [with_degrees_images, results]


def plot_angle_distribution(values):


	x = np.linspace( 0,180,len(values[0]) )

	#print(len(values[0]))
	#print(len(x))

	plt.scatter(x,values[0])
	plt.show()



	


