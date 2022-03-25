// SETTINGS
run("Bio-Formats Macro Extensions");
run("Set Measurements...", "area mean min shape kurtosis redirect=None decimal=3");
run("3D Manager Options", "volume compactness exclude_objects_on_edges_xy distance_between_centers=10 distance_max_contact=1.80 drawing=Contour");
print("+++++++++++++++++++++++++++++++++++++++++++");
run("Close All");

// LOAD DATA
myfile = File.openDialog("Select .LIF file");
myname = File.getName(myfile);
mypath = File.getParent(myfile) + File.separator;
print("File: "+myname);
print("Path: "+mypath);

Ext.setId(mypath + myname);
Ext.getSeriesCount(sercount);
print("Count: "+sercount);

//open or create the .xlsx file we want to add data to
resultsfile= mypath + myname + "_3Dmorphometry.xlsx";
run("Read and Write Excel", "file="+resultsfile+" file_mode=read_and_open");
	
//for (n = 1; n < sercount+1; n++) { //to run the code	
for (n = 2; n < 6; n++) {	 //to test new code
	run("Close All");
	if (isOpen("ROI Manager")) {selectWindow("ROI Manager"); run("Close"); }
	print("**********************************");
	Ext.setSeries(n-1);
	print("Image number: "+n); // The image name will also be printed in the Log window for verification
	Ext.getSeriesName(sername)
	print("Image name: "+sername);
	
	run("Bio-Formats Importer", "open=[" + mypath + myname +"] color_mode=Colorized view=Hyperstack stack_order=Default use_virtual_stack series_"+n);
	run("Enhance Contrast", "saturated=0");
	rename("RawImageData");
	setSlice(138);
	waitForUser("Coose a ROI and continue with OK (Ctrl+A for entire image)");
	roiManager("Add");
	run("Split Channels"); //run("Tile");
	
// 3D SEGMENTATION & ANALYSIS
	selectWindow("C4-RawImageData");
	roiManager("Select", 0);
	run("Duplicate...", "duplicate");
	selectWindow("C4-RawImageData-1");
	//selectWindow("C4-RawImageData-1");
	run("Gaussian Blur 3D...", "x=1 y=1 z=1");
	setAutoThreshold("Otsu dark stack");
	run("Convert to Mask", "method=Otsu background=Dark");
	run("3D Simple Segmentation", "low_threshold=128 min_size=3000 max_size=-1");
	// ANALYZE CHLOROPLAST SPHERICITY	
	selectWindow("Seg");
	rename("Seg_Chl "+n);
	run("3D Compactness");
	run("Read and Write Excel", "no_count_column file="+resultsfile+" sheet=Chl_Sphericity dataset_label=Chl_Sphericity stack_results file_mode=queue_write"); 
	if (isOpen("Results")) {selectWindow("Results"); run("Close"); }
	
	
if (1) {
	// ANALYZE CHLOROPLAST VOLUME
	selectWindow("Seg_Chl "+n);
	run("3D Volume");
	run("Read and Write Excel", "no_count_column file="+resultsfile+" sheet=Chl_Volume dataset_label=Chl_Volume stack_results file_mode=queue_write"); 
	if (isOpen("Results")) {selectWindow("Results"); run("Close"); }

	// ANALYZE NUCLEI VOLUME
	selectWindow("C3-RawImageData");
	run("Cyan");
	roiManager("Select", 0);
	run("Duplicate...", "duplicate");
	run("Gaussian Blur 3D...", "x=1 y=1 z=1");
	setAutoThreshold("Otsu dark stack");
	run("Convert to Mask", "method=Otsu background=Dark");
	run("Fill Holes", "stack");
	run("Erode", "stack");	run("Erode", "stack");	run("Dilate", "stack");	run("Dilate", "stack");	// this removes very small objects
	run("3D Simple Segmentation", "low_threshold=1 min_size=3000 max_size=-1"); // min size limit where nucleus is no longer discernible from bacteria 
		//run("Z Project...", "projection=[Max Intensity]"); // for control/debug only
	rename("Seg_Nuc "+n);
	wait(10);
	run("3D Volume");
	run("Read and Write Excel", "no_count_column file="+resultsfile+" sheet=Nuclei_Volume dataset_label=Nuclei_Volume stack_results file_mode=queue_write"); 
	if (isOpen("Results")) {selectWindow("Results"); run("Close"); }
}
}

// EXPORT RESULTS
// write the queued results data to the file
run("Read and Write Excel", "file_mode=write_and_close");
