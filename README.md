#### Fedbatch bioreactor code for MAb production

____________________________________________________
#####author: jdv27@cornell.edu (Jeffrey Varner)
#####location: [Varnerlab](http://www.varnerlab.org), Cornell University
#####version: 1.0
____________________________________________________

#####How do we download the model code and get it into MATLAB?
Click the download ZIP button on the lower right hand of this page. A zip archive containing the model code will automatically download to your computer.
Unzip the zip the archive in a directory that is on your MATLAB path. Alternatively, set your MATLAB path to include
the model files from the archive. [What the what? How do I set my path in MATLAB?](http://www.mathworks.com/help/matlab/ref/path.html)

#####I don't have MATLAB. Where can I get it or do I need to buy it?
You don't have to buy MATLAB. MATLAB is installed in the computer labs on campus (including Olin library). 
A listing of the computer labs and their respective software can be found [here](http://mapping.cit.cornell.edu/publiclabs/map/)

#####How do we execute the simulation code and what gets returned?
The model code is executed from the MATLAB command prompt using the __EvaluateModelEquations.m__ script. EvaluateModelEquations takes your feeding profile, solves the 
model equations and calculates the objective function. In the MATLAB workspace, the objective function value is held in the variable __objective_value__.
The solution of the model equations also gets returned to the MATLAB workspace. The simulation time vector is held in the variable __TSIM__. __TSIM__ is a 1 x T
vector, where T is the number of time steps. The model concentrations are held in the variable __XARR__. __XARR__ is a 7 x T array, where the rows are 
different model species and the columns are time values. The model species are in the order:

- Nutrient S1 (glucose)
- Nutrient S2 (glutamine)
- Product P1 (lactate, waste product)
- Product P2 (ammonia, waste product)
- Product P3 (MAb, valuable product)
- X (cellmass)
- 7 V (volume)

#####How do we set the feeding profile?
The feeding profile is a N x 2 array. The number of rows N = the number of time windows your want to consider. 
Column 1 holds the time and column 2 holds the volumetric flow rate value. You set these values starting at __L33__ of the __EvaluateModelEquations.m__ script.
Alternatively, you can create a feeding array in a program such as EXCEL, export it and load into the simulation. The external array must still be N x 2.
[Really? How do I load a data array into MATLAB?](http://www.mathworks.com/help/matlab/ref/importdata.html).
