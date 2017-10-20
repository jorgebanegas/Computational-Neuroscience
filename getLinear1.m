
n [linearResp,filter] = getLinear1(stimulus, kernelSize)

tau = 10;

% Compute the linear response using a single exponential
% lowpass filter.  You could substitute other linear filters here if you
% wanted to, but this one is pretty simple.  The 3rd row of y is the linear
% response (refer to diffEqTutorial).  This takes couple of minutes to calculate
linearResp=zeros(length(stimulus),3);
for i=1:length(stimulus)-1
linearResp(i+1,1) = linearResp(i,1)+(1/tau)*(stimulus(i) - linearResp(i,1));
end
% Getting rid of the first- and second-order filtered signals, we only
% want the third one.
linearResp = linearResp(:,1);

impulse = zeros(1000,1); impulse(1) = 1;
impulseResp=zeros(length(impulse),3);
for i=1:length(impulse)-1
impulseResp(i+1,1) = impulseResp(i,1)+(1/tau)*(impulse(i) - impulseResp(i,1));
end

impulseResp = impulseResp(:,1);
impulseResp = impulseResp(1:1:1*kernelSize);
impulseResp = flipud(impulseResp);
filter = impulseResp;
