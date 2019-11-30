v = VideoReader('Data/black_car.mp4');
out = VideoWriter('~/Desktop/polygon_test.mp4', 'MPEG-4');
open(out);
first_pass = true;
left = [];
right = [];
while hasFrame(v)
    frame = readFrame(v);
    [X, left, right] = pipes(frame, left, right, first_pass);
    writeVideo(out, X);
    first_pass = false;
end
close(out);