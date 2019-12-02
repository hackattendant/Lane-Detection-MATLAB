% Generates marked up output video from driving input video.
% read in video
v = VideoReader('../Videos/driving_vid.mp4');
% create output video and open it
out = VideoWriter('../Videos/out_vid.mp4', 'MPEG-4');
open(out);
% set pipes first pass flag to true for first call
first_pass = true;
% initialize empty left and right lanes to be used on first pass
left = []; right = [];
while hasFrame(v)
    frame = readFrame(v);
    [X, left, right] = pipes(frame, left, right, first_pass);
    writeVideo(out, X);  % write output frame
    % change the pipes first_pass flag to false for all other calls
    first_pass = false; 
end
% close the output video
close(out);