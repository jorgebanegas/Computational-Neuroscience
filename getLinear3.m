
n [linearResp,filter] = getLinear3(stimulus, kernelSize)

tau = 3;

% Compute the linear response using a 3 stage cascade of exponential
% lowpass filters.  You could substitute other linear filters here if you
% wanted to, but this one is pretty simple.  The 3rd row of y is the linear
% response (refer to diffEqTutorial).  This takes couple of minutes to calculate
linearResp=zeros(length(stimulus),3);
for i=1:length(stimulus)-1
linearResp(i+1,1) = linearResp(i,1)+(1/tau)*(stimulus(i) - linearResp(i,1));
linearResp(i+1,2) = linearResp(i,2)+(1/tau)*(linearResp(i,1) - linearResp(i,2));
linearResp(i+1,3) = linearResp(i,3)+(1/tau)*(linearResp(i,2) - linearResp(i,3));
end
% Getting rid of the first- and second-order filtered signals, we only
% want the third one.
linearResp = linearResp(:,3);

impulse = zeros(1000,1); impulse(1) = 1;
impulseResp=zeros(length(impulse),3);
for i=1:length(impulse)-1
impulseResp(i+1,1) = impulseResp(i,1)+(1/tau)*(impulse(i) - impulseResp(i,1));
impulseResp(i+1,2) = impulseResp(i,2)+(1/tau)*(impulseResp(i,1) - impulseResp(i,2));
impulseResp(i+1,3) = impulseResp(i,3)+(1/tau)*(impulseResp(i,2) - impulseResp(i,3));
end
% Getting rid of the first- and second-order filtered signals, we only
% want the third one.
impulseResp = impulseResp(:,3);
%impulseResp = impulseResp(10:10:10*kernelSize+10-1); % only if screen refresh
impulseResp = impulseResp(1:1:1*kernelSize);
impulseResp = flipud(impulseResp);
filter = impulseResp;
