fn = "/Users/koshiba/Desktop/xyz.csv";
dd = readmatrix(fn);

%%
% d = dd(dd(:, 2) <-600, :); interval = 1;
d = dnew; interval = 5;
scatter3(d(1:interval:end, 1),...
         d(1:interval:end, 2),...
         d(1:interval:end, 3),...
         1, d(1:interval:end, 3))
axis equal

%%
ctmp = sky;
k = 17;
ctmp(1:k, :) = repmat([1, 0, 0], k, 1);
colormap(ctmp);
c = colorbar;
clim([0, 15])
ax = gca;
ax.Color = 'w';

%%
dnew = zeroSet(dd, ref);

%%
writematrix(dnew, "/Users/takahiro/Desktop/scan/250111_itoExp/xyzNew.csv");

%%
function d = zeroSet(d, ref)
    N = length(ref);
    [x, y, z] = deal(zeros(N, 1));
    for I = 1:N
        x(I) = ref(I).Position(1);
        y(I) = ref(I).Position(2);
        z(I) = ref(I).Position(3);
    end
    % Set up fittype and options.
    ft = fittype( 'poly11' );
    % Fit model to data.
    [f, ~] = fit( [x, y], z, ft );
    zNew = @(x, y, z) z - f.p00 - x*f.p10 - y*f.p01;
    d(:, 3) = zNew(d(:, 1), d(:, 2), d(:, 3));
end 

