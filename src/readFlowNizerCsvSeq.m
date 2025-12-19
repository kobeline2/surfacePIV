function [d, Meta] = readFlowNizerCsvSeq(dirPathList, interval)
% 
% interval [sec]

COL_LIST = [6, 7, 9]; % 6:u, 7:v, 9:corr
nDir = length(dirPathList);
for iDir = 1:nDir
    dirPath = fullfile(dirPathList(iDir), '*.csv');
    fnList = dir(dirPath);
    fnList = fnList(~startsWith({fnList.name}, '.'));
    
    N = length(fnList);
    
    % I = 1 (this treatment is for parfor)
    fn = fullfile(fnList(1).folder, fnList(1).name);
    [tmp, coordX, coordY, ~] = readFlownizerCsv(fn);
    dd = zeros(length(coordX), length(coordY), length(COL_LIST), N); 
    dd(:, :, :, 1) = tmp(:, :, COL_LIST);
    
    % I > 2
    parfor I = 2:N
        fn = fullfile(fnList(I).folder, fnList(I).name);
        tmp = readFlownizerCsv(fn);
        dd(:, :, :, I) = tmp(:, :, COL_LIST);
        if mod(I, 100) == 0
            fprintf("dir No.%u %d / %d finished \n", iDir, I, N); 
        end
    end
    if iDir == 1
        d = dd;
    else
        d = cat(4, d, dd);
    end
end
% create Meta
Meta = struct("coordX", coordX, "coordY", coordY);
numT = size(d, 4);
T = interval/2:interval:numT*interval; length(T) 
Meta.time = T';
[xx, yy] = meshgrid(Meta.coordX, Meta.coordY);
Meta.xx = xx'; Meta.yy = yy';
end