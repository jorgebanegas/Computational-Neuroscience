
x1 
%
% Odelia Schwartz
% Partly based on Cold Spring Harbor tutorial by Chichilnisky.
% This is a tutorial for understanding linear filter
% properties of neurons, and generating neural spikes
% based on a linear filter followed by a simple nonlinearity.
% This is part one of two tutorials. We are going to first show
% how to generate neural model responses, which we will
% later probe and "guess"/figure out the properties.
%
% The model neuron includes one linear and one nonlinear component.
% followed by generating a Poisson spike train. We have made several 
% versions of model neurons.
%
% ----------------------------------------------------------------------

%% clear all variables and close all figures
clear all; close all;

%% We want to first choose experimental stimuli that are random.
% At each frame, the intensity of the uniform screen changes:
% it is drawn randomly, here from a Gaussian distribution.
numsamples = 25000
stimulus=(1/3*randn(numsamples,1))

%% Plot the stimulus
figure(1);
plot(stimulus(1:1000))
set(gca, 'fontsize', 14);
xlabel('Time (msec)')
ylabel('Stimulus strength')
title('First 1 second of stimulus');

%% We're now going to simulate a model neuron
% For purposes of this demo, we constructed some model
% neurons. The function getLinear1 computes the linear
% response of our model neuron. (This is a function we 
% constructed and so know the answer; in a usual
% experiment with real neurons one would not know this!)

% We've made several versions of model neurons.
% Toggle between
filterLen = 100;
[linearResp, filter] = getLinear1(stimulus, filterLen);
%[linearResp, filter] = getLinear2(stimulus, filterLen);
%[linearResp, filter] = getLinear3(stimulus, filterLen);

%% The linear response smooths (averages) the stimulus
% over time.  The top panel of the figure shows 
% the first second of the stimulus, the small middle 
% panel shows the linear filter (which we usually would
% not know), and the third panel shows the first second 
% of the linear response.
figure(2);
subplot(2,1,1);
plot(stimulus(1:1000))
set(gca, 'fontsize', 14);
title('Stimulus');
set(gca,'XTIck',[])
subplot(2,1,2);
plot(linearResp(1:1000))
set(gca, 'fontsize', 14);
title('Linear response');
xlabel('Time (ms)');
axes('position',[.13 .47 .2 .1])
plot(filter,'m-')
axis([0 length(filter) 1.1*min(filter) 1.1*max(filter)]);
set(gca,'XTick',[],'YTick',[],'Box','on','Units','Normalized')

%% We would like to unpack this and see what the linear
% filter is doing
% Choose a random starting point, and examine the stimulus
% starting from the random position and with a length equal
% to the filter length. We'll plot both this stimulus sequence
% and the filter. 
thestart = round(rand*100+1);
thelen = length(filter)
thestim = stimulus(thestart:thelen+thestart-1)
subplot(3,1,1); plot(thestim); 
set(gca, 'fontsize', 14); title('stimulus')
subplot(3,1,2); plot(filter); 
set(gca, 'fontsize', 14); title('filter')

%% Plot the point by point multiplication of the filter
% with the stimulus
subplot(3,1,3); plot(filter.*thestim); 
set(gca, 'fontsize', 14); title('stimulus times filter');

%% The linear filter response to the stimulus, is the sum
% of this point by point multiplication. This results in a
% single number. This is also known as inner product or dot product.
sum(filter.*thestim)
linearResp(thelen+thestart-1)

%% What if the input was exactly the linear filter
% or variant of (toggle these)
thestim = filter;
% thestim = -filter;
% thestim = flipud(filter);
subplot(3,1,1); plot(thestim); 
set(gca, 'fontsize', 14); title('stimulus')
subplot(3,1,2); plot(filter); 
set(gca, 'fontsize', 14); title('filter')
subplot(3,1,3); plot(filter.*thestim); 
set(gca, 'fontsize', 14); title('stimulus times filter');
sum(filter.*thestim)

%% Under a simple non-linear model, the firing rate of a neuron is
% a single-valued non-linear function of an underlying linear response.
% We can pick any such function we want -- this is done in getNonlinear.
% Here we're applying this non-linear transformation on the linear response of
% our simulated neuron. 
nonlinearResp = getNonlinear1(linearResp);
% Toggle between
%nonlinearResp = getNonlinear2(linearResp);

%% We can plot together the linear and nonlinear response
h = figure(3); clf;
h = subplot(3,1,1);
plot(linearResp(1:1000),'b-')
title('Linear response')
set(h,'XTick',[],'XTickLabel',[])
h = subplot(3,1,2);
plot(nonlinearResp(1:1000),'r-')
title('Nonlinear function of linear response')
set(h,'XTick',[],'XTickLabel',[])

%% To understand this better, we try just few values
% Try changing theval: Is there a pattern?
theval = 220
linearResp(theval)
nonlinearResp(theval)

%% Plot nonlinear function in the interval [-.3:.05:.3]
% Toggle between
modelNonlin = getNonlinear1([-.3:.05:.3]);
%modelNonlin = getNonlinear2([-.3:.05:.3]);
figure(4); clf;
plot([-.3:.05:.3], modelNonlin);
set(gca, 'fontsize', 14);
xlabel('Linear response'); ylabel('Nonlinear response');

%% We can use this non-linear response to simulate a 
% Poisson-ish spike train... as per last class!
xr=rand(size(nonlinearResp));
neuralResponse = nonlinearResp> .05*xr;
spikeCounts = neuralResponse;

%% So far, we constructed a model neuron and its response to experimental
% stimuli. We first constructed random Gaussian stimulus, we linearly 
% filtered it, put this linearly filtered signal through a non-linear 
% function to calculate an underlying firing rate of the cell, and used 
% this to simulate spikes coming out of the cell.  
% Here's the first second of each of these:
h = figure(5); clf;
h = subplot(3,1,1);
plot(linearResp(1:1000),'b-')
title('Linear response')
set(h,'XTick',[],'XTickLabel',[])
h = subplot(3,1,2);
plot(nonlinearResp(1:1000),'r-')
title('Nonlinear function of linear response')
set(h,'XTick',[],'XTickLabel',[])
h = subplot(3,1,3);
stem(neuralResponse(1:1000))
set(gca,'Ylim',[0 2]);
title('# of Spikes (1 ms bins)');
set(h,'XTick',[],'XTickLabel',[])

%% Things to do in class:
%
% 1. Try changing the linear function (choosing between getLinear1,
% getLinear2, getLinear3; see toggle comment). 
%
% 2. Try changing the nonlinear function (choose between getNonlinear1,
% getNonlinear2.m). Change it in the two places in the tutorial.
% What is the difference between getNonlinear1 and getNonlinear2?
