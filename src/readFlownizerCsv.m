function [meshData, coordX, coordY, columnNames] = readFlownizerCsv(fn)

% ファイルを開く
fid = fopen(fn, 'r');

% ヘッダーの読み込み
headers = cell(7, 1);
for i = 1:7
    headers{i} = fgetl(fid); % ヘッダーの各行を読み込む
end

% nx と ny をヘッダー5行目から抽出
header5 = strsplit(headers{5}, ','); % カンマ区切りで分割
nx = str2double(header5{3}); % 3列目から nx を取得
ny = str2double(header5{5}); % 5列目から ny を取得

% ヘッダー7行目からカラム名を取得
columnNames = strsplit(headers{7}, ','); % カンマ区切りで分割

% データ部分を読み込む
formatSpec = [repmat('%s', 1, length(columnNames))]; % カラム数に応じたフォーマット
rawData = textscan(fid, formatSpec, 'Delimiter', ',', 'HeaderLines', 0);

% ファイルを閉じる
fclose(fid);

% 数値変換（文字列から数値に変換し、失敗したら NaN を適用）
dataMatrix = NaN(length(rawData{1}), length(columnNames)); % 初期化
for col = 1:length(columnNames)
    % 各カラムを数値変換
    numericColumn = str2double(rawData{col});
    dataMatrix(:, col) = numericColumn; % 数値として格納（変換できない値は NaN）
end

% データ部分の行数をチェックして正しい行数があるか確認
expectedRows = nx * ny;
if size(dataMatrix, 1) ~= expectedRows
    error('Data rows (%d) do not match nx * ny (%d). Check your file!', size(dataMatrix, 1), expectedRows);
end

% nx × ny のメッシュデータに変形
meshData = reshape(dataMatrix, [nx, ny, length(columnNames)]);
coordX = meshData(1:nx, 1, 4);
coordY = meshData(1, 1:ny, 5)';

end