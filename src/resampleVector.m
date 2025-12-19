function [dResampled, MetaSampled] = resampleVector(d, Meta, dRef, MetaRef)
% dをリサンプルしてdRefの時間と合わせる

Nx = size(d, 1);
Ny = size(d, 2);
Nind = size(d, 3); % 3 means u, v, corr
dResampled = nan(size(dRef)); 
for i = 1:Nx
    for j = 1:Ny
        for k = 1:Nind
            dResampled(i, j, k, :) = interp1(Meta.time,...
                                              squeeze(d(i, j, k, :)),...
                                              MetaRef.time,...
                                              'linear', 'extrap');
        end
    end
end

MetaSampled = Meta;
MetaSampled.time = MetaRef.time;
end