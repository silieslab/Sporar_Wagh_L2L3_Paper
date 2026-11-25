function y = cantor(cantor)
    j  = floor(sqrt(0.25 + 2*cantor) - 0.5);
    y = cantor - j*(j+1)/2;
end