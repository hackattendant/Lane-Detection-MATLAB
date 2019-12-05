%% Generates marked up output video from driving input video.
function make_vid(input_path, output_path, out_type)
    % for timing
    t = cputime;

    % read in video
    v = VideoReader(input_path);

    % create output video and open it
    out = VideoWriter(output_path, out_type); 
    open(out);

    % initialize empty left and right lanes to be used on first pass
    left = []; right = [];

    while hasFrame(v)
        % read frame
        frame = readFrame(v);
        % get lines and draw
        [X, left, right] = pipeline(frame, left, right);
        % write output frame
        writeVideo(out, X);  
    end

    % close the output video
    close(out);
    % calculate and display time
    e = cputime - t;
    disp("Time taken:");
    disp(e);
end