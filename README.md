# immuneTopography

## What is this?
This repository contains scripts to analyze the topography of tumor-infiltrating immune cells in histological images. The image analysis will be done with QuPath v 0.1.2 (qupath.github.io) while all downstream analyses will be done with Matlab R2017b (Mathworks, Natick, MA, USA).

The method is described in our paper "Topography of cancer-associated immune cells" which is being published in eLife 2018. Please cite the paper if you re-use any of the code.

## How do I use this?
This software might not be ready for routine deployment. It is part of an image analysis pipeline that can be used for research projects. Briefly, the full pipeline is as follows

1. Aquire histological slides of tumors and perform immunostaining
2. Scan the slides and load the whole slide images in QuPath
3. Manually draw regions for the tumor core (labeled as "TU_CORE") and the outer invasive margin ("MARG_500_OUT")
4. Run the QuPath scripts provided in "./qupath_scripts"
5. Run the Matlab scripts to parse the QuPath output and perform further analyses. Run the scripts "step_01", "step_02" etc. one after another.

## How do I get help?
Do not hesitate to contact the authors if you have any questions. For questions on QuPath, see http://qupath.github.io. For questions on the Matlab scripts, contact Jakob Kather (jnkath on Twitter).
