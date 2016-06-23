import numpy as np
import math


def draw_degrees_lines(image, degrees_separation):
	height = image.shape[0]
	width  = image.shape[1]

	middle_height = round(height*0.5)
	middle_width  = round(width*0.5)
	new_img = image
	degrees_values = []
	for angle in np.arange(0,180.1,degrees_separation):
		
		rad_degree = math.radians(angle)
		m        = -math.tan(rad_degree)#es negativo porque las y corren hacia abajo positivamente

		#print("ANGLE "       + str(rad_degree)+ "..." + str(angle))
		#print("tan(angle) = "  + str(m))
		sum_on_degree = 0

		if abs(m) > 10e10:
			#print('Infinite')
			
			ys = np.linspace(0,middle_height,height*10)

			for y in ys:
				new_img[y][middle_width] = 255 
				sum_on_degree += image[y][middle_width]
				#print("x:" + str(middle_width) +  ", y:" + str(y) )

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
			
			sum_on_degree = 0

			i =0

			for x in xs:
				y = ys[i]
				i = i + 1
				#print("x:" + str(x))
				if y > 0 and y < height and x > 0 and x < width:
					new_img[y][x] = 255 
					sum_on_degree += image[y][x]
				#	print("x:" + str(x) +  ", y:" + str(y) )
								
		degrees_values.append(sum_on_degree)

	#print( "One image completly done" + str(len(degrees_values)) )
	return [new_img,degrees_values]









