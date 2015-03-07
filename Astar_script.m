%initialize path at some spot
Initialize
pause(.25)

colormap('spring');

tic
closedset = zeros(1,xpix*ypix);
openset = zeros(1,xpix*ypix);
PARENT = (xpix*ypix + 1)*ones(1,xpix*ypix);
min_COST = PATH_COST = xpix*ypix*ones(1,xpix*ypix);

openset(start(1) + xpix*start(2)) = 1;
PARENT(start(1) + xpix*start(2)) = 0;
min_COST(start(1) + xpix*start(2)) = abs_min = sqrt((destination(1) - start(1))^2 + (destination(2)-start(2))^2);
PATH_COST(start(1) + xpix*start(2)) = 0;

while ~isempty(openset)
	current = find((min_COST + ~openset*2*xpix*xpix) == min((min_COST + ~openset*2*xpix*xpix)))(1);
	openset(current) = false; closedset(current) = true;
	ii_current = mod(current,xpix); jj_current = floor(current/xpix);
	if current == (destination(1) + destination(2)*xpix)
		path = reconstruct_path(current,PARENT);
		break
	end
	H.g.img(ii_current,jj_current,:) = ind2rgb(ceil(32*(min_COST(current)-abs_min)/sqrt(xpix^2+ypix^2)+1));
	for ii = [-1:1]
		for jj = [-1:1]
			ii_global = ii+ii_current;jj_global = jj+jj_current;
			if (~Obstacles(ii_global, jj_global)) & ~((ii==0) & (jj==0))
				TENTATIVE_PATH_COST = PATH_COST(current);
				if ii==0
					TENTATIVE_PATH_COST += 1;
				elseif jj == 0
					TENTATIVE_PATH_COST += 1;
				else
					TENTATIVE_PATH_COST += sqrt(2);
				end
				TENTATIVE_min_COST = TENTATIVE_PATH_COST + sqrt((destination(1) - ii_global)^2 + (destination(2)-jj_global)^2);
				ID = ii_global+xpix*jj_global;
				if ~(closedset(ID) & (TENTATIVE_min_COST >= min_COST(ID)))
					if (~openset(ID) | (TENTATIVE_min_COST < min_COST(ID)))
						PARENT(ID) = current;
						min_COST(ID) = TENTATIVE_min_COST;
						PATH_COST(ID) = TENTATIVE_PATH_COST;
						openset(ID) = 1;
						H.g.img(ii_global,jj_global,:) = [.25,.75,0];
					end
				end
			end
		end
	end
	
	H.g.img(destination(1),destination(2),:) = [0,1,0];
	set(H.g.image,'cdata',H.g.img)
	pause(.0001)
end
toc
Path_indices = [mod(path,xpix)',floor(path/xpix)'];
for ii = [1:length(Path_indices)]
	H.g.img(Path_indices(ii,1),Path_indices(ii,2),:) = [0,0,1];
	set(H.g.image,'cdata',H.g.img);
	pause(.005);
end