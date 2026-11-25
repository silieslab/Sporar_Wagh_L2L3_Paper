function edge = fxMakingEdge(m,n,idx,pos,type)

if idx==0
    shape = 'back';
elseif idx == 1
    shape ='horz';
    angle = 0;
elseif idx == 2
    shape ='vert';
    angle = 90;
elseif idx == 3
    shape ='horz';
    angle = 180;
elseif idx == 4
    shape ='vert';
    angle = 270;
end
  
I = 2; % intensity level
switch shape
    case 'back'
        edge = ones(m,n);
        
    case 'horz'
        if strcmp(type,'on')
            dum = ones(pos,n);
            edge = I*[zeros(m-pos,n);dum]; 
            if angle==180
                edge = I*[dum;zeros(m-pos,n)];
            end
        elseif strcmp(type,'off')
            dum = zeros(pos,n);
            edge = I*[ones(m-pos,n);dum]; 
            if angle==180
                edge = I*[dum;ones(m-pos,n)];
            end
        end
        
    case 'vert'
        if strcmp(type,'on')
            dum = ones(m,pos);
            edge = I*[zeros(m,(n-pos)) dum];            
            if angle==270
                edge = I*[dum zeros(m,(n-pos))];
            end
        elseif strcmp(type,'off')
            dum = zeros(m,pos);
            edge = I*[ones(m,(n-pos)) dum];
            if angle==270
                edge = I*[dum ones(m,(n-pos))];
            end
        end
end
end