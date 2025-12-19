U = meanV(:, :, 1);
V = meanV(:, :, 2);
X = Meta.xx;
Y = Meta.yy;

%% A. 非線形スケーリングで動的レンジを圧縮する
% X,Y,U,V: PIV格子と速度
S = hypot(U,V);
s0   = prctile(S(:),50);      % スケール基準(中央値など)
Smax = prctile(S(:),99);      % カラーバー上限の安定化
Sm   = asinh(S/s0) / asinh(Smax/s0);   % 0..1 に圧縮

% 背景に圧縮スカラー場を描画
imagesc(X(:,1), Y(1,:), Sm); axis image; set(gca, 'YDir', 'normal');
colormap(turbo); cb = colorbar;

% 物理値に対応した色凡例(非線形)の目盛り
ticks = linspace(0,1,5);
cb.Ticks = ticks;
cb.TickLabels = arrayfun(@(t)sprintf('%.2g', s0*sinh(t*asinh(Smax/s0))), ticks, 'uni',0);

% 圧縮長さの矢印(方向は元のU,V, 長さだけ圧縮)
scale = Sm ./ (S + eps);
scale = scale*100;
U2 = U .* scale; V2 = V .* scale;

hold on
quiver(X,Y,U2,V2,0,'k','LineWidth',0.4, Color='w');  % scale=0でデータ長をそのまま
title('asinh-compressed speed background + compressed-length quiver');

%% B. 二層クイバー(閾値・密度・スケールを変えて重ねる)
S = hypot(U,V);
th = prctile(S(:),10);  % 主流/低速の閾値
maskSlow = S<=th; maskFast = S>th;

% 間引き(密度調整)
stepFast = 2; stepSlow = 1;  % 画面に合わせて調整
idxFast = false(size(S)); idxFast(1:stepFast:end,1:stepFast:end) = true;
idxSlow = false(size(S)); idxSlow(1:stepSlow:end,1:stepSlow:end) = true;

hold on
quiver(X(maskFast&idxFast),Y(maskFast&idxFast), ...
       2*U(maskFast&idxFast),2*V(maskFast&idxFast),0,'k','LineWidth',0.6);
quiver(X(maskSlow&idxSlow),Y(maskSlow&idxSlow), ...
       50*U(maskSlow&idxSlow),50*V(maskSlow&idxSlow),0,'r','LineWidth',0.8);

%% C. 大域流＋渦(変動)の分離表示
% 平滑化で主流を取り出し, 残差を渦・小構造として別スタイルで重ねます.
Ubar = imgaussfilt(U,3);  Vbar = imgaussfilt(V,3);  % 大スケール
u = U - Ubar;             v   = V - Vbar;           % 小スケール(渦など)
figure
% 主流: ストリームラインで細く
sx = linspace(min(X(:)),max(X(:)),30);
sy = prctile(Y(1, :), [5, 25, 50, 75, 95]);
[sx, sy] = meshgrid(sx, sy);
h = streamline(X',Y',Ubar',Vbar',sx,sy);
set(h,'Color',[0.2 0.2 0.2],'LineWidth',0.6);

% make some of long streamlines unvisible
% figure; h = streamline(X',Y',Ubar',Vbar',sx,sy); 
% M = numel(h);
% for I = 1:M
%     N = sqrt(sum((h(I).XData - h(I).YData).^2, "omitmissing"))/M;
%     if N > 500
%         r = rand();
%         if r > 0.05
%             h(I).Visible = 'off';
%         end
%     end
%     Nlist(I) = N;
% end
%%
% 渦: 残差ベクトルを強調
hold off
Su = hypot(u,v); scale = sqrt(Su./(prctile(Su(:),95)+eps));  % 軽く圧縮
scale = scale*100; %% added
quiver(X,Y,u.*scale./(Su+eps), v.*scale./(Su+eps),0, 'r','LineWidth',0.8);
title('mean flow (streamlines) + small-scale fluctuations (red quiver)');

%% D. 矢印は方向のみ, 量は等値線や背景で表現
S = hypot(U,V);
skip = 2;
Udir = U./(S+eps); Vdir = V./(S+eps);  % 単位ベクトル
contourf(X,Y,S,12,'LineStyle','none'); colormap(turbo); colorbar; hold on
quiver(X(1:skip:end, 1:skip:end),...
       Y(1:skip:end, 1:skip:end), ...
       Udir(1:skip:end, 1:skip:end),...
       Vdir(1:skip:end, 1:skip:end),...
       0.4, 'Color', 'k', 'LineWidth', 1);
% title('constant-length quiver (direction) + speed contours');
colormap turbo
c = colorbar;
caxis([0, 120])
axis equal
xticks([]); yticks([]);
fig = gcf;
setFig(fig, 9, 12, 9, 'T')
c.Color = 'k';

%%
dx = mean(diff(X(:,1))); dy = mean(diff(Y(1,:)));
[Uy, Ux] = gradient(U,dy,dx);
[Vy, Vx] = gradient(V,dy,dx);
omega = Vx - Uy;  % 2D渦度z

imagesc(X(:,1),Y(1,:),S); axis image; set(gca,'YDir','normal'); colormap(turbo); colorbar; hold on
% contour(X,Y,omega, prctile(omega(:),[15 85]), 'LineColor','k','LineWidth',0.8); % 渦の縁を描く
contour(X,Y,omega, 'LineColor','k','LineWidth',0.8); % 渦の縁を描く