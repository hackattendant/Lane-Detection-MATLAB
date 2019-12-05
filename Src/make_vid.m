%% Generates marked up output video from driving input video.

% for timing
t = cputime;

% read in video
v = VideoReader('../Videos/driving_vid.mp4');

% create output video and open it
out = VideoWriter('../Videos/out_driving_vid', 'MPEG-4');
open(out);

% initialize empty left and right lanes to be used on first pass
left = []; right = [];

while hasFrame(v)
    % read frame
    frame = readFrame(v);
    % get lines and draw
    [X, left, right] = pipes(frame, left, right);
    % write output frame
    writeVideo(out, X);  
end

% close the output video
close(out);
% calculate and display time
e = cputime - t;
disp(e);