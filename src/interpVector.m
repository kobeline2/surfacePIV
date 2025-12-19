function dValid = interpVector(d, TH_CORR, DO_INTERP)
% 不正ベクトルのはじきと内挿
NT = size(d, 4);
isValid = (d(:, :, 3, :) > TH_CORR) & ~isnan(d(:, :, 3, :));
dValid = d(:, :, 1:2, :);
for iTime = 1:NT
    for I = 1:2
        c1 = dValid(:, :, I, iTime);
        c1(~isValid(:, :, 1, iTime)) = NaN;
        if DO_INTERP
            c1 = fillmissing2(c1, "linear");
        end
        dValid(:, :, I, iTime) = c1;
    end
end

end
