function [ParameterFinal] = Weighting_Fn(Parameter, Error, Weighting)
%--------------------------------------------------------------------------
%Generates a weighted, discreet set of parameter values from an input of
%parameters from other sources.
%
%---------------------------------Inputs-----------------------------------
%Parameter  = List of parameters's to be weighted. In the form of a vector
%             with N values.
%Error      = Error in the parameters to be weighted (can be all zeros). In
%             the form of a vector with N values, mapping to the
%             corresponding position in Parameter.
%Weighting  = Weighting matrix. Each column is a different conditional test.
%             In the form of an NxM matrix where N maps to the position in
%             Paramater and each value of M is the predefined result of a
%             conditional test.
%
%---------------------------------Outputs----------------------------------
%ParameterFinal = Vector containing a weighted list of parameters based on the
%                 intial input parameters. Weighting is accounted for via
%                 duplication of more relevant points.
%
%------------------------------Dependancies--------------------------------
%No dependancies on other functions.
%
%--------------Written by Matthew Davies & Toby Summerill------------------
%-----------------University of Manchester iGEM 2016-----------------------
%--------------------------------------------------------------------------

%Error checking on inputs
%An error will be thrown and the code will stop running if:
%       K contains no values
%       K, Error or Weighting do not have the same dimension
if isempty(Parameter) == 1
    error('Weighting_Fn: parameter to be weighted must contain values');
end
if length(Weighting) ~= length(Parameter) || length(Error) ~= length(Parameter)
    error('Weighting_Fn: The error vector and Weighting matrix need to be the same size as the parameter vector');
end

%Add extreme error values as additional samples.
Kplus = Parameter + Error;
Kminus = Parameter - Error;

%Find the total weighting
Wtotal = prod(Weighting);

%Merge the K, Kplus and Kminus and attach the weightings.
Parameter = [cat(1 , Parameter, Wtotal), cat(1, Kplus, Wtotal), cat(1, Kminus, Wtotal)];

%Remove physical impossiblites.
%May vary depending on the system being modelled!
Parameter(1,(Parameter(1,:) < 0)) = 0;          %Remove any negative K's and set them to 0

Knew = [];
for i = 1:length(Parameter)
    for j = 1:Parameter(2,i)
        Knew = [Knew, Parameter(1,i)];
    end
end

%Removes top and bottom 2.5% of data points to set 95% confidence interval
Confidence = 0.05;
n = ceil(length(Knew)*Confidence/2);
ParameterFinal = Knew(n:length(Knew)-n);
end

