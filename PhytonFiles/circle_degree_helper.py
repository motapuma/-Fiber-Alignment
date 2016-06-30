import numpy as np
import math


def draw_degrees_lines(image, degrees_separation):
	height = image.shape[0]
	width  = image.shape[1]

	middle_height = round(height*0.5)
	middle_width  = int(round(width*0.5))
	new_img = np.copy(image)
	degrees_values = []

	for angle in np.arange(0,180.1,degrees_separation):
		
		rad_degree = math.radians(angle)
		m        = -math.tan(rad_degree)#es negativo porque las y corren hacia abajo positivamente

		#print("ANGLE "       + str(rad_degree)+ "..." + str(angle))
		#print("tan(angle) = "  + str(m))
		sum_on_degree = 0

		if abs(m) > 10e10:
			#print('Infinite')
			num_of_elements = 0
			ys = np.arange(0,middle_height+1)
			sum_on_degree   = 0

			for y in ys:
				y = int(y)

				new_img[y][middle_width] = 255 
				val_to_sum               = image[y][middle_width]
				sum_on_degree           += val_to_sum
				num_of_elements          = num_of_elements + 1
				#print("sumo: " + str(val_to_sum) + " en y=" + str(y) )

			#print(" ES 180 creo... ")

		else:
			#print('NON infinite')
			#get the coordinates where it should be the line....
			# y=m*x+b
			# 
			if angle < 90:
				xs = np.linspace(middle_width,width-1,num=middle_width*10)
			else:
				xs = np.linspace(0,middle_width,num=middle_width*10)

			b = middle_height - (m * middle_width)
			ys = (xs*m)+b
			ys = np.around(ys)
			xs = np.around(xs)
			
			sum_on_degree   = 0
			i               = 0
			num_of_elements = 0

			for x in xs:
				y = int(ys[i])
				x = int(x)
				i = i + 1
				
				#num_of_elements =  num_of_elements + 1

				if y > 0 and y < height and x > 0 and x < width:
					new_img[y][x]   = 255 
					sum_on_degree  += image[y][x]
					num_of_elements =  num_of_elements + 1
				
					
				#	print("Val to Sum: " + str(image[y][x]))
				#	print("x:" + str(x) +  ", y:" + str(y) )


		# if angle == 90: 
		#   	print("sum " + str(sum_on_degree))
		#  	print("num of ele " + str(num_of_elements))
				
		to_store_value = float(sum_on_degree) / float(num_of_elements)		 
		#print("sum on degree:"+str(sum_on_degree)+" # of element:"+ str(num_of_elements) + " to store value: " + str(to_store_value))						
		degrees_values.append(to_store_value)

	#print( "One image completly done" + str(len(degrees_values)) )
	return [new_img,degrees_values]









