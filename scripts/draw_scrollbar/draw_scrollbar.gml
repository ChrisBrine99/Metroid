/// @description Draws a scrollbar with user a defined height and parameters for what the scroll wheel will be
/// used for. Can have it's color changed as well.
/// @param xPos
/// @param yPos
/// @param height
/// @param pageNum
/// @param pageSize
/// @param pageIndex
/// @param sBarCol1
/// @param sBarCol2
/// @param backCol

var xPos, yPos, height, pageNum, pageSize, pageIndex, sBarCol1, sBarCol2, backCol;
xPos = argument0;
yPos = argument1;
height = argument2;
pageNum = argument3;
pageSize = argument4;
pageIndex = argument5;
sBarCol1 = argument6;
sBarCol2 = argument7;
backCol = argument8;

draw_set_color(backCol);
draw_rectangle(xPos, yPos, xPos + 2, yPos + height, false);

var h = round((height - 5) * pageSize / pageIndex);
draw_rect_outline(xPos, yPos + round((height - h) * (pageNum / (pageIndex - pageSize))), 2, h, sBarCol1, sBarCol2);