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
% BalanceEquations.m
% Encodes the discretized balance equations
% ------------------------------------------------------------------------------------- %

function [xnew] = BalanceEquations(t,step_index,xold,Ts,DF)

	% Allocate new state vector -
	number_of_states = length(xold);
	xnew = zeros(number_of_states,1);

	% Get parameters from DF -
	YXS1 = DF.YIELD_CELLMASS_SUBSTRATE_1_TRUE;
	YXS2 = DF.YIELD_CELLMASS_SUBSTRATE_2_TRUE;

	YP1 = DF.YIELD_PRODUCT_1_TRUE;
	YP2 = DF.YIELD_PRODUCT_2_TRUE;

	mugmax = DF.MAXIMUM_SPECIFIC_GROWTH_RATE;
	KGS1 = DF.SATURATION_CONSTANT_GROWTH_SUBSTRATE_1;
	KGS2 = DF.SATURATION_CONSTANT_GROWTH_SUBSTRATE_2;

	kd_lactate = DF.DEATH_RATE_CONSTANT_LACTATE;
	kd_amm = DF.DEATH_RATE_CONSTANT_AMM;
	kd_max = DF.DEATH_RATE_CONSTANT_MAX;
	kd_gln = DF.DEATH_RATE_CONSTANT_GLN;
	ms = DF.MCOEFFICIENT;
	km_glc = DF.MCOEFFICIENT_GLC;
	
	SIN1 = DF.FEED_CONCENTRATION_SUBSTRATE_1;
	SIN2 = DF.FEED_CONCENTRATION_SUBSTRATE_2;

	alpha_constant = DF.ALPHA_CONSTANT;
	beta_constant = DF.BETA_CONSTANT;
	kmu = DF.KMU;

	feed_profile_vector = DF.FEED_PROFILE;
	
	% Alias the species vector -
	idx_zero = find(xold<0);
	xold(idx_zero) = 0.0;
	S1 = xold(1);
	S2 = xold(2);
	P1 = xold(3);
	P2 = xold(4);
	P3 = xold(5);
	X = xold(6);
	V = xold(7);

	% Compute the growth rate -
	mu = mugmax*(S1/(KGS1 + S1))*(S2/(KGS2 + S2));
	kd = kd_max/(mugmax - kd_lactate*P1)*(1/(mugmax - kd_amm*P2))*(kd_gln)/(kd_gln + S2);
	qGlc = mu/YXS1 + ms*(S1/km_glc + S1);
	qGln = mu/YXS2;
	qLac = YP1*qGlc;
	qAmm = YP2*qGln;
	qMab = (alpha_constant/(kmu + mu))*mu + beta_constant;

	% Compute the dilution rate -
	FIN = feed_profile_vector(step_index);
	D = FIN/V;

	% Compute the balances (in the order of x)
	F(1,1) = D*(SIN1) - qGlc*X;		% 1 S1 (glucose)
	F(2,1) = D*(SIN2) - qGln*X;		% 2 S2 (glutamine)
	F(3,1) = qLac*X;				% 3 P1 (lactate)
	F(4,1) = qAmm*X;				% 4 P2 (ammonia)
	F(5,1) = qMab*X;				% 5 P3 (mab)
	F(6,1) = (mu - kd)*X;			% 6	X (cellmass)
	F(7,1) = 0;						% 7 V (volume)

	% Compute the new state -
	DHAT = eye(number_of_states,number_of_states);
	DHAT(1,1) = -1*D*Ts;
	DHAT(2,2) = -1*D*Ts;
	DHAT(3,3) = -1*D*Ts;
	DHAT(4,4) = -1*D*Ts;
	DHAT(5,5) = -1*D*Ts;
	DHAT(6,6) = -1*D*Ts;
	DHAT(7,7) = D*Ts;
	AHAT = eye(number_of_states,number_of_states)+DHAT;

	% Calculate new state -
	xnew = AHAT*xold + Ts*F;
return;