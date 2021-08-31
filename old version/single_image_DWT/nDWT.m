% @Time     : 1 June, 2020
% @Author   : Tiantian Li and Yuexin Xiang
% @Email    : ltt@cug.edu.cn or yuexin.xiang@cug.edu.cn

function [cA1,cH1,cV1,cD1,cA2,cH2,cV2,cD2,cA3,cH3,cV3,cD3] = nDWT(I,N)
if N==3
    [c,s] = wavedec2(double(I),3,'haar');
    cA1 = appcoef2(c,s,'haar',1);
    cH1 = detcoef2('h',c,s,1);
    cV1 = detcoef2('v',c,s,1);
    cD1 = detcoef2('d',c,s,1);
    cA2 = appcoef2(c,s,'haar',2);
    cH2 = detcoef2('h',c,s,2);
    cV2 = detcoef2('v',c,s,2);
    cD2 = detcoef2('d',c,s,2);
    cA3 = appcoef2(c,s,'haar',3);
    cH3 = detcoef2('h',c,s,3);
    cV3 = detcoef2('v',c,s,3);
    cD3 = detcoef2('d',c,s,3);
    
    k = s(2,1)*2 - s(3,1);
    cH2 = padarray(cH2,[k k],1,'post');
    cV2 = padarray(cV2,[k k],1,'post');
    cD2 = padarray(cD2,[k k],1,'post');
    
    k = s(2,1)*4 - s(4,1);
    cH1 = padarray(cH1,[k k],1,'post');
    cV1 = padarray(cV1,[k k],1,'post');
    cD1 = padarray(cD1,[k k],1,'post');
end

if N==1
    [c,s] = wavedec2(double(I),1,'haar');
    cA1 = appcoef2(c,s,'haar',1);
    cH1 = detcoef2('h',c,s,1);
    cV1 = detcoef2('v',c,s,1);
    cD1 = detcoef2('d',c,s,1);
end
