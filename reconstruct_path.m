function path = reconstruct_path(ID,PARENT)
	if PARENT(ID) == 0
		path = [];
	else
		path = [reconstruct_path(PARENT(ID),PARENT),PARENT(ID)];
	end
end