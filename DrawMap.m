clear
clc
close all

LOAD = input('Load a map?: ','s');
if strcmp(LOAD,'Y') | strcmp(LOAD,'y') | strcmp(LOAD,'Yes') | strcmp(LOAD,'yes')
	MAP = input('Please give the filename of the map: ','s')
	load(MAP);
	[xpix,ypix] = size(H.g.colors);
else
	xpix = input('Width of map (pixels): ');
	ypix = input('Height of map (pixels): ');
	H.g.colors = zeros(xpix,ypix);
	H.g.colors([2:(xpix-1)],[2:(ypix-1)]) = ones(xpix-2,ypix-2);
	H.g.img = BuildImage(H.g.colors);
end

figure(1);
image(H.g.img);
axis equal

DRAWSTATE = 2; %SQUARE=0,DELETE=1,LINE=2
CLICKS = 0;
USERDRAW = true;
while USERDRAW
	[Y,X,BUTTON] = ginput(1);
	X = ceil(X-.5); Y = ceil(Y-.5);
	
	if X > xpix
		X = xpix;
	elseif X < 1
		X = 1;
	end
	if Y > ypix
		Y = ypix;
	elseif Y < 1
		Y = 1;
	end
	
	if isempty(BUTTON)
		USERDRAW = false;
	end
	switch BUTTON
		case 108 %l
			DRAWSTATE = 2;
			CLICKS = 0;
		case 115 %s
			DRAWSTATE = 0;
			CLICKS = 0;
		case 100 %d
			DRAWSTATE = 1;
			CLICKS = 0;
		case 1 %left click
			CLICKS = CLICKS+1;
			POINTS(CLICKS,:) = [X,Y];
			if CLICKS == 2;
				switch DRAWSTATE
					case 0
						H.g.colors([min(POINTS(:,1)):max(POINTS(:,1))],[min(POINTS(:,2)):max(POINTS(:,2))]) = zeros(abs(POINTS(2,:)-POINTS(1,:)) + [1,1]);
						H.g.img = BuildImage(H.g.colors);
						image(H.g.img);
						axis equal
						CLICKS = 0;
					case 1
						H.g.colors([min(POINTS(:,1)):max(POINTS(:,1))],[min(POINTS(:,2)):max(POINTS(:,2))]) = ones(abs(POINTS(2,:)-POINTS(1,:)) + [1,1]);
						temp = H.g.colors([2:(xpix-1)],[2:(ypix-1)]);
						H.g.colors = zeros(xpix,ypix);
						H.g.colors([2:(xpix-1)],[2:(ypix-1)]) = temp;
						H.g.img = BuildImage(H.g.colors);
						image(H.g.img);
						axis equal
						CLICKS = 0;
					case 2
						CLICKS = 0;
				end
			end
	end
end
SAVEIT = input('Would you like to save this map?(y/n): ','s');
if strcmp(SAVEIT,'Y') | strcmp(SAVEIT,'y') | strcmp(SAVEIT,'Yes') | strcmp(SAVEIT,'yes')
	if strcmp(LOAD,'Y') | strcmp(LOAD,'y') | strcmp(LOAD,'Yes') | strcmp(LOAD,'yes')
		OVERWRITE = input('Overwrite the previous map?(y/n): ','s');
		if strcmp(OVERWRITE,'Y') | strcmp(OVERWRITE,'y') | strcmp(OVERWRITE,'Yes') | strcmp(OVERWRITE,'yes')
			save(MAP,'H');
			break;
		end
	end
	MAP = input('Please specify a name: ','s');
	if isempty(MAP)
		MAP = 'default';
	end
	save(MAP,'H');
else
	save('latest','H');
end
