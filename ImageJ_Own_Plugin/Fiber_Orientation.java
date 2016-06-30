import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.Arrays;
import ij.plugin.frame.*;
import ij.*;
import ij.process.*;
import ij.gui.*;
import ij.process.FHT;




public class Fiber_Orientation extends PlugInFrame implements ActionListener {

	public static final String THRESHOLD     = "Threshold";
	public static final String FFT_AND_ROT  = "FFT and Rotate";
	public static final String ORIGINAL_FFT = "Orig. FFT";
	public static final String ERODE        = "Erode";
	public static final String DILATE       = "Dilate";	
	
	public static final String AUTOMATIZATED    = "Automatic";
	public static final String ANALYZE          = "Analize";
	public static final String BINARY_THRESHOLD = "Binary Thres.";
	public static final String DRAW_ANGLE       = "Draw Angles";
	

	private Panel panel;
	private int previousID;
	private static Frame instance;
	private TextField threshold_value_tf;
	private TextField degree_separation_value_tf;
	public ImagePlus ourImage;
	public ImagePlus fftImage;
	public Plot plot;



	public Fiber_Orientation() {
		super("Fiber Orientation");
		
		if (instance!=null) {
			this.instance.toFront();
			return;
		}

		this.instance = this;
		addKeyListener(IJ.getInstance());

		setLayout(new FlowLayout());
		panel = new Panel();
		panel.setLayout(new GridLayout(0, 2, 5, 5));

		addTextFieldThreshold("Threshold");
		addTextFieldDegreeSeparation("Degree Sep.");

		this.addCheckBox(BINARY_THRESHOLD);
		this.addCheckBox(DRAW_ANGLE);
		

		addButton(AUTOMATIZATED,false);
		addButton(FFT_AND_ROT,false);

		addButton(THRESHOLD,true);
		addButton(ORIGINAL_FFT,true);

		addButton(ERODE,true);
		addButton(DILATE,true);

		
		
		addButton(ANALYZE,true);
		
		//addButton("Close",false);
		
		
		add(panel);
		
		pack();
		GUI.center(this);
		setVisible(true);
	}
	
	void addButton(String label,boolean disabled) {
		Button b = new Button(label);
		b.setEnabled(!disabled);
		b.addActionListener(this);
		b.addKeyListener(IJ.getInstance());
		panel.add(b);
	}

	void addCheckBox(String label){
		panel.add(new Checkbox(label));
	}


	void addTextFieldThreshold(String label) {
		this.threshold_value_tf = new TextField("170");
		panel.add(new Label(label));
		panel.add(this.threshold_value_tf);
	}
	void addTextFieldDegreeSeparation(String label){
		this.degree_separation_value_tf = new TextField("1");
		panel.add(new Label(label));
		panel.add(this.degree_separation_value_tf);
	}

	void enableButton(String label, boolean enable){

		for(int i =0; i< this.panel.getComponentCount(); i++){

			Component component = this.panel.getComponent(i);
			//IJ.write(component.getClass().toString());

			if ( component.getClass().equals(Button.class) ){
				Button b = (Button) component;
				if(b.getLabel().equals(label) ){
					b.setEnabled(enable);
					i = this.panel.getComponentCount();
				}
			}


		}

	}


	boolean readCheckBox(String label){

		for(int i =0; i< this.panel.getComponentCount(); i++){

			Component component = this.panel.getComponent(i);
			//IJ.write(component.toString());

			if( component.getClass().equals(Checkbox.class) ){
				Checkbox cb = (Checkbox) component;
				if(cb.getLabel().equals(label) )
					return cb.getState();
			}
		}

		return false;
	}


	public void actionPerformed(ActionEvent e) {
		ImagePlus imp = WindowManager.getCurrentImage();

		if (imp==null) {
			IJ.beep();
			IJ.showStatus("No image!!!");
			previousID = 0;
			return;
		}
		
		//IJ.write(threshold_value_tf.getText());

		if (!imp.lock())
			{previousID = 0; return;}
		int id = imp.getID();
		if (id!=previousID)
			imp.getProcessor().snapshot();
		previousID = id;
		String label = e.getActionCommand();
		if (label==null)
			return;
		//int threshold_value = Integer.parseInt(threshold_value_tf.getText());
		new Runner(label, imp,this);
	}

	public void processWindowEvent(WindowEvent e) {
		super.processWindowEvent(e);
		if (e.getID()==WindowEvent.WINDOW_CLOSING) {
			instance = null;	
		}
	}


	 // Runner inner class

	class Runner extends Thread { // inner class
		private String command;
		private ImagePlus imp;
		public int threshold_value   = 0;
		public int degree_separation = 0;
		private Fiber_Orientation caller;

		Runner(String command, ImagePlus imp,Fiber_Orientation callerL) {
			super(command);
			this.command = command;
			this.imp = imp;
			
			setPriority(Math.max(getPriority()-2, MIN_PRIORITY));
			this.caller = callerL;

			this.threshold_value   = Integer.parseInt(callerL.threshold_value_tf.getText());
			this.degree_separation = Integer.parseInt(callerL.degree_separation_value_tf.getText());


			start();
		}
	
		public void run() {
			try {
				runCommand(command, imp);
			} catch(OutOfMemoryError e) {
				IJ.outOfMemory(command);
				if (imp!=null) imp.unlock();
			} catch(Exception e) {
				CharArrayWriter caw = new CharArrayWriter();
				PrintWriter pw = new PrintWriter(caw);
				e.printStackTrace(pw);
				IJ.log(caw.toString());
				IJ.showStatus("");
				if (imp!=null) imp.unlock();
			}
		}
	
		void runCommand(String command, ImagePlus imp) {
			ImageProcessor ip = imp.getProcessor();
			IJ.showStatus(command + "...");
			long startTime = System.currentTimeMillis();
			Roi roi = imp.getRoi();
			if (command.startsWith("Zoom")||command.startsWith("Macro")||command.equals("Threshold"))
				{roi = null; ip.resetRoi();}
			ImageProcessor mask =  roi!=null?roi.getMask():null;
			

			if (command.equals(FFT_AND_ROT)){

				ImagePlus fft_image  = this.getFftandRotate(imp, ip);
				this.caller.ourImage = fft_image;
				this.storeOriginalFft();

				this.caller.enableButton(THRESHOLD, true);
				this.caller.enableButton(ORIGINAL_FFT, true);
				this.caller.enableButton(ERODE, true);
				this.caller.enableButton(DILATE, true);
				this.caller.enableButton(ANALYZE, true);

				//ImageProcessor binarized_fft = binarize(fft_image_ip);

			}
			
			if (command.equals(ORIGINAL_FFT)){

				 this.restore_original_fft();

			}

			if (command.equals(THRESHOLD)){

				ImagePlus image_thresholded  = this.threshold(this.caller.ourImage);

			}

			if (command.equals(ERODE)){
				this.erode();
			}

			if (command.equals(DILATE)){
				this.dilate();
			}

			if (command.equals(ANALYZE)){
				double[] results = this.drawAngles();
				double[] statistics = this.getStatistics(results);

				String titleText ="Angle: " + String.format( "%.2f", statistics[2]  ) + " Peak Density: " + String.format( "%.2f", statistics[1]);
				this.caller.plot.addText( titleText,0,0);

				this.caller.plot.draw();
        		this.caller.plot.show();
			}

			if (command.equals(AUTOMATIZATED)){
				// GET FFT 
				ImagePlus fft_image  = this.getFftandRotate(imp, ip);
				this.caller.ourImage = fft_image;
				this.storeOriginalFft();
				
				// BINARIZE 
				this.threshold(this.caller.ourImage);

				// erode
				// this.erode();
				// this.erode();
				// this.erode();
				// this.erode();


				//Start Analizing
				this.drawAngles();

			}


			if (command.equals("Close")){

				if(this.caller.ourImage != null){
					this.caller.ourImage.hide();
				}else{
					IJ.write("Dont have out image open");
				}

			}
				
			// else if (command.equals("Macro2"))
			// 	macro2(imp, ip);

			if (mask!=null) ip.reset(mask);
			imp.updateAndDraw();
			imp.unlock();
			//IJ.showStatus((System.currentTimeMillis()-startTime)+" milliseconds");
		}

		// void graphClock(){

			
		// }

		double[] drawAngles(){

			ImagePlus our_img_plus           = this.caller.ourImage;
			ImageProcessor our_img_processor = our_img_plus.getProcessor();


			int size =  (int)Math.round(180/this.degree_separation)+1;

			

			double[] sumatoriesRatios = new double[size] ;
			double[] degrees   		  = new double[size] ;
			int count = 0;

			
			boolean drawLineAtAngle = this.caller.readCheckBox(DRAW_ANGLE);

			for(int degree = 0; degree<= 180; degree += this.degree_separation){

				double sumatoryRatio   = this.drawLineAtDegree(our_img_plus,our_img_processor,degree,drawLineAtAngle);

				sumatoriesRatios[count] = sumatoryRatio;
				degrees[count]	        = (double)degree;
				
				count++;
			}

			our_img_plus.show();
        	our_img_plus.updateAndDraw();

        	sumatoriesRatios = this.smooth(sumatoriesRatios,5);

        	this.caller.plot = new Plot("Angle Distribution", "x", "y", degrees ,sumatoriesRatios ); 

        	this.caller.plot.draw();
        	this.caller.plot.show();

        	return sumatoriesRatios;
        	


		}


		double drawLineAtDegree(ImagePlus our_img_plus,ImageProcessor our_img_processor,int angle,boolean drawLineAtAngle){


			double tangent = Math.tan(Math.toRadians(angle));
			//double m       = - tangent;
			// IJ.write("Angle:" + angle);
			// IJ.write("Tangent: " + tangent);

			int width  = our_img_processor.getWidth();
			int height = our_img_processor.getHeight();

			int middle_width  = Math.round(width/2); 
			int middle_height = Math.round(height/2);

			double sumOfPixels = 0.0;
			int numOfElements  = 0;

			if(tangent > 1E15){
				//IJ.write("Is infinite");

				for(int i = 0;i<= middle_height;i++){

					double sumToTheVal  = (double)our_img_processor.get(middle_width,i);
					sumOfPixels += sumToTheVal/255;
					//IJ.write("sum aT 90:" + sumToTheVal );
					if(drawLineAtAngle){
						
						our_img_processor.set(middle_width,i,128);
					}
						

					numOfElements ++;
				}
					

			}else{
				int start,end; 

				if( tangent >= 0 ){
					start = middle_width;
					end   = width;
				}else{
					start = 0;
					end   = middle_width;
					//start = end*2;
				}

				
				for(double x = start; x < end; x += 0.1  ){

					//int xs,y;

					int y = Math.round((float)middle_height - (float)( (x-middle_width) * tangent) );


					if (y > 0 && y<height){
						
						double sumToTheVal  = (double)our_img_processor.get((int)Math.round(x),y);
						//IJ.write(" this is divided by 128:" + sumToTheVal);
						sumOfPixels += sumToTheVal/255;
						//IJ.write("sum:" + sumToTheVal );
						
						if(drawLineAtAngle){
							
							our_img_processor.set((int)Math.round(x),y,128);
						}
							

						numOfElements ++;
					}
				}


			}
			//IJ.write( "Angle: " + angle +" Value: " + sumOfPixels +  " Num of ele: " +  numOfElements);

			
			if(drawLineAtAngle){

				

				our_img_plus.updateAndDraw();
				our_img_plus.draw();
				our_img_plus.show();

			}

			return (double)sumOfPixels/numOfElements;
		}


		


		double[] getStatistics(double[] anglesSumatories)
		{

			int length = anglesSumatories.length;
			double max = Double.NEGATIVE_INFINITY;
			double min = Double.POSITIVE_INFINITY;
			double middle;
			double stepSize = 180.0/length;
			int indexOfMax = -1;


			for(int i = 0; i< length ; i++)
			{
				double ourVal = anglesSumatories[i];

				if(ourVal < min)
					min = ourVal;

				if(ourVal > max){
					max        = ourVal;
					indexOfMax = i;	
				}
					

			}
			middle = ((max-min)/2) + min;

			double totalAreaBelow   = this.trapz(anglesSumatories, stepSize);
			double[] areaBelowThePeakandWidth = this.getAreaBelowThePeakAndWidthRatio(anglesSumatories,indexOfMax,middle,0.05);

			double areaBelowThePeak = areaBelowThePeakandWidth[0];
			double widthRatioInPixels    = areaBelowThePeakandWidth[1];

			double areasRatio = areaBelowThePeak/totalAreaBelow;

			// IJ.write("below Peak" + areaBelowThePeak);
			// IJ.write("total Area Below" + totalAreaBelow);
			// IJ.write("Width Ratio:" + widthRatioInPixels);

			double peakDensity = areasRatio/widthRatioInPixels;

			double angleOri    = indexOfMax * stepSize;

			IJ.write("Angle Orientation [degrees]: " +  String.format( "%.2f", angleOri )  );
			IJ.write("Peak Density is: " + String.format( "%.2f", peakDensity )  );

			double[] statistics = {max, peakDensity, angleOri};

			return statistics;

		}	

		double[] smooth(double[] arrayToSmooth,int sizeOfSmooth){
			int  len     = arrayToSmooth.length;
			int   offset = (int)Math.ceil(sizeOfSmooth/2);
			double[] res = new double[len];

			//IJ.write("offset is: " +  offset);

			for(int i =offset; i<len-offset; i++){

				double value = 0.0;

				for(int j = 0;j<sizeOfSmooth ;j++){
					int index = i-offset+j;

					//IJ.write("index " +  index);

					value += arrayToSmooth[index];

				}

				res[i] = value/sizeOfSmooth;


			}
			//IJ.write("IT IS is: " +  res[10]);
			return res;

		}

		double[] getAreaBelowThePeakAndWidthRatio(double[] values,int indexOfMax,double middle,double tolerance)
		{

			int rigthIndex,leftIndex;
			double[] rigthSideValues,leftSideValues;
			boolean haveRigthLimit,haveLeftLimit = true;

			leftSideValues  = Arrays.copyOfRange(values,0,indexOfMax);
			rigthSideValues = Arrays.copyOfRange(values,indexOfMax,values.length);


			rigthIndex = this.getArrayClosestToBegingIndex(rigthSideValues,middle, tolerance);
			leftIndex  = this.getArrayClosestToEndIndex(leftSideValues,middle, tolerance);


			haveRigthLimit = rigthIndex != -1;
			haveLeftLimit  = leftIndex  != -1;


			if(!haveRigthLimit)
				rigthIndex =0;
			

			if(!haveLeftLimit)
				leftIndex =0;
			
			double area      = 0.0;
			int widthInteger = rigthIndex + (indexOfMax -  leftIndex ); 

			area = trapz(Arrays.copyOfRange(values,leftIndex, indexOfMax+rigthIndex), 180.0/values.length );

			// IJ.write("Area just after: "   +   area);
			// IJ.write("RIgth Index "   +   rigthIndex);
			// IJ.write("Left Index "    +   leftIndex);
			// IJ.write("Index of max. " +   indexOfMax);

			if(!haveRigthLimit){
				IJ.write("dont have rigth index " );
				rigthIndex = this.getArrayClosestToBegingIndex(leftSideValues,middle, tolerance);

				area +=  trapz(Arrays.copyOfRange(leftSideValues,0, rigthIndex), 180/rigthIndex ); 

				widthInteger += rigthIndex;
			}
			if(!haveLeftLimit){
				IJ.write("dont have left index " );
				leftIndex = this.getArrayClosestToEndIndex(rigthSideValues,middle, tolerance);
				double localWidth = (rigthSideValues.length-leftIndex);
				area +=  trapz(Arrays.copyOfRange(rigthSideValues,leftIndex, rigthSideValues.length), 180/localWidth) ;
				widthInteger += localWidth;

			}

			double widthRatio   =  widthInteger/((double)values.length);

			// IJ.write("Peak width: " +   widthInteger);
			// IJ.write("Peak length: " +  values.length);
			// IJ.write("Width Ratio: " +  widthRatio);
			double[] toReturn   =  {area, widthRatio };
			return toReturn;


		}

		 public int getArrayClosestToBegingIndex(double[] arr,double value,double tolerance) {

		        int k = -1;

		        for(int i=0;i<arr.length;i++){

		            if(Math.abs(arr[i]-value) < tolerance){
		                k=i;
		                break;
		            }
		        }
		    return k;
		}

		public int getArrayClosestToEndIndex(double[] arr,double value,double tolerance) {

		        int k = -1;
		        for(int i=arr.length-1; i>=0 ;i--){

		            if(Math.abs(arr[i]-value) < tolerance ){
		                k=i;
		                break;
		            }
		        }
		    return k;
		}




		double trapz(double[] values,double h ){
			double integral = 0;
			int length = values.length;


			for(int i = 0; i<length-1; i++ ){
				
				integral += h * 0.5*(values[i]+ values[i+1]);

			}



			return integral;

		}	

		void storeOriginalFft(){
			ImagePlus ourImagePlus = this.caller.ourImage;
			ImagePlus fftBackup       = NewImage.createByteImage("Original Fft", ourImagePlus.getWidth(), ourImagePlus.getHeight(),
                                                     1, NewImage.FILL_BLACK);
			ImageProcessor fftBackupProcessor = fftBackup.getProcessor();

			fftBackupProcessor.copyBits(ourImagePlus.getProcessor(),0,0,Blitter.COPY);

			this.caller.fftImage = fftBackup;
		}
		
		void restore_original_fft(){

			ImagePlus ourImagePlus 			 = this.caller.ourImage;
			ImageProcessor ourImageProcessor = ourImagePlus.getProcessor();

			//ImagePlus black = NewImage.createRGBImage("Binarized image", ourImagePlus.getWidth(), ourImagePlus.getHeight(),
            //                                         1, NewImage.FILL_BLACK);


			ourImageProcessor.copyBits(this.caller.fftImage.getProcessor(),0,0,Blitter.COPY);

			//IJ.write("Come on SHOOOWWW");


			ourImagePlus.show();
        	ourImagePlus.updateAndDraw();


		}

		void erode(){
			ImagePlus ourImagePlus           = this.caller.ourImage;
			ImageProcessor ourImageProcessor = ourImagePlus.getProcessor();

			ourImageProcessor.dilate();

			ourImagePlus.show();
        	ourImagePlus.updateAndDraw();


		}

		void dilate(){
			ImagePlus ourImagePlus 			 = this.caller.ourImage;
			ImageProcessor ourImageProcessor = ourImagePlus.getProcessor();

			ourImageProcessor.erode();

			ourImagePlus.show();
        	ourImagePlus.updateAndDraw();

		}

		ImagePlus getFftandRotate(ImagePlus imp, ImageProcessor ip){
			
			//IJ.beep();
			//IJ.showStatus("Done my friend");
			
			FHT fht_transform = new FHT(ip);
			fht_transform.transform();
			IJ.showStatus("Done!!");
			ImageProcessor freq_spectrum = fht_transform.getPowerSpectrum();

			int w = ip.getWidth();
            int h = ip.getHeight();

            ImagePlus fft_image = NewImage.createRGBImage("Fourier Transform image", w, h,
                                                     1, NewImage.FILL_BLACK);
            ImageProcessor fft_image_ip = fft_image.getProcessor();
            


        	fft_image_ip.copyBits(freq_spectrum,0,0,Blitter.COPY);

        	this.convertImageToGray8(fft_image);

        	//IJ.write("MUSTT ROTATEEE");
        	ImageProcessor rotatedFftIP = fft_image_ip.rotateRight();
        	fft_image = new ImagePlus("Rotated FFT",rotatedFftIP);


        	//fft_image.getProcessor().rotateRight();

        	fft_image.show();
        	fft_image.updateAndDraw();

        	

        	return fft_image;


		}

		ImagePlus threshold(ImagePlus image_plus){

			this.convertImageToGray8(image_plus);

			ImageProcessor binarized_ip = image_plus.getProcessor();

			int h = binarized_ip.getHeight();
			int w = binarized_ip.getWidth();

			//ImagePlus binarized = NewImage.createRGBImage("Binarized image", w, h,
            //                                         1, NewImage.FILL_BLACK);
			

			//binarized_ip.copyBits(ip,0,0,Blitter.COPY);


			//this.convertImageToGray8(image_plus);
			

			// int toZero = 0;
			// int toHigh = 0;
			boolean binaryThreshold = this.caller.readCheckBox(BINARY_THRESHOLD);

			 for(int i =0;i<h;i++){
			 	for(int j=0; j<w; j++){

			 		int px = ((binarized_ip.get(j,i) ));
			 		

			 		//IJ.write(px + "");

			 		if(px >this.threshold_value){
			 			if(binaryThreshold)
			 				binarized_ip.set(j,i,255);
			 			//toHigh++;
			 		}else{
			 			binarized_ip.set(j,i,0);
			 			//toZero++;
			 		}

			 		//byte px2 = (byte)(binarized_ip.get(j,i) & 0xff);
			 		//IJ.write(px2 + " despues");

			 	}
			 }

			
			
			// IJ.write(toZero + " to xero");
			// IJ.write(toHigh + " to high");

			image_plus.show();
        	image_plus.updateAndDraw();


        	return image_plus;
		}

		void printTypeOfImage(ImagePlus image){

			int type = image.getType();

			if(type == ImagePlus.GRAY8){
				IJ.write("Gray 8");

			}else if(type == ImagePlus.GRAY16){
				IJ.write("Gray 16");

			}else if(type == ImagePlus.GRAY32){
				IJ.write("Gray 32");

			}else if(type == ImagePlus.COLOR_256){

				IJ.write("Color 256");
			}else if(type == ImagePlus.COLOR_RGB){
				IJ.write("Color RGB");

			}

		}
		
		void convertImageToGray8(ImagePlus img){

			ImageConverter image_converter  = new ImageConverter(img);
			
			image_converter.convertToGray8();

		}

	
	}
}
 //IP_Demo class




