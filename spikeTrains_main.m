s is a tutorial for generating Poisson spike trains.
% Original tutorial: David Heeger (for Cold Spring Harbor Lab summer school).
% Modified by: Odelia Schwartz.
% Read the comments and copy each line of code into matlab.
% In Matlab's editor, to run one block of code (starting with %%)
% you can use the Run and Advance button.
% Type 'help <function_name>' in Matlab window for any
% function you would like more information on.
% Type 'which <function_name>' in Matlab window for the
% location of a file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generating Samples of a Poisson Process.

% Spike trains in neurons are often modeled as a Poisson random 
% process.
%
% One of the easiest ways to generate a Poisson spike
% train is to rely on the approximation that in any small
% time interval the probability of a spike is proportional
% to the mean spike count (firing rate) times the time step:
%
%    Prob{1 spike during (t,t+deltaT)} = r(t) deltaT
%
% where r(t) is the firing rate and deltaT is 
% the time step.  This approximation is only valid when deltaT is
% very short so that there is essentially no chance of there
% being more than one spike per time interval.

%% (1)
% Let's begin by choosing a time step and by choosing an average
% firing rate.
% After running this, try and also choose different firing rates.

deltaT=1e-3 			% Time step: 1e-3 secs = 1 msec
rate=10			    	% Firing rate: spikes/sec
duration=1			% 1 sec simulation

%% Choose the time intervals
times=[0:deltaT:duration]
size(times)

%% We can generate one random number between 0 and 1
% Try this many times
xr_one = rand

%% Let's check if the mean firing rate times the time interval 
% is greater than the random number
% Again, we can repeat choosing a random number and checking
% many times
intervalRate = (rate*deltaT)
xr_one
intervalRate > xr_one 

%% We want to do this process not just for one interval,
% but for all the time intervals over the duration
% We'll choose a bunch of random numbers, one for each time step,
% uniformly distributed between 0 and 1.
xr=rand(size(times))

%% Check that values are reasonably random by plotting a histogram
figure(1);
hist(xr,20);
set(gca, 'fontsize', 18);
xlabel('random draws')
ylabel('Probability')

%% Now, insert a spike whenever the probability of firing
% (rate*deltaT) is greater than the corresponding random number:
% Matlab allows you to do this operation in one line, without a 
% for loop. 

neuralResponse = intervalRate > xr
figure(2); 
% We'll plot the neural responses (spikes) using the stem command
% which is a lollipop plot...
stem(times,neuralResponse);    
set(gca, 'fontsize', 18);
xlabel('Time')
ylabel('Neural Response (Spikes)')

%% To get a better understanding of what this does, we
% can look at the values for a vector of length 5
% Try changing the vector to get more spikes
tmpxr = [.001 .1 .2 .5 .06]
intervalRate
tmpResponse = intervalRate > tmpxr

%% Calculate the spike count, which are the number of spikes during the time duration
spikeCount=sum(neuralResponse)

%% (2) Repeat this 1000 times and save the spikeCounts each time
len = 1000;
spikeCounts = zeros(len,1);;
for i=1:len
   xr=rand(size(times));
   % insert a spike whenever the probability of firing
   % (rate*deltaT) is greater than the corresponding random number:
   neuralResponse = intervalRate > xr;
   spikeCount=sum(neuralResponse)
   spikeCounts(i)= spikeCount;
end 

%% What is the mean of the spikeCounts? How does it
% compare to the firing rate?

mean(spikeCounts)
rate


%% Plot a spike count histogram
figure(3);
x=[0:30];
hist(spikeCounts,x)
xlabel('Spike count')
ylabel('Probability')

%% Plot a normalized histogram (that sums to 1)
%  for comparison with the Poisson
spikeCountHist=hist(spikeCounts,x)/len;
y=mypoisspdf(x,mean(spikeCounts));
bar(x,spikeCountHist)
axis([min(x) max(x) 0 0.25])
xlabel('Spike count')
ylabel('Probability')
hold on
plot(x,y)
hold off

%% Here are some things for you to do in class for the code above:
%
% - Try repeating the above code by choosing a lower firing rate 
%   (3) or a higher rate (15) by changing the variable rate at the top.
%   Plot the resulting distributions. How does the mean change?
%   Also plot examples of the spike trains in the repeated runs.
%
% - Try changing the number of repeats from 1000, to 50, 10, and 10000. 
%   Plot the resulting distributions. How good is the fit to Poisson?

