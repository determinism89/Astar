function img = BuildImage(map)
	%0 = black
	%1 = white
	%2 = red
	%3 = green
	%4 = blue
	%5 = yellow
	
	
	x = size(map,1);
	y = size(map,2);
	img = zeros(x,y,3);
	white = find(map == 1);
	white = [white;white+x*y;white+2*x*y];
	
	red = find(map==2);
	red = red;
	green = find(map==3);
	green = [green + x*y];
	blue = find(map==4);
	blue = [blue + 2*x*y];
	yellow = find(map==5);
	yellow = [yellow;yellow+x*y];
	
	colors = [white;red;green;blue;yellow];
	img(colors) = 1;
endfunction