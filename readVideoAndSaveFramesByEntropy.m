clear;
tic
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);

% videoPathName = 'd:\data_seq\originData\V80710-161715.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-161643.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-161337.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-161159.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-161143.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-143610.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-143526.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-143450.mp4';
% videoPathName = 'd:\data_seq\originData\V80710-161732.mp4';
% imgsPath = 'd:\data_seq\sequences\realWindingRopesCompact\';

% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801100315_20180816143658.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801101809_20180816153232.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801133159_20180816170904.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801100315_20180817144729.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801100615_20180817150020.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801133159_20180817154714.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817160757.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817161503.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817162021.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817162702.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817164152.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817164837.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817165211.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817165810.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817170848.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817171533.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801192514_20180823132342.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801192514_20180823132938.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801100315_20180816143658_work.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801101809_20180816153232_work.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801133159_20180816170904_shadow.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801133159_20180817154714_shadow.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817164837_work.mp4';
% videoPathName = 'd:\data\windingRope\20180801æÌÕ≤…„œÒÕ∑ ”∆µ\preProcess\ch01_20180801175600_20180817165211_work.mp4';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\data\dark_video_uniform.mp4';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\data\light_video_uniform.avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\data\dark_video_mess.mp4';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\data\light_video_mess0.avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\data\light_video_mess1.mp4';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\data\1 (1).avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\data\1 (2).avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess1.avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess2.avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess3.avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_jun_yun2.avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_jun_yun1.avi';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\dark_jun_yun1.avi';
% videoPathName = 'd:\dataFromDell\drone\DCIM\100MEDIA\DJI_0047.MOV';
% videoPathName = 'd:\data\drone\DCIM\100MEDIA\DJI_0047.MOV';
% videoPathName = 'd:\data\drone\DCIM\100MEDIA\DJI_0050.MP4';
% videoPathName = 'd:\data\drone\DCIM\100MEDIA\DJI_0001.MP4';
% videoPathName = 'd:\data\drone\DCIM\100MEDIA\DJI_0002.MP4';
% videoPathName = 'd:\data\drone\DCIM\100MEDIA\DJI_0003.MP4';
videoPathName = 'd:\data\drone\DCIM\100MEDIA\DJI_0004.MP4';
% imgsPath = 'd:\data\windingRope\20180801\dayLeft\';
% imgsPath = 'd:\data\windingRope\20180801\dayLeftCompact\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\data\dark_video_uniform\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\data\light_video_uniform\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\data\dark_video_mess\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\data\light_video_mess0\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\data\light_video_mess1\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\data\1 (1)\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\data\1 (2)\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess1\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess2\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess3\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_jun_yun2\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_jun_yun1\';
% imgsPath = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\dark_jun_yun1\';
% imgsPath = 'd:\data_seq\drone\companyTechPark\181119\';
% imgsPath = 'd:\data_seq\drone\companyTechPark\1811191008\';
% imgsPath = 'd:\data_seq\drone\companyTechPark\1811191119\';
% imgsPath = 'd:\data_seq\drone\companyTechPark\1811191439DJI_0003\';
imgsPath = 'd:\data_seq\drone\companyTechPark\1811191509DJI_0004\';

% added by Holy 1808161134
if exist(imgsPath, 'dir') ~= 7
    mkdir(imgsPath);
end
% end of addition 1808161134

listing = dir([imgsPath '*.jpg']);
if isempty(listing)
    iMax = 1;
else
    iMax = size(listing,1) + 1;
end

tagFileName = 'img';

vidObj = VideoReader(videoPathName);
numFrames = ceil(vidObj.Duration * vidObj.FrameRate);
i = 1;
% currAxes = axes;
% fig_handle = figure('Name', 'winding rope');
while hasFrame(vidObj)
    progressbar(i, numFrames);
    vidFrame = readFrame(vidObj);
%     image(vidFrame, 'Parent', currAxes);
%     currAxes.Visible = 'off';    
%     pause(1/vidObj.FrameRate);
    
    % save frames
    imgPathName = fullfile(imgsPath, [tagFileName num2str(iMax,'%05d') '.jpg']);
    imwrite(vidFrame, imgPathName);
    iMax = iMax + 1;
    i = i + 1;
end
toc