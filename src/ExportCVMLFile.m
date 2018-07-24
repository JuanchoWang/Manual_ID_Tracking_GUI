function ExportCVMLFile(datzt,resol,frat,fa_num,fe_num,target_path,cvml_name)

% target_path = '\\hi2crsmb\external\wan4hi\Daten\Data_only_for_code_test\Export_CVML_Test';

docNode = com.mathworks.xml.XMLUtils.createDocument('dataset');
docRootNode = docNode.getDocumentElement;
%docNode.createComment(' Thank you for using manual annotator tool developed by Wang ');
re_sol = docNode.createElement('resolution');
re_sol.setAttribute('height',int2str(resol(2)));
re_sol.setAttribute('width',int2str(resol(1)));
docRootNode.appendChild(re_sol);

fr_rate = docNode.createElement('framerate');
fr_rate.appendChild(docNode.createTextNode(int2str(frat)));
docRootNode.appendChild(fr_rate);

for f_idx = fa_num:fe_num%0:totnum
    frame_info = docNode.createElement('frame');
    frame_info.setAttribute('number',int2str(f_idx));
    % don't set timestamp any longer, that is generated from CNN
%     frame_info.setAttribute('timestamp',int2str(f_idx*tst));
%     frame_info.setAttribute('timestamp64',int2str(f_idx*tst_new));
    obj_list = docNode.createElement('objectlist');
    face_list = docNode.createElement('facelist');
    frame_info.appendChild(obj_list);
    frame_info.appendChild(face_list);
    docRootNode.appendChild(frame_info);
    
    for j = 2:length(datzt)
        [boolf id_fidx] = ismember(f_idx, datzt{1,j}.frames);        
        if boolf == 1
            obj_info = docNode.createElement('object');
            obj_info.setAttribute('id',int2str(datzt{1,j}.ID));
            obj_list.appendChild(obj_info);
            bbox = docNode.createElement('box');
            role = docNode.createElement('role');
            bbox.setAttribute('height',int2str(datzt{1,j}.BB(id_fidx,4)));
            bbox.setAttribute('width',int2str(datzt{1,j}.BB(id_fidx,3)));
            bbox.setAttribute('x',int2str(datzt{1,j}.BB(id_fidx,1) + 0.5*datzt{1,j}.BB(id_fidx,3)));
            bbox.setAttribute('y',int2str(datzt{1,j}.BB(id_fidx,2) + 0.5*datzt{1,j}.BB(id_fidx,4)));
            role.setAttribute('static','1');
            role.appendChild(docNode.createTextNode('person'));
            per_det = docNode.createElement('personDetail');
            bo_att = docNode.createElement('boolAttributes');
            obj_info.appendChild(bbox);
            obj_info.appendChild(role);
            obj_info.appendChild(per_det);
            obj_info.appendChild(bo_att);
            
            %Keypoint
            for kp_idx = 1:18
                KP_info = docNode.createElement('KeyPoint');
                KP_info.setAttribute('Name',datzt{1,j}.KP_names(kp_idx));
                KP_info.setAttribute('Valid',int2str(datzt{1,j}.KP(id_fidx, kp_idx*3-2)));
                KP_info.setAttribute('X',int2str(datzt{1,j}.KP(id_fidx, kp_idx*3-1)));
                KP_info.setAttribute('Y',int2str(datzt{1,j}.KP(id_fidx, kp_idx*3)));
                per_det.appendChild(KP_info);
            end
            attr = docNode.createElement('attr');
            attr.setAttribute('name','Occluded');
            attr.setAttribute('value','false');
            bo_att.appendChild(attr);
        end
    end
end
xmlwrite(strcat(target_path,'\',cvml_name),docNode);