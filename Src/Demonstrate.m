%% Demonstrate on Video
% make_vid('../Videos/short.mp4', '../Videos/run_test', 'MPEG-4')

%% Demonstrate on Image
v = VideoReader('../Videos/short.mp4');
frame = readFrame(v);

left = []; right = [];
[X, left, right] = pipeline(frame, left, right);
close all; imshow(X);
