
n nonlinearResp = getNonlinear1(linearResp);

nonlinearResp = zeros(size(linearResp));
theind = find(linearResp>0);
nonlinearResp(theind) = linearResp(theind).^2;

