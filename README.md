# Ribosomal Protein Analysis
Hamilton, R.S.<sup>1,2</sup>

<sup>1</sup> Centre for Trophoblast Research,
<sup>2</sup> Department of Physiology, Development, & Neuroscience, University of Cambridge, Downing Site, Cambridge, CB2 3DY,


## Citation ##
Hamilton, R.S. (2019) DOI

## Abstract ##

To be added

<center><img src="Images/ribosome_intro.jpg" width="500"></center>

## Downloading and pre-processing ribosome structure CIF and annotation files ##

#### Ribosome 3D Coordinates (CIF) ####

Download the human 80s ribosome structure from [RCSB: 6EK0.cif](https://files.rcsb.org/download/6EK0.cif)

#### Structure Chain to Ribosomal Protein Naming Conversion  ####

This is a horrible hack at the moment, but the easiest way to like the structure file chain naming to the ribosomal protein naming conventions. Start by saving the html source as txt.

    cat 6EK0.source.copy.txt | grep -v "^Protein" | grep -v "^Full" | \
    grep -v "^Molecule" | grep -v "^Find" | grep -v "Mutations" | \
    sed 's/Entity ID: //g' | sed 's/Gene Names: //g' > 6EK0.source.copy.ed.txt

<b>To Do:</b>

Create a permanent look up table linking the CIF to official ribosomal protein names


## Calculating Ribosomal Protein Surface Scores ##

    perl RibosomeStructure.pl 6ek0.cif 6EK0.source.copy.ed.csv

Output

    40s: Cn   Dist Description
    40s: SG 113.84 S6; RPS6
    40s: SI 107.44 S8; RPS8
    40s: SM 100.57 S12; RPS12

<b>To Do:</b>

* Add cut off for output e.g. score of 100
* Use permanent look up table in output


## Visualisation using Pymol ##

#### Set up Pymol ####
    viewport 1000,1000
    set ignore_case, off

#### Desired script output ####

    colour red, chain LR #Rpl19
    ...
    colour red, chain S12 #Rps12



## Create MPG movies from Pymol PNG ##

#### Pymol Movie Creation ####

    Movie: Program: Camera Loop: Y-Roll: 16 seconds

#### Pymol Save Movie as PNGs ####

    File: Save Movie as: PNG

#### Convert Pymol Movie PNGs to MPG using [ImageMagick](https://www.imagemagick.org/script/index.php) ####


 ````
 convert -delay 6 -quality 99 <filename>_*.png <filename>_movie.mpg
 ````

## References ##



### Links ###

Description   | URL
------------- | ----------
Publications  | [bioRxiv](http://), [Journal](http://) and [DOI](http://) <br>(<i>To be updated on publication</i>)

## Contact ##

Contact rsh46 -at- cam.ac.uk
