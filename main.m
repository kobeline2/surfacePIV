%%
init
%% ind
% 1{'VelocityU[mm/s]'           }
% 2{'VelocityV[mm/s]'           }
%  {'VelocityW[mm/s]'           } NOT READ
% 3{'Correlation coefficient'   }
%  {'AveY'                      } NOT READ
%  {'Standard Deviation'        } NOT READ
%  {'Valid Flag'                } NOT READ


%% read csv
% fn = "/Volumes/tk_main/selflining/PIV/case3_1/before/outer/shot1/";
dirPathList = ["/Volumes/Untitled/shonai/data/inflow/12121/per15sec"];
interval = 15;
% [d, coordX, coordY, columnNames] = readFlownizerCsv(fn); % signle csv
[d15, Meta15] = readFlowNizerCsvSeq(dirPathList, interval); % sequential csv

%% view data
ind = 6;
d = d1;
Meta = Meta2;
% viewMovie(dValid, 2, Meta)
viewVector(d, Meta)

%% check mean vector
inTime = 300:350;
d = dMerge(:, :, :, inTime); Meta = Meta4;
meanV = nanmedian(d, 4);
viewVector(meanV, Meta, 'roundOder', 1, 'maxc',0.5, 'scale', 4);

%% view mean vector in log
U = meanV(:, :, 1); U = sign(U).*log(abs(U));
V = meanV(:, :, 2); V = sign(V).*log(abs(V));
[q, mags] = magQuiver(Meta.xx, Meta.yy, U, V, 5, 'jet',1);

%% resampling
% d2 を T1 にリサンプリング
[d15, Meta15] = resampleVector(d15, Meta15, d4, Meta4);
viewVector(d15, Meta15, 'roundOder', 1, 'maxc', 2.0) 

%% Merge two data
dMerge = mergeCsv(d4, d15, Meta4);
% max(hypot(d15(:, :, 1, 1:end-30), d15(:, :, 2, 1:end-30)), [], "all")
isPlot = 1:(size(dMerge, 4)-30);
viewVector(dMerge, Meta4, 'roundOder', 1, 'isPlot', isPlot);

%% make new entities
% d = dMerge(:, :, :, 1:end-1);
Meta = Meta1;
TH_CORR = 0.8;
DO_INTERP = true;

dValid = interpVector(d, TH_CORR, DO_INTERP);
viewVector(dValid, Meta, false)


