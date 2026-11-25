function [ ] = tif_align(folder_name, ref )

files = dir([folder_name, '/*.tif']);
num_img = size(files,1);
if num_img==0
    error('no TIFF files available')
end

f = imread([folder_name, '/', files(ref).name]);
if isa(f, 'uint8')
    img_depth = 8; % in bits
    display('8bits')
elseif isa(f, 'uint16')
    img_depth = 16; % in bits
    display('16bits')
else
    error('unknown format')
end

f = im2double(imread([folder_name, '/', files(ref).name]));
[nr,nc]=size(f);

s = regexp(files(1).name, '001', 'split');
output_file = [folder_name, '/', 'aligned_', s{1}, '.tif'];

for j = 1:num_img
    g = im2double(imread([folder_name, '/', files(j).name]));
    [output, Greg] = dftregistration(fft2(g),fft2(f),1);
    deltar = output(1,3);
    deltac = output(1,4);
    phase = output(1,2);
    Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
    Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
    [Nc, Nr] = meshgrid(Nc,Nr);
    g_reg = ifft2(fft2(g).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
    if img_depth == 8
        g_reg = uint8(g_reg*2^8);
    elseif img_depth ==16
        g_reg = uint16(g_reg*2^16);
    end
    if j==1
        imwrite(g_reg, output_file);
    else
        imwrite(g_reg, output_file, 'WriteMode', 'append');
    end
end



end

