function [ out ] = crosscorrelation_negative10s(in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



%Take the data

rats = in.rats;
L = length (rats(:,1,1));
n1 = 1;
EPOCH = 7;
crats = rats(:,EPOCH,:);
crats = squeeze (crats);
OFF_Stimulus = in.OFF_stimulus;

% %% Normalization doenst work
% for kk = 1:length(crats(:,1));
%     crats(kk,:) = (crats(kk,:)/median(crats(kk,:)));
%     
% 
% end
%% Correlation
NaNindex = zeros;
negresponse = zeros;
posresponse = zeros;
for ii=1:L
minresponse = min(crats(ii,160:350));
maxresponse = max(crats(ii,160:350));
baselineresponse = mean(crats(ii,1:150));
%diffresponseOFF = baselineresponse + minresponse;
diffresponseOFF = baselineresponse + maxresponse;



if OFF_Stimulus == 1
if diffresponseOFF > 0
    negresponse(ii) = 1;
elseif diffresponseOFF < 0
    posresponse(ii) = 1;
else NaNindex(ii) = NaN;
end
elseif OFF_Stimulus == 0
if diffresponseOFF < 0
    negresponse(ii) = 1;
elseif diffresponseOFF > 0
    posresponse(ii) = 1;
else NaNindex(ii) = NaN;
end    
end       
end

out.Nancorrelationindex = NaNindex;
out.negresponse = (negresponse);
out.posresponse = (posresponse);


end
