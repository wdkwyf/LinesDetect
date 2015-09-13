shadow = zeros(i-1,1);
isVaild = zeros(i-1,1);
for kk = 1:1
   
fileName = strcat('g:\video\',num2str(kk),'.bmp')

I = imread(fileName);
WB = rgb2gray(I);
W = imadjust(WB,[],[],3.5);



% ��תͼ��Ѱ�ұ�Ե
rotI = imrotate(W,33,'crop');
BW2 = edge(rotI,'canny');


% ִ��Hough�任����ʾHough����
[H,T,R] = hough(BW2);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit'); %�õ�ͼ9.12��a��
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

% ��Hough������Ѱ��ǰ5������Hough���������ֵ0.3���ķ�ֵ
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1)); % ���С�������ת����ʵ������
plot(x,y,'s','color','white'); % ��Hough����ͼ���б����ֵλ��

% �ҵ�������ֱ��
lines = houghlines(BW2,T,R,P,'FillGap',7,'MinLength',10); % �ϲ�����С��5���߶Σ��������г���С��7��ֱ�߶�
figure, imshow(rotI), hold on
max_len = 0;
for k = 1:length(lines) % ���α������ֱ�߶�
   xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % �����߶ζ˵�
     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%      plot(1713,443,'x','LineWidth',3,'Color','white');
   % ȷ������߶�
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
    %�Ƿ���Ч
    isVaild(kk,1) = 1;            
    shadow(kk,1) = norm(lines(start).point1 - lines(tail).point2);
end

end

xlswrite('g:\a.xls',timeStamp,'sheet1','A1');
xlswrite('g:\a.xls',shadow,'sheet1','B1');
xlswrite('g:\a.xls',isVaild,'sheet1','C1');







