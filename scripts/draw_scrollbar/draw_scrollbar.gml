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
/// @param alpha

var xPos, yPos, height, pageNum, pageSize, pageIndex, sBarCol1, sBarCol2, backCol, alpha;
xPos = argument0;			// The x position of the scrollbar on the screen
yPos = argument1;			// The y position of the scrollbar on the screen
height = argument2;			// The maximum height that the scrollbar can be/ area if can move around
pageNum = argument3;		// The current page number that the scroll bar is at
pageSize = argument4;		// The size of the page that the scrollbar is being used for
pageIndex = argument5;		// The current element number of the corresponding list
sBarCol1 = argument6;		// The inner color of the scrollbar
sBarCol2 = argument7;		// The scrollbar's outline color
backCol = argument8;		// The color of the rectangle found behind the scrollbar
alpha = draw_get_alpha();

// Drawing the backing rectangle for the scrollbar
draw_sprite_general(spr_generic_rectangle, 0, 0, 0, 1, 1, xPos, yPos, 2, height, 0, backCol, backCol, backCol, backCol, alpha);

// Drawing the actual scrollbar
var h = round((height - 5) * pageSize / pageIndex);
draw_rect_outline(xPos, yPos + round((height - h) * (pageNum / (pageIndex - pageSize))), 2, h, sBarCol1, sBarCol1, sBarCol2, alpha, alpha);