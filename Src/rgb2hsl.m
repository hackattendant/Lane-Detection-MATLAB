% Package Provided by MathWorks to convert from RGB to HSL.
% https://www.mathworks.com/matlabcentral/fileexchange/20292-hsl2rgb-and-rgb2hsl-conversion
%Converts Red-Green-Blue Color value to Hue-Saturation-Luminance Color value
    %
    %Usage
    %       HSL = rgb2hsl(RGB)
    %
    %   converts RGB, a M [x N] x 3 color matrix with values between 0 and 1
    %   into HSL, a M [x N] X 3 color matrix with values between 0 and 1
    %
    %See also hsl2rgb, rgb2hsv, hsv2rgb

    % (C) Vladimir Bychkovsky, June 2008
    % written using: 
    % - an implementation by Suresh E Joel, April 26,2003
    % - Wikipedia: http://en.wikipedia.org/wiki/HSL_and_HSV

function hsl=rgb2hsl(rgb_in)
    % Convert image to range [0 1]
    % Added by me to make my input source correct
    rgb_in = double(rgb_in)/ 255;  

    rgb=reshape(rgb_in, [], 3);

    mx=max(rgb,[],2);%max of the 3 colors
    mn=min(rgb,[],2);%min of the 3 colors

    L=(mx+mn)/2;%luminance is half of max value + min value
    S=zeros(size(L));

    % this set of matrix operations can probably be done as an addition...
    zeroidx= (mx==mn);
    S(zeroidx)=0;

    lowlidx=L <= 0.5;
    calc=(mx-mn)./(mx+mn);
    idx=lowlidx & (~ zeroidx);
    S(idx)=calc(idx);

    hilidx=L > 0.5;
    calc=(mx-mn)./(2-(mx+mn));
    idx=hilidx & (~ zeroidx);
    S(idx)=calc(idx);

    hsv=rgb2hsv(rgb);
    H=hsv(:,1);

    hsl=[H, S, L];

    hsl=round(hsl.*100000)./100000; 
    hsl=reshape(hsl, size(rgb_in));
end