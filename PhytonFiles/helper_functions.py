import glob
import scipy.misc
import math
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
from skimage import data, io, filters
from skimage.morphology import disk, erosion
from PIL import Image
from scipy import ndimage
from circle_degree_helper import *
from get_area_below_the_peak import *
from skimage.filters import threshold_otsu
from scipy.integrate import trapz, simps



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

	#plt.figure()

	for image in image_list: 
		plt.subplot(m_and_n[0],m_and_n[1],count)
		plt.imshow(image, cmap = 'Greys_r')
		count += 1

	plt.show()

def create_fft(image_list):
	
	fouriersList = []

	for image in image_list: 
		
		f = np.fft.fft2(image)
		fshift = np.fft.fftshift(f)
		magnitude_spectrum = 20*np.log(np.abs(fshift))
		#magnitude_spectrum = np.abs(fshift)
		magnitude_spectrum *= 1/np.max(magnitude_spectrum)


		fouriersList.append(magnitude_spectrum)

	return fouriersList

def rotate_images(image_list):
	
	rotated_images = []

	for image in image_list: 
		
		rotated = np.rot90(image)
		rotated_images.append(rotated)

	return rotated_images

def filtrate_images(image_list):
	filtrated_images = []

	for image in image_list: 
		
		filtrated = filter_by_erode_high_frequencies(image)
		filtrated_images.append(filtrated)

	return filtrated_images


def draw_degrees_on_figures(image_list,degrees_separation):
	with_degrees_images = []
	results = []
	for image in image_list: 
		
		[with_degree_img,result] = draw_degrees_lines(image, degrees_separation)
		with_degrees_images.append(with_degree_img)
		results.append(result)
		#print( "The results are : " + str(result[20]))

	return [with_degrees_images, results]


def plot_angle_distribution(values,statistical_results):
	m_and_n = m_and_n_for(len(values))
	count = 1
	
	for val in values:
		x = np.linspace( 0,180,len(val) )
		plt.subplot(m_and_n[0],m_and_n[1],count)

		#peak_pot_angle_ori_mean_std_max_min
		statistics  = statistical_results[count -1]
		peak_pot    = statistics[0]
		angle_ori   = statistics[1]
		peak_limit  = statistics[2]

		plt.title("Peak Pot.:  " + str(round(peak_pot,2)) + " Ang. Ori.: " + str(round(angle_ori,2)) )
		#plt.title("Peak Pot.:  " + str(round(peak_pot,2)) + " Peak Limit: " + str(peak_limit) )
		plt.plot(x,val)


		count += 1 
		# print("Graph has Y maximum: " + str(np.max(val)) + " at index: " + str(np.argmax(val)) )
		# print("Graph has X maximum: " + str(x[np.argmax(val)])  )


	plt.show()

def add_statistics_to_plot(values):
	m_and_n = m_and_n_for(len(values))
	count = 1

	for val in values:
		plt.subplot(m_and_n[0],m_and_n[1],count)
		plt.title("adios " + str(count))
		count += 1 

	plt.draw()


def smooth_results(results):

	new_results = []
	N = 9

	for result in results:
		new_results.append(np.convolve(result,np.ones((N,))/N,mode='valid'))
	return new_results


def filter_by_erode_high_frequencies(img):
	#kernel = np.ones((5,5),np.uint8)
	#i = ndimage.grey_erosion(img,size=(10,10))
	selem = disk(3)
	#i = erosion(img, selem)
	#print( "the mean  is" + str(np.mean(img)))
	thresh = threshold_otsu(img)
	i = img > thresh
	i = erosion(i, selem)
	return i

def get_statistical_results(results):
	statisticals = []
	means_stds_maxs_mins = []

	for result in results:
		mean               = np.mean(result)
		standard_deviation = np.std(result)
		maximum 		   = np.amax(result)
		index_of_max       = np.argmax(result)
		minimum 		   = np.amin(result)
		

		x,dx = np.linspace(0,180,len(result),retstep=True)
		total_area_below_the_curve = trapz(result,x)

		middle = ((maximum-minimum)/2) + minimum

		
		peakArea_peakWidthRatio_limits = get_area_below_the_peak(result,x,index_of_max,middle,0.005)

		peak_area    	   = peakArea_peakWidthRatio_limits[0]
		peak_width_ratio   = peakArea_peakWidthRatio_limits[1]
		peak_limits        = peakArea_peakWidthRatio_limits[2]

		if peak_area == -1:
			peak_area 		   = total_area_below_the_curve
			peak_width_density = 1 
			print("ERROR ON THE AREA")


		areas_ratio  = peak_area/total_area_below_the_curve
		peak_potency = areas_ratio/peak_width_ratio 

		angle_orientation = x[np.argmax(result)]
		# print("Peak Potency: " + str(peak_potency))
		# print("Angle Orientation: " + str(angle_orientation) )

		peak_pot_angle_ori_pkLim_mean_std_max_min = [peak_potency,angle_orientation,peak_limits, mean, standard_deviation,maximum,minimum]
		statisticals.append(peak_pot_angle_ori_pkLim_mean_std_max_min)
		print("medium is: "+ str(middle))

		# print("In statistics has Y maximum: " + str(np.max(result)) + " at index: " + str(np.argmax(result)) )
		# print("dx is: " + str(dx))
		# print("In statistics has X maximum: " + str(x[np.argmax(result)])  )

	return statisticals










	


