function [out,out_lags]=align_array_LB2(a,maxLag)

out = zeros(size(a));
out_lags = zeros(size(a,1),1);
nLines = size(a,1);
ref = mean(a,1);
for i = 1:nLines
    [y,lags] = xcov(ref',a(i,:)',maxLag,'coeff');
    [V,I] = max(y);
    out(i,:) = circshift(a(i,:)',lags(I))';
    out_lags(i) = lags(I);
end