% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function [p] = testing(filename)
ImageInput = imread(filename);
display(size(ImageInput));
[GC,ATW,ATG,Vs,ATW2,VsM,dilateEdge] = FnTrackInit8(ImageInput,1);
GreenChan=GC;
LT = FnTrack21(GC,VsM,dilateEdge);
imshow (LT);

bw = LT;

sigma=2; thresh=0.00105; sze=40; disp=0;
% Derivative masks
dy = [-1 0 1; -1 0 1; -1 0 1];
dx = dy'; %dx is the transpose matrix of dy
% Ix and Iy are the horizontal and vertical edges of image
Ix = conv2(bw, dx, 'same');
Iy = conv2(bw, dy, 'same');
% Calculating the gradient of the image Ix and Iy
g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');
% My preferred measure according to research paper
cornerness = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);
% We should perform nonmaximal suppression and threshold
mx = ordfilt2(cornerness,sze^2,ones(sze)); % Grey-scale dilate
cornerness = (cornerness==mx)&(cornerness>thresh); % Find maxima
[rws,cols] = find(cornerness); % Find row,col coords.
clf ; imshow(bw);
hold on;
p=[cols rws];
plot(p(:,1),p(:,2),'or');
title('\bf Harris Corners')
display(p);


