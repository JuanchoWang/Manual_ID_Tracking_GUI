function new_dat = readJSONFile(fa_num, json_file)
addpath('\\hi2crsmb\external\wan4hi\Code\jsonlab');
ori_dat = loadjson(json_file);
new_dat = {};
fra_obj = {};

dat_obj = struct;
dat_obj = setfield(dat_obj,'ID',[]);
dat_obj = setfield(dat_obj,'frames',[]);
dat_obj = setfield(dat_obj,'BB',[]);
dat_obj = setfield(dat_obj,'KP',[]);
dat_obj = setfield(dat_obj,'KP_names',{});
dat_obj = setfield(dat_obj,'bool',[]);
dat_obj = setfield(dat_obj,'bool_names',{});

num_id = 1;
fnum = 0;
dat_obj.KP_names = {'LAnkle','LEar','LElbow','LEye','LHip','LKnee','LShoulder','LWrist','Neck','Nose','RAnkle',...
                    'REar','RElbow','REye','RHip','RKnee','RShoulder','RWrist'};
dat_obj.bool_names = {'Occluded'};
dat_obj.bool = -1;
                
for unit_idx = 1:length(ori_dat)
    if fnum ~= fa_num + ori_dat{1,unit_idx}.image_id - 1
        % As long as the image_id(frame) changes, push the information to
        % the final dataset, do this once also in the end
        for objnum_fra = 1:length(fra_obj)
            if objnum_fra > length(new_dat)
                new_dat{objnum_fra} = fra_obj{objnum_fra};
                continue
            end
            new_dat{1,objnum_fra}.frames = [new_dat{1,objnum_fra}.frames; fra_obj{1,objnum_fra}.frames];
            new_dat{1,objnum_fra}.BB = [new_dat{1,objnum_fra}.BB; fra_obj{1,objnum_fra}.BB];
            new_dat{1,objnum_fra}.KP = [new_dat{1,objnum_fra}.KP; fra_obj{1,objnum_fra}.KP];
            new_dat{1,objnum_fra}.bool = [new_dat{1,objnum_fra}.bool; fra_obj{1,objnum_fra}.bool];
            new_dat{1,objnum_fra}.KP_names = dat_obj.KP_names;
            new_dat{1,objnum_fra}.bool_names = dat_obj.bool_names;
        end
        
        fnum = fa_num + ori_dat{1,unit_idx}.image_id - 1;
        num_id = 1;
        
        % set the information only for current object
        dat_obj.ID = num_id;
        dat_obj.frames = fnum;
        X_array = [ori_dat{1,unit_idx}.keypoints(1:3:end)];
        X_array = X_array(X_array~=0);
        minX = min(X_array);
        maxX = max(X_array);
        Y_array = [ori_dat{1,unit_idx}.keypoints(2:3:end)];
        Y_array = Y_array(Y_array~=0);
        minY = min(Y_array);
        maxY = max(Y_array);
        bb_width = 1.2 * (maxX - minX);
        bb_height = 1.2 * (maxY - minY);
        bb_Xpos = minX - 0.1 * (maxX - minX);
        bb_Ypos = minY - 0.1 * (maxY - minY);
        dat_obj.BB = fix([bb_Xpos bb_Ypos bb_width bb_height]);
        dat_obj.KP = setKP(ori_dat{1,unit_idx}.keypoints);
        
        % deliver the information to the whole frame information (image_id)
        fra_obj = {dat_obj};
    else
        num_id = num_id + 1;
        
        dat_obj.ID = num_id;
        dat_obj.frames = fnum;
        X_array = [ori_dat{1,unit_idx}.keypoints(1:3:end)];
        X_array = X_array(X_array~=0);
        minX = min(X_array);
        maxX = max(X_array);
        Y_array = [ori_dat{1,unit_idx}.keypoints(2:3:end)];
        Y_array = Y_array(Y_array~=0);
        minY = min(Y_array);
        maxY = max(Y_array);
        bb_width = 1.2 * (maxX - minX);
        bb_height = 1.2 * (maxY - minY);
        bb_Xpos = minX - 0.1 * (maxX - minX);
        bb_Ypos = minY - 0.1 * (maxY - minY);
        dat_obj.BB = fix([bb_Xpos bb_Ypos bb_width bb_height]);
        dat_obj.KP = setKP(ori_dat{1,unit_idx}.keypoints);
        
        fra_obj{num_id} = dat_obj;
    end
end
for objnum_fra = 1:length(fra_obj)
    if objnum_fra > length(new_dat)
        new_dat = {new_dat fra_obj{1,objnum_fra}};
        continue
    end
    new_dat{1,objnum_fra}.frames = [new_dat{1,objnum_fra}.frames; fra_obj{1,objnum_fra}.frames];
    new_dat{1,objnum_fra}.BB = [new_dat{1,objnum_fra}.BB; fra_obj{1,objnum_fra}.BB];
    new_dat{1,objnum_fra}.KP = [new_dat{1,objnum_fra}.KP; fra_obj{1,objnum_fra}.KP];
    new_dat{1,objnum_fra}.bool = [new_dat{1,objnum_fra}.bool; fra_obj{1,objnum_fra}.bool];
    new_dat{1,objnum_fra}.KP_names = dat_obj.KP_names;
    new_dat{1,objnum_fra}.bool_names = dat_obj.bool_names;
end
% set an empty cell before all valid data cell
new_dat = {[] new_dat{:}};