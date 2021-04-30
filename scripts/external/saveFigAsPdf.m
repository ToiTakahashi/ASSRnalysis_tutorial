function [flag] = saveFigAsPdf( figs, filenames )
%saveFigAsPdf 指定したfigureハンドルをPDFで保存する
%             export_figのツールボックス（アドオン）が必要
%   flag = saveFigAsPdf( fig, filename )
%
%   figs:       figureハンドル(figure配列)
%   filenames:  ファイル名を拡張子抜きで指定(セル配列)
%   flag:       セーブが正常に完了したかどうか

% Copyright (c) 2019 larking95(https://qiita.com/larking95)
% Released under the MIT Licence
% https://opensource.org/licenses/mit-license.php

% 初期化
flag = false;
% 引数の検証
validateattributes(figs, {'matlab.ui.Figure'}, {'vector'});
validateattributes(filenames, {'cell'}, {'vector'});
if length(figs) ~= length(filenames)
    error('figureの要素数と名前の要素数が異なります');
end

% PDFファイルの保存
for i = 1:length(figs)
    distFile = [filenames{i}, '.pdf'];

    % 上書きの確認
    if isfile(distFile)
        str = input('Do you want to overwrite the exsist file? Y/N [N]', 's');
        if isempty(str) || ~strcmpi(str, 'Y')
            warning('Stop saving the pdf file.');
            return;
        end

    end
    export_fig(distFile, figs(i));
end
flag = ~flag;
