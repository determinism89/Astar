%Initialize initializes the Astar algorithms
clear
clc
close all

LOADMAP = input('Type the name of the desired environment, specify nothing to default: ','s');
if isempty(LOADMAP)
	LOADMAP = 'default';
end
load(LOADMAP);
xpix = size(H.g.colors,1); ypix = size(H.g.colors,2);

figure(1);
axis equal
H.g.image = image(H.g.img);

disp('Specify a start point (click on the image)');
[Y,X,b] = ginput(1);
start = ceil([X;Y] - [.5;.5]);
H.g.colors(start(1),start(2)) = 4;
H.g.img(start(1),start(2),:) = [0,0,1];
H.g.image = image(H.g.img);
disp('Specify a destination (click on the image)');
[Y,X,b] = ginput(1);
destination = ceil([X;Y] - [.5;.5]);
H.g.colors(destination(1),destination(2)) = 3;
H.g.img(destination(1),destination(2),:) = [0,1,0];
H.g.image = image(H.g.img);

x_indices = [1:xpix]; y_indices = [1:ypix];

Obstacles = (H.g.colors == 0);
Map = zeros(xpix,ypix);
min_Cost = sqrt(ones(ypix,1) * [[destination(1) - x_indices].^2] + [[destination(2) - y_indices].^2]' * ones(1,xpix));