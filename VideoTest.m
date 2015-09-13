fileName = 'F:\BaiduYunDownload\Appendix4.avi';
obj = VideoReader(fileName);
currentTime = obj.CurrentTime;
numFrames = obj.NumberOfFrames;
perior = 60;

i = 1;
for k = 1:25*perior:numFrames
    frame = read(obj,k);
%     imshow(frame);
    imwrite(frame,strcat('g:\video\',num2str(i),'.bmp'),'bmp');% ±£¥Ê÷°
    i = i+1;
end

% total number is i-1
timeStamp = zeros(i-1,1);
for k = 1:i-1
    timeStamp(k,1) = 32046+(k-1)*perior;
end


