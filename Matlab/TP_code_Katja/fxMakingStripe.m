function stripe = fxMakingStripe(m,n,d,idx,dir)

if idx==0
    shape = 'back';
elseif idx == 1
    shape ='horz';
    angle = 0;
elseif idx == 2
    shape ='diag';
    angle = 45;
elseif idx == 3
    shape ='vert';
    angle = 90;
elseif idx == 4
    shape ='diag';
    angle = 135;
elseif idx == 5
    shape ='horz';
    angle = 180;
elseif idx == 6
    shape ='diag';
    angle = 215;
elseif idx == 7
    shape ='vert';
    angle = 270;
elseif idx == 8
    shape ='diag';
    angle = 315;
end
    
switch shape
    case 'back'
        stripe = ones(m,n);
        
    case 'horz'
        dum = ones(d,n);
        stripe = [zeros(m-d,n);dum]; 
        if angle==180
            stripe = [dum;zeros(m-d,n)];
        end
        
    case 'vert'
        dum = ones(m,d);
        stripe = [zeros(m,(n-d)) dum];
        if angle==270
            stripe = [dum zeros(m,(n-d))];
        end
        
    case 'diag'
%         st = diag(ones(1,m));
%         stripe = diag(ones(1,m));
%         for i=-floor(d/2):1:floor(d/2)
%             if i<0
%                 s = ShiftMatrix(st,-i,'l',0);
%             elseif i==0
%                 s = zeros(m,m);
%             else
%                 s = ShiftMatrix(st,i,'r',0);
%             end
%             stripe = stripe + s;
%         end
               
        st = diag(ones(1,m));
        for i=1:d-1
            s = diag(ones(1,m-i),i);
            st = st + s;
        end        
        edge = cat(1,zeros(m-d,d),tril(ones(d,d),-1));
        stripe = cat(2,st,edge);
        
        if angle == 45 || angle==215
            stripe = flipud(stripe);
            if strcmp(dir,'r')
                stripe = stripe(1:m,1:m);
            elseif strcmp(dir,'l')
                stripe = stripe(1:end,d+1:end);
            end
%             st = diag(ones(1,m));
%             for i=1:d-1
%                 s = diag(ones(1,m-i),i);
%                 st = st + s;
%             end        
%             edge = cat(1,zeros(m-d,d),tril(ones(d,d),-1));
%             stripe = cat(2,st,edge);
            

%             stripe = cat(2,zeros(m,n-m-d),flipud(stripe));
            
        elseif angle==135 || angle==315
%             st = diag(ones(1,m));
%             for i=1:d-1
%                 s = diag(ones(1,m-i),i);
%                 st = st + s;
%             end        
%             edge = cat(1,zeros(m-d,d),tril(ones(d,d),-1));
%             stripe = cat(2,st,edge);
            if strcmp(dir,'r')
                stripe = stripe(1:m,1:m);
            elseif strcmp(dir,'l')
                stripe = stripe(1:end,d+1:end);
            end
            
%             stripe = cat(2,zeros(m,n-m-d),stripe);
%         elseif angle == 215
%             stripe = cat(2,flipud(stripe),zeros(m,n-m-d));        
%         elseif angle == 315
%             stripe = cat(2,stripe,zeros(m,n-m-d));
%         end       
%         if ((angle==45) || (angle==215))
%             stripe = flipud(stripe);
%         elseif angle == 135
%             stripe = cat(2,zeros(m,n-m-d),stripe);
%         elseif angle == 215
%             stripe = cat(2,flipud(stripe),zeros(m,n-m-d));        
%         elseif angle == 315
%             stripe = cat(2,stripe,zeros(m,n-m-d));
        end   
end
end