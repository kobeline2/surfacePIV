function dMerge = mergeCsv(d1, d2, Meta)

NT = length(Meta.time);
dMerge = nan([size(d1, [1, 2]), 3, NT]);
for iTime = 1:NT
    % d1の方がCORRがd2より高い，もしくはd1にしかデータがない場合はd1の値を使う
    d1HasHigerCorr = d1(:, :, 3, iTime) > d2(:, :, 3, iTime);
    d1OnlyNonNan = ~isnan(d1(:, :, 3, iTime)) & isnan(d2(:, :, 3, iTime));
    useD1 = d1HasHigerCorr | d1OnlyNonNan;
    % d2の方がCORRがd1より高い，もしくはd2にしかデータがない場合はd1の値を使う
    d4HasHigerCorr = d1(:, :, 3, iTime) < d2(:, :, 3, iTime);
    d2OnlyNonNan = ~isnan(d2(:, :, 3, iTime)) & isnan(d1(:, :, 3, iTime));
    useD2 = d4HasHigerCorr | d2OnlyNonNan;
    for I = 1:3
        c = nan(size(d1, [1, 2]));
        tmp = d1(:, :, I, iTime);
        c(useD1) = tmp(useD1);
        tmp = d2(:, :, I, iTime);
        c(useD2) = tmp(useD2);
        dMerge(:, :, I, iTime) = c;        
    end
end
end