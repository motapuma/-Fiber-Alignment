import numpy as np
from scipy.integrate import trapz, simps

def get_area_below_the_peak(results,x,index_of_max, middle_value,tolerance):
	left_arr  = results[1:index_of_max]
	rigth_arr = results[index_of_max:]

	the_middle_to_find   = middle_value

	rigth_limit = np.argwhere( abs(rigth_arr - the_middle_to_find) < tolerance )
	left_limit  = np.argwhere( abs(left_arr  - the_middle_to_find)  < tolerance  )

	noEnoughRigth = len(rigth_limit) == 0
	noEnoughLeft  = len(left_limit)  == 0


	if noEnoughRigth:
		rigth_limit = -1 #go to the end
	else:
		rigth_limit = rigth_limit[0][0] + index_of_max

	if noEnoughLeft:
		left_limit = 1 #go to the first element in the left
	else:
		left_limit = left_limit[-1][0]#i should take the last one
	

	if left_limit == rigth_limit:
		if left_limit != 0:
			left_limit = left_limit - 1 
		else:
			left_limit = left_limit + 1 
	
	#print("left lim." + str(round(x[left_limit],2)) )
	separation = abs(rigth_limit- left_limit)
    
	area_below_the_peak = trapz(results[left_limit:rigth_limit],x[left_limit:rigth_limit])

	if noEnoughRigth:

		new_left_index = np.argwhere(abs(left_arr-the_middle_to_find)< tolerance)

		if len(new_left_index) > 0:
			new_left_index = new_left_index[0][0]
			left_limit     = new_left_index

			if new_left_index <= 1:
				# it is to close to the edge so better to keep it like this
				print("nothing to do1")
			else:
				new_area    = trapz(results[0:new_left_index],x[0:new_left_index])
				separation +=  new_left_index
				area_below_the_peak += new_area
    		
		else:
			area_below_the_peak = -1
			print("ERROOR IN THE RIGTH SIDE")


	if noEnoughLeft:
		new_rigth_index =  np.argwhere(abs(rigth_arr-the_middle_to_find)< tolerance)

		if len(new_rigth_index) > 0:
			new_rigth_index = new_rigth_index[0][-1]
			rigth_limit     = new_rigth_index

			if abs(new_rigth_index - len(rigth_arr)) <= 1:
				# is in the boundary! but lets keep it like it is
				print("nothing to do2")
			else:
				new_area    = trapz(results[new_rigth_index:-1],x[new_rigth_index:-1])
				separation += new_rigth_index
				area_below_the_peak += new_area

		else:
			area_below_the_peak = -1
			print("ERROOR IN THE RIGTH SIDE")

	step_size  = 180/len(x)		

	peak_width_ratio = separation /float(len(x))
	limits = [round(x[left_limit],2),round(x[rigth_limit],2)]

	return (area_below_the_peak ,peak_width_ratio, limits) 










    		


