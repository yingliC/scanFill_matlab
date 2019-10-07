%{

扫描线算法填充多边形
要求：鼠标在屏幕上点若干点形成多边形，用扫描线算法给多边形着红色

1）获取并存储鼠标在屏幕上点的若干点的坐标（左键获取坐标，右键结束获取)；
2）在屏幕上生成封闭图形
3）扫描线算法着色（奇偶规则识别同一内部区域）
       a) 确定填充区边界与屏幕扫描线的交点位置
       b) 将填充色应用于扫描线上位于填充区内部的每一段
%}

function scanfill

%     points[]: 存储鼠标在屏幕上点的若干点的坐标
%  point_count: 顶点个数

global points;
global point_count;
% global isStopOnce;
points = [];
point_count = 0;

figure('WindowButtonDownFcn',@wbdcb);
helpdlg('鼠标左键点击取点，右键点击结束绘图。','绘图说明');
ah = axes('SortMethod','childorder');
axis ([0 50 0 50]); % 创建笛卡尔坐标区
grid on;
title("扫描线算法填充");

    function wbdcb(src,callbackdata)
        seltype = src.SelectionType;
        if strcmp(seltype,'normal')
            src.Pointer = 'circle';
            cp = ah.CurrentPoint;
            point_count = point_count + 1;
            points(point_count,1) = cp(1,1);
            points(point_count,2) = cp(1,2);
            
            hold on;
            % 画线
            plot(points(point_count,1), points(point_count,2),'p');
            if (point_count >= 2)
                % Bresenhamline(points(point_count-1,1),points(point_count-1,2),points(point_count,1),points(point_count,2));
                line([points(point_count-1,1),points(point_count,1)],[points(point_count-1,2),points(point_count,2)]);
            end
            
            % 如果鼠标点击的是右键
        elseif strcmp(seltype,'alt')
            line([points(point_count,1),points(1,1)],[points(point_count,2),points(1,2)]);
            fill;
            points=[];
            point_count = 0;
        end
              
    end
    % 扫描填充
    function fill
        %{
            找到多边形的最小y值和最大y值，用这个范围内的每一条水平线与多边形相交，
        交点画线段，由此填充整个多边形。
            一、具体通过交点画线段：
                1.对存储交点的数组进行排序（从小到大）
                2.数组中数据两两一对，填充每对交点的线段
                (即求出扫描线与多边形的交点、对交点数组进行排序)
            二、对于求扫描线与多边形的交点，考虑一下几个特殊情况：
                1.扫描线与边重合：
                  直接重画这条线
                2.扫描线与边的交点为顶点
                （通过与顶点关联的两条边的另外两个顶点是不是在交点同一侧来判断一个顶点是否为极值点）
                  1).顶点为局部极值
                    交点被连续记录两次
                  2).顶点不是局部极值
                    交点只被记录一次
        %}
        
        minYPoint = min(points);
        maxYPoint = max(points);
        miny = minYPoint(2);
        maxy = maxYPoint(2);
        % 最高点y值上取整
        
%         maxy = round(maxYPoint(2));
        
        judge = zeros(1,point_count);
        index = [];
        disp(points);
        % 从最小的y值到最大y值进行扫描
        for y = miny:maxy
            
%             disp('for y=min:max');
            fprintf('for y=min:max--y%g\n',y);
            
            %记录扫描线与边线的交点
            temp = 1;
            vNumber = point_count;
            j1 = vNumber;
            
            for i1 = 1:vNumber
          
                fprintf('for i1=1:vNmuber--i1,j1:%g,%g\n',i1,j1);
                
                sx = points(i1,1);
                sy = points(i1,2);
                tx = points(j1,1);
                ty = points(j1,2);
                lowy = min(sy,ty);
                highy = max(sy,ty);
                
                % 水平线
                if (ty == sy)
                    
                    disp('如果是水平线');
                    % 水平线与y扫描线重合
                    if(y == ty)
                        
                        disp('如果水平线与y扫描线重合');
                        
                        maxX = max(sx,tx);
                        minX = min(sx,tx);
                        % 画线
                        line([minX,maxX],[y,y],'color','red');
                    end
                    j1 = i1;
                    continue;
                end
                % 没有交点
                if(y<lowy || y > highy)
                    
                    disp('if i<lowy || highy,没有交点');
                    
                    j1 = i1;
                    continue;
                end
                
                disp('有一个交点，两点式求直线方程');
                x = sx + (y - sy) * (tx - sx) / (ty - sy);
                disp(x);
                % 判断交点（x,y）是不是顶点
                
                if(x == points(i1,1) && y == points(i1,2))
                    
                    disp('如果交点是顶点');
                    
                    % 判断顶点是不是极值点
                    %即判断与交点相关联的两条线的另外两个顶点是不是在交点的同一侧
                    if(i1 ~= vNumber && judge(i1) == 0)
                        disp('如果顶点不是最后一个点');

                        if((y-points(i1+1,2))*(y-points(j1,2)) < 0)
                            disp('异号，在不同侧，记录一次');
                            index(temp) = x;
                            temp = temp + 1;
                        else % 同号，极值点记录两次
                            disp('同号，在同侧，记录二次');
                            index(temp) = x;
                            temp = temp + 1;
                            index(temp) = x;
                            temp = temp + 1;
                        end
                    elseif(i1 == vNumber && judge(i1) == 0)
                        disp('如果顶点是最后一个点');
                        if((y - points(1,2)) * (y - points(j1,2)) < 0)
                            disp('异号，在不同侧，记录一次');
                            index(temp) = x;
                            temp = temp + 1;
                        else
                            disp('同号，在同侧，记录二次');
                            index(temp) = x;
                            temp = temp + 1;
                            index(temp) = x;
                            temp = temp + 1;
                        end
  
                    end
                    judge(i1) = 1;
                    j1 = i1;
                    continue;
                    
                elseif(x == points(j1,1) && y == points(j1,2))
                    disp('如果顶点不是最后一个点2');
                    if(j1 ~= 0 && judge(j1) == 0)
                        if((y - points(i1,2)) * (y - points(j1-1,2)) < 0)
                            index(temp) = x;
                            temp = temp + 1;
                        else
                            index(temp) = x;
                            temp = temp + 1;
                            index(temp) = x;
                            temp = temp + 1;
                        end
                    elseif(j1 == 0 && judge(j1) == 0)
                        if(y - points(i1,2) * (y - points(l-1,2)) < 0)
                            index(temp) = x;
                            temp = temp + 1;
                        else
                            index(temp) = x;
                            temp = temp + 1;
                            index(temp) = x;
                            temp = temp + 1;
                        end
                    end
                    judge(j1) = 1;
                    j1 = i1;
                    continue;
                end
                % 交点不是顶点
                disp('交点不是顶点，直接算作一个交点');
                index(temp) = x;
                temp = temp + 1; 
                j1 = i1;
            end
            fprintf('index:');
            disp(index);
            % 将index排序
            tempIndex = sort(index);
            
            fprintf('tempIndex:');
            disp(tempIndex);
            
            % 填充多边形
            n = 1;
            m = n + 1;
            disp('准备填充多边形');
            while(m <= temp && tempIndex(n) ~= 0)
                disp('正在填充多边形');
                line([tempIndex(n),tempIndex(m)],[y,y],'color','red');
                n = n + 2;
                m = n + 1;
                disp('line red');
                
            end
            
            % 清零
            index = []; 
        end
        
        disp('扫描结束');
    end

end