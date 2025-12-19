% 元動画ファイル名
infile = '/Volumes/koshiba1G/本実験結果/241223①/241223①_increase.MP4';

% 出力動画
outfile = 'fast_forward_small.mp4';

% N倍速にしたい倍率
N = 10;

% 読み込み
v = VideoReader(infile);

% 出力VideoWriter
out = VideoWriter(outfile, 'MPEG-4');

% 再生速度をN倍に → フレームは全て使うが FrameRate を N倍に設定
out.FrameRate = v.FrameRate * N;

open(out);

% サイズ縮小の倍率
scale = 0.1;   % 50%に縮小（例）

while hasFrame(v)
    frame = readFrame(v);
    % 画像縮小（PPT用に軽量化）
    frame_small = imresize(frame, scale);
    % 書き込み
    writeVideo(out, frame_small);
end

close(out);

disp('早送り＆縮小動画を書き出しました。');