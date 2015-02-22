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

#####How do we execute the simulation code?
The model code is executed from the MATLAB command prompt using the EvaluateModelEquations.m script. EvaluateModelEquations takes your feeding profile, solves the 
model equations and calculates the objective function. In the MATLAB workspace, the objective function value is __objective_value__

#####How do we execute the simulation code?
The model code is executed using Main.py. Main.py will execute the simulation specified in a simulation file, using parameters specified in a parameter file. 
