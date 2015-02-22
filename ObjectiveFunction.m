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
% ObjectiveFunction.m
% ObjectiveFunction evaluates the model equations with a given feeding profile and
% calculate the value of the objective function, simulation time and model solution
% array.
% ------------------------------------------------------------------------------------- %

function [obj_value,TSIM,XARR] = ObjectiveFunction(TSTART,TSTOP,Ts,DF)

	% Solve the balances -
	[TSIM,XARR] = SolveBalanceEquations(TSTART,TSTOP,Ts,DF);

	% Compute the objective function -
	FARR = DF.FEED_PROFILE;
	number_of_timesteps = length(TSIM);
	PARR = [];
    for step_index = 1:number_of_timesteps

    	volume = XARR(7,step_index);
    	product = XARR(5,step_index);
    	dilution_rate = FARR(step_index)/volume;	
    	PARR(step_index,1) = dilution_rate*product;
    end

	% Integrate the productivty -
	iprod = trapz(PARR);
	final_product = XARR(5,end);

	% Compute the objective value -
	obj_value = final_product+iprod;
return