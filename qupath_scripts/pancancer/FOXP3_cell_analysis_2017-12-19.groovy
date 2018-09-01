// JN Kather, M Horning, NCT Heidelberg 2017-12-19
// first, draw an annotation for each image. Then, run this script

myImageType = 'FOXP3val' // define image type
loArea = '10'	   // minimum area; this and the next variables vary between staining types
hiArea = '100'	   // maximum area 
inThre = '0.08'    // cell detection intensity threshold
threOn = '0.33'	   // positive cell detection threshold

print('STARTING ' + myImageType + ' COUNT SCRIPT, JN Kather')

// count cells in all annotation regions
selectAnnotations()
setImageType('BRIGHTFIELD_H_DAB')
setColorDeconvolutionStains('{"Name" : "H-DAB default", "Stain 1" : "Hematoxylin", "Values 1" : "0.65111 0.70119 0.29049 ", "Stain 2" : "DAB", "Values 2" : "0.26917 0.56824 0.77759 ", "Background" : " 255 255 255 "}');
runPlugin('qupath.imagej.detect.nuclei.PositiveCellDetection', '{"detectionImageBrightfield": "Optical density sum",  "requestedPixelSizeMicrons": 0.5,  "backgroundRadiusMicrons": 8.0,  "medianRadiusMicrons": 0.0,  "sigmaMicrons": 1.0,  "minAreaMicrons": ' + loArea + ',  "maxAreaMicrons": ' + hiArea + ',  "threshold": ' + inThre + ',  "maxBackground": 2.0,  "watershedPostProcess": true,  "excludeDAB": false,  "cellExpansionMicrons": 3.0,  "includeNuclei": true,  "smoothBoundaries": true,  "makeMeasurements": true,  "thresholdCompartment": "Nucleus: DAB OD mean",  "thresholdPositive1": ' + threOn + ',  "thresholdPositive2": 0.4,  "thresholdPositive3": 0.6,  "singleThreshold": true}');

// print output to log
detections = getDetectionObjects()
print('There are ' + detections.size() + ' detections')
annotations = getAnnotationObjects()
print('There are ' + annotations.size() + ' annotations')

// save results TO
outputFolder = './results_pancancer/'

saveAnnotationMeasurements(outputFolder + getProjectEntry().getImageName() + '_' + myImageType + '_RESULT.txt')
