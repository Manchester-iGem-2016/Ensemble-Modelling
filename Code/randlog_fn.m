function [ ReturnParameters ] = randlog_fn(BinNumber, Iterations, Parameters)
%--------------------------------------------------------------------------
%Generate lognormal probabilty density function (PDF) for the parameters  
%then randomly sample from it to return a set of values for that parameter.  
%                                                                         
%---------------------------------Inputs-----------------------------------
%BinNumber = Number of sections to split the PDF into when sampling. The
%            The higher this value the more distint outputs are possible.
%Iterations = Number of randomly sampled parameters to return in the
%             output.
%K = Raw, discreet, parameter values to generate the PDF from. In the form
%    of a vector containing a list of values
%
%---------------------------------Outputs----------------------------------
%ReturnParmaters = Returns a vector containing randomly sampled
%                       parameter values.
%------------------------------Dependancies--------------------------------
%No dependancies
%
%--------------Written by Matthew Davies & Toby Summerill------------------
%-----------------University of Manchester iGEM 2016-----------------------
%--------------------------------------------------------------------------

%Error checking on inputs
%An error will be thrown and the code will stop running if:
%       K only contains a single unique value
%       K contains negative values
%       BinNumber or Iterations is negative or zero 
if length(unique(Parameters)) <= 1                   
    error('RandLog_fn: Input, K, must contain at least 2 unique values.'); 
end
if min(Parameters) < 0
    error('RandLog_fn: Input, K, contains negative values');
end
if BinNumber <= 0                           
    error('RandLog_fn: BinNumber cannot be zero or negative');
end
if Iterations <= 0                          
    error('RandLog_fn: Iterations cannot be zero or negative');
end

%Initialise the PDF parameters
U = mean(log(Parameters));                   %Log mean of the input data       
O = std(log(Parameters));                    %Log standard deviation of the input data
xmax = 1.2*max(Parameters);                  %Set the range to generate PDF across
binsize = xmax/BinNumber;           %Set the size of each 'bin' in the PDF
%Generate the PDF
x = binsize:binsize:xmax + binsize;                                    %Generate x values
y = (1./(x.*O.*((2.*pi()).^0.5))).*exp((-(log(x)-U).^2)./(2.*(O.^2))); %Generate y values

%Convert probability density to cumulative probabilty density
yi = cumtrapz(y);           %Intergrate over curve range
yi = yi./max(yi);           %Scale all values so maximum value is 1

%Define the bin areas
bin_areas = zeros(1,(ceil((max(x))/binsize)));  %Initialise vector
for i = 1:BinNumber
    bin_areas(i) = yi(i+1) - yi(i);             %Set the bin areas     
end

%Randomly sample from PDF until enough samples have been generated
%Randomly sample from PDF until enough samples have been generated
istorevector  = zeros(1,Iterations);            
for j = 1:Iterations                            
    r = rand();                                 
    semisum = bin_areas(1);
    for i = 1:BinNumber                          
        if semisum > r                              
            istore = i;                         
            break
        else
            semisum = semisum + bin_areas(i);   
        end
    end
    istorevector(j) = istore;  
end

ReturnParameters  = istorevector .* binsize  + (binsize.*rand());

%Plotting for the wiki
plot(x,yi);
xlabel('Parameter value')
ylabel('Cumulative probability')
hold on

xindex = randi(length(yi));    
yplot = linspace(0, yi(xindex));
xplot(1:length(yplot)) = x(xindex);
plot(xplot,yplot, 'r');
hold on

xplot2 = linspace(0,x(xindex));
yplot2(1:length(xplot2)) = yi(xindex);
plot(xplot2,yplot2, 'r');

disp('done')



