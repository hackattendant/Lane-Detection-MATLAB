% Generates marked up output video from driving input video.
% read in video
v = VideoReader('../Videos/driving_vid.mp4');
% create output video and open it
out = VideoWriter('../Videos/status_driving_vid', 'MPEG-4');
open(out);

% initialize empty left and right lanes to be used on first pass
left = []; right = [];
while hasFrame(v)
    frame = readFrame(v);
    [X, left, right] = pipes(frame, left, right);
    writeVideo(out, X);  % write output frame
end
% close the output video
close(out);