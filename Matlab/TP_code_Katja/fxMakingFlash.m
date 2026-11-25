function flash = fxMakingFlash(m,n,idx)

if idx==0
    shape = 'back';
elseif idx == 1
    shape ='flash';
end

I = 2;
switch shape
    case 'back'
        flash = ones(m,n);
    case 'flash'
        flash = I*ones(m,n);
end
end
    