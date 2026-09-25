# roi-xml-converter
Convert Horos ROI XML files into NIFTI using MATLAB

This tool was created by Matthew Cherukara, D.Phil., at the Department of Medical Physics and Biomedical Engineering, University College London, UK, with supervision by Prof. Karin Shmueli.

The MATLAB functions provided can be used to load an XML file containing ROI outputs from the Horos Project's [Export ROIs plugin](https://horosproject.org/horos-content/plugins/horos/ExportROIs/html/).

## Usage

- **readrois_xml.m** takes a Horos ROI XML file and converts the values into a MATLAB structure. Requires **parseXML.m**. 
- **create_roimask.m** takes the output structure from **readrois_xml.m** (and a \[3x1\] **mask_size**) and creates a 3D array (of size **mask_size**) which is a binary mask of voxels inside the ROI. This script includes a flip of the coordinates in the AP direction, based on how Horos and NIFTI files define their directions 
- **parseXML.m** is used to convert an XML file into a MATLAB structure. It is taken from an example on the [MathWorks website](https://uk.mathworks.com/help/matlab/ref/xmlread.html).

## Format

The output structure from **readrois_xml.m** is a vector structure, with one element per slice in the original ROI. The fields correspond to the XML attributes in the Horos ROI ouput:
- **DataSummary:** A structure containing summarized radiomic measures from the ROI (in that slice): area, dev, length, mean, min and max, total (sum)
- **DataValues:** A vector of image intensities inside the ROI, based on the original image on which the ROI was drawn
- **Name:** A string of the original ROI name, as saved by Horos
- **ROIPoints:** A (Nx2) vector of the ROI's vertices within the slice
- **Slice:** A scalar int representing the slice number

## ToDo

- The **parseXML** step is quite slow and creates an unnecessary number of nested structures. There is probably a way to speed this up by rewriting this function for the specific format of Horos ROI XMLs, rather than generic XML files
- There is currently no error checking, and **readrois_xml** uses the *eval* function to convert a string into a vector, which is not ideal