function viewVector(d, Meta, opts)

arguments
    d double
    Meta struct
    opts.isPlot (1,:) {mustBeInteger}  = 0
    opts.maxc (1,1) double = -1.0
    opts.outGif logical = false
    opts.scale (1,1) double = 1.0
    opts.secPause (1,1) double = 0.1
    opts.cm char = 'jet'
    opts.roundOder (1,1) double = -1;
    opts.resolution (1, 1) double = 300
end

% general
% YLIMS = [-100, 2100];
% XLIMS = [-200, 3200];
FN_GIF = "animation.gif";
% scaling color bar 
LEVELS = 5;
ROUND_ORDER = opts.roundOder;

% calc xlim, ylim
R = 1/20;
lb = min(Meta.coordX); ub = max(Meta.coordX); ll = ub - lb;
XLIMS = [lb-ll*R, ub+ll*R];
lb = min(Meta.coordY); ub = max(Meta.coordY); ll = ub - lb;
YLIMS = [lb-ll*R, ub+ll*R];

N = size(d, 4);
isPlot = opts.isPlot;
if isPlot == 0
    isPlot = 1:N;
end

maxc = opts.maxc;
if opts.maxc < 0 % default 
    maxc = max(hypot(d(:, :, 1, isPlot), d(:, :, 2, isPlot)), [], "all");
    maxc = round(maxc, ROUND_ORDER); 
end
fprintf("max value is %.2f \n", maxc)

[xx, yy] = meshgrid(Meta.coordX, Meta.coordY);

for I = isPlot
    magQuiver(xx', yy', d(:, :, 1, I), d(:, :, 2, I),...
              maxc, opts.cm , opts.scale);
    axis equal
    ylim(YLIMS) % change accordingly
    xlim(XLIMS) % change accordingly
    c = colorbar;
    c.Ticks = linspace(0, 1, LEVELS);
    c.TickLabels = linspace(0, maxc, LEVELS);
    if opts.outGif
        exportgraphics(gca, FN_GIF, Append=true, Resolution=opts.resolution)
    end
    pause(opts.secPause)
    % drawnow
end
end