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
% SolveBalanceEquations.m
% SolveBalanceEquations evaluates the model equations returns the simulation time 
% and model solution array.
% ------------------------------------------------------------------------------------- %

function [TSIM,XARR] = SolveBalanceEquations(TSTART,TSTOP,Ts,DF)


	% Setup simulation time scale -
	TSIM = TSTART:Ts:TSTOP;
	number_of_timesteps = length(TSIM);

	% Get ic's from the DF -
	ic_vector = DF.INITIAL_CONDITION_VECTOR;

	% main simulation loop -
	XARR = [];
	XARR = [XARR ic_vector];
	for step_index = 1:number_of_timesteps

		% Get current time -
    	time_current = TSIM(step_index);

    	% Get my current state -
    	xcurrent = XARR(:,step_index);

    	% Update my state -
    	xnew = BalanceEquations(time_current,step_index,xcurrent,Ts,DF);

    	% Correct for negatives -
    	idx_zero = find(xnew<0);
    	xnew(idx_zero) = 0.0;

    	% Archive new state (and then go around again)
    	XARR = [XARR xnew];
	end;

return;