shadow = zeros(i-1,1);
isVaild = zeros(i-1,1);
for kk = 1:1
   
fileName = strcat('g:\video\',num2str(kk),'.bmp')

I = imread(fileName);
WB = rgb2gray(I);
W = imadjust(WB,[],[],3.5);



% 旋转图像并寻找边缘
rotI = imrotate(W,33,'crop');
BW2 = edge(rotI,'canny');


% 执行Hough变换并显示Hough矩阵
[H,T,R] = hough(BW2);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit'); %得到图9.12（a）
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

% 在Hough矩阵中寻找前5个大于Hough矩阵中最大值0.3倍的峰值
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1)); % 由行、列索引转换成实际坐标
plot(x,y,'s','color','white'); % 在Hough矩阵图像中标出峰值位置

% 找到并绘制直线
lines = houghlines(BW2,T,R,P,'FillGap',7,'MinLength',10); % 合并距离小于5的线段，丢弃所有长度小于7的直线段
figure, imshow(rotI), hold on
max_len = 0;
for k = 1:length(lines) % 依次标出各条直线段
   xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % 绘制线段端点
     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%      plot(1713,443,'x','LineWidth',3,'Color','white');
   % 确定最长的线段
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

okS = 0;okT = 0;
for start = 1:k
    if(lines(start).point1(1,1) <1200 && lines(start).point1(1,1) > 1100 && lines(start).point1(1,2)>750 && lines(start).point1(1,2) < 850 )
       okS = okS +1;
       break;
    end
end
for tail = 1:k
    if(lines(tail).point1(1,1) <1850 && lines(tail).point1(1,1) > 1650 && lines(tail).point1(1,2)>350 && lines(tail).point1(1,2) < 550)
       okT = okT +1;
       break;
    end
end


% length of shadow
if(okT == 1 && okS == 1)
    %是否有效
    isVaild(kk,1) = 1;            
    shadow(kk,1) = norm(lines(start).point1 - lines(tail).point2);
end

end

xlswrite('g:\a.xls',timeStamp,'sheet1','A1');
xlswrite('g:\a.xls',shadow,'sheet1','B1');
xlswrite('g:\a.xls',isVaild,'sheet1','C1');







