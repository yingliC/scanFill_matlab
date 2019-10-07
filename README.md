# scanFill

## 要求：
#### 鼠标在屏幕上点若干点形成多边形，用扫描线算法给多边形着红色


## 思路  
1. 获取并存储鼠标在屏幕上点的若干点的坐标（左键获取坐标，右键结束获取)；
2. 在屏幕上生成封闭图形
3. 扫描线算法着色（奇偶规则识别同一内部区域）
   * 确定填充区边界与屏幕扫描线的交点位置
   * 将填充色应用于扫描线上位于填充区内部的每一段

---

## 具体： 

找到多边形的最小和最大y值，用这个范围内的每一条水平线与多边形相交，交点画线段，由此填充整个多边形。  

#### 一、具体通过交点画线段：  
   1. 对存储交点的数组进行排序（从小到大）
   2. 数组中数据两两一对，填充每对交点的线段  
   (即求出扫描线与多边形的交点、对交点数组进行排序)
   
#### 二、对于求扫描线与多边形的交点，考虑一下几个特殊情况：
   1. 扫描线与边重合：直接重画这条线
   ![扫描线与边重合](https://github.com/yingliC/Images/blob/master/sanFill_images/扫描线与边重合.jpeg)
   
   2. 扫描线与边的交点为顶点   
   ![扫描线与边的交点为顶点](/Users/caoyingli/Pictures/MacDown_Images/扫描线与边的的交点为顶点.jpeg)  
   （通过与顶点关联的两条边的另外两个顶点是不是在交点同一侧来判断一个顶点是否为极值点）  
    * 顶点为局部极值：交点被连续记录两次  
    ![顶点为极值点](/Users/caoyingli/Pictures/MacDown_Images/顶点为极值点.jpeg)
    * 顶点不是局部极值：交点只被记录一次
    ![顶点为非极值点](/Users/caoyingli/Pictures/MacDown_Images/顶点为非极值点.jpeg)
     
 ---
 ## 运行结果
 ![提示](/Users/caoyingli/Pictures/MacDown_Images/结果提示.png)
 
 ![扫描](/Users/caoyingli/Pictures/MacDown_Images/结果扫描.png)
 