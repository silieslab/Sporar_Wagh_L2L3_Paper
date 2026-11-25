missingTriggers = size(out.ratio,2) - length(out.fstimval);
triggerZeros = zeros(missingTriggers,1);
out.fstimval = [triggerZeros ; out.fstimval];
out.avrstimval = [triggerZeros ; out.avrstimval];
out.fstimpos1 = [triggerZeros ; out.fstimpos1];
out.fstimpos2 = [triggerZeros ; out.fstimpos2];


out = FFFlash_res_display_1ch(out,2);

save_processed_data_1ch_eni(out);%

%print what the stimulus was
d = dir('_stimulus_*');
fid = fopen(d.name,'r');
currline = fgetl(fid);
ind = strfind(currline,'\');
disp(sprintf('stimulus: %s',currline(ind(end)+1:end)));
fclose(fid);