% ------------------------------------------------------------------------------------- %
% Copyright (c) 2015 Varnerlab, 
% School of Chemical and Biomolecular Engineering, 
% Cornell University, Ithaca NY 14853 USA.
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is 
% furnished to do so, subject to the following conditions:
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%
% EvaluateModelEquations.m
% Solution script to solve the fed-batch model equations for mab production
% ------------------------------------------------------------------------------------- %

% SET YOUR FEEDING PROFILE HERE ------------------------------------------------------- %

% Feeding profile should be a N x 2 array. First column is time (AU), and the second 
% column is FIN values (L/AU). The simulation runs from 0 to 10 AU time units. You need
% values in the feed profile up to 10 UA time.

feeding_profile = [
	
	0 0.0  ;
	1 0.0  ;
	2 0.1  ;
	3 0.8  ;
	4 1.6  ;
	5 0.2  ;
	6 0.1  ;
	7 10.0  ;
	8 0.1  ;
	9 0.0  ;
	10 0.0 ;
];


% ------------------------------------------------------------------------------------- %


% DO NOT EDIT BELOW THIS LINE --------------------------------------------------------- %

% Setup the biological parameters
DF.YIELD_CELLMASS_SUBSTRATE_1_TRUE = 1.09;
DF.YIELD_CELLMASS_SUBSTRATE_2_TRUE = 3.8;
DF.YIELD_PRODUCT_1_TRUE = 1.8;
DF.YIELD_PRODUCT_2_TRUE = 0.85;
DF.MAXIMUM_SPECIFIC_GROWTH_RATE = 1.09;
DF.SATURATION_CONSTANT_GROWTH_SUBSTRATE_1 = 1.0;
DF.SATURATION_CONSTANT_GROWTH_SUBSTRATE_2 = 0.3;
DF.DEATH_RATE_CONSTANT_LACTATE = 0.01;
DF.DEATH_RATE_CONSTANT_AMM = 0.06;
DF.DEATH_RATE_CONSTANT_MAX = 0.69;
DF.DEATH_RATE_CONSTANT_GLN = 0.02;
DF.MCOEFFICIENT = 0.17;
DF.MCOEFFICIENT_GLC = 19.0;	
DF.FEED_CONCENTRATION_SUBSTRATE_1 = 25.0;
DF.FEED_CONCENTRATION_SUBSTRATE_2 = 4.0;
DF.ALPHA_CONSTANT = 2.57;
DF.BETA_CONSTANT = 0.35;
DF.KMU = 0.02;

% Constants -
DF.MAXIMUM_VOLUME_CONSTRAINT = 100.0;

ic_vector = [
	
	25.0 ;	% 1 S1
	4.0  ;	% 2 S2
	0.0  ;	% 3 P1
	0.0  ;	% 4 P2
	0.0  ;	% 5 P3
	2.0  ;  % 6 X
	0.8  ;  % 7 V 	
];

DF.INITIAL_CONDITION_VECTOR = ic_vector;

% Setup simulation time scale -
TSTART = 0.0;
TSTOP = 10;
Ts = 0.1;
TSIM = TSTART:Ts:TSTOP;

% Discretize the feeding profile -

% Implement max flow constaint -
MAX_FEEDING_VALUE = 5.0;
idx_large = find(feeding_profile(:,2)>MAX_FEEDING_VALUE);
feeding_profile(idx_large,2) = MAX_FEEDING_VALUE;

% Implement max change flow constant - 
MAX_DIFF = 0.5;
diff_fin = diff(feeding_profile(:,2));
idx_large_differences = find(abs(diff_fin)>MAX_DIFF);
number_of_large_differences = length(idx_large_differences);
FIN_FIXED = feeding_profile(:,2);
for difference_index = 1:number_of_large_differences
		
	% what difference are we looking at?
	local_difference_index = idx_large_differences(difference_index);
	diff_fin_value = diff_fin(local_difference_index);

	if (diff_fin_value>0)
			
		feeding_profile(local_difference_index+1,2) = MAX_DIFF + feeding_profile(local_difference_index,2);

	else

		feeding_profile(local_difference_index+1,2) = abs(feeding_profile(local_difference_index,2) - MAX_DIFF);
	end
end;

% Discretize onto the simulation time scale -
FIN = interp1(feeding_profile(:,1),feeding_profile(:,2),TSIM,'nearest');
DF.FEED_PROFILE = FIN;

% Solve the equations, and calculate the objective function value
[objective_value,TSIM,XARR] = ObjectiveFunction(TSTART,TSTOP,Ts,DF);