function viewMovie(d, ind, Meta, secPause)
CM = "jet";
% params
if nargin == 3; secPause = 0.2; end

N = size(d, 4);

p = imagesc(Meta.coordX, Meta.coordY, d(:, :, 1, ind));
b = round(max(abs(d(:, :, ind, :)), [], 'all'));
clim([-b b]); colorbar; colormap(CM)
axis equal tight
for I = 1:N
    p.CData = d(:, :, ind, I);
    pause(secPause)
    % drawnow
end
end

