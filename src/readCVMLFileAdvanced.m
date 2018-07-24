% Copyright 2013, Robert Bosch GmbH
% Department CR/AEM
% Developed within the scope of project AEM-188 for cloud based security

function [objects, resolution] = readCVMLFileAdvanced(path, name)

f = fopen(strcat(path,name),'r');

tline = 'empty';

current_frame_number = -1;
resolution = [];

object = struct;
object = setfield(object,'ID',[]);
object = setfield(object,'frames',[]);
object = setfield(object,'BB',[]);
object = setfield(object,'KP',[]);
object = setfield(object,'KP_names',{});
object = setfield(object,'bool',[]);
object = setfield(object,'bool_names',{});

objects = struct;
objects = setfield(objects,'withID',{});
objects = setfield(objects,'noID',{});

% Definition of some states flags
isIDObject = 0;
IDObject_index = 0;
noIDObject_index = 0;
firstKP = 1;
firstBool = 1;

while( ischar(tline) )

    tline = fgetl(f);
    if ( ~ischar(tline))
        break;
    end
    tline = strtrim(tline);
    
    % Extract current FRAMENUMBER
    pos = strfind(tline, '<frame number="');
    
    if ( ~isempty(pos) )
        blanks = strfind(tline,' ');
        n = strfind(tline,'number="');
        endF = blanks(blanks > n);
        
        if ~isempty(endF)
            tline = tline(pos:endF(1));
        end
        
        tline = strrep(tline, '<frame ','');
        tline = strrep(tline, '/>',';');
        tline = strrep(tline, '>',';');
        tline = strrep(tline, '"','');
        tline = strrep(tline, ' ',';');

        eval(tline);
        current_frame_number = number;
        
        continue;
    end
    
    posR = strfind(tline, '<resolution ') ;
    
    if ( ~isempty(posR) )
        tline = strrep(tline, '<resolution ','');
        tline = strrep(tline, '/>',';');
        tline = strrep(tline, '"','');
        tline = strrep(tline, ' ',';');
        eval(tline);
        resolution = [height width];
        continue;
    end
    
    posFR = strfind(tline, '<framerate>');
    
    if ( ~isempty(posFR) )
        tline = strrep(tline, '<framerate>','framerate=');
        tline = strrep(tline, '</framerate>',';');
        eval(tline);
        continue;
    end
    
    % OBJECT with ID
    posObject = strfind(tline, '<object id=');
    
    if ( ~isempty(posObject) )
        tline = strrep(tline, '<object ','');
        tline = strrep(tline, '>',';');
        tline = strrep(tline, '"','');
        tline = strrep(tline, ' ',';');
        eval(tline);
        
        isIDObject = 1;
        
        % NOTE
        % All origial ids are substituted by id+1!!!
        IDObject_index = id+1;
        
        % If new object add to structure
        if (length(objects.withID) >= IDObject_index)
            if isempty(objects.withID{IDObject_index})
                objects.withID{IDObject_index} = object;
            end
        else
            objects.withID{IDObject_index} = object;
        end
        
        % set ID value
        objects.withID{IDObject_index}.ID = IDObject_index;
        
        % set framenumber
        objects.withID{IDObject_index}.frames = [objects.withID{IDObject_index}.frames; current_frame_number];
        
        firstKP = 1;
        firstBool = 1;
        
        continue;
    end
    
    % OBJECT without ID
    posObject = strfind(tline, '<object>');
    
    if ( ~isempty(posObject) )
        isIDObject = 0;
        noIDObject_index = noIDObject_index + 1;
        
        % Add new object to structure
        objects.noID{noIDObject_index} = object;
        
        % set no ID value
        objects.noID{noIDObject_index}.ID = -1;
        
        % set framenumber
        objects.noID{noIDObject_index}.frames = [objects.noID{noIDObject_index}.frames; current_frame_number];
        
        firstKP = 1;
        firstBool = 1;
        continue;
    end
    
    % BOOLEAN flags
    posBool = strfind(tline, '<attr name="') ;
    
    if ( ~isempty(posBool) )
        posName = strfind(tline, 'name="');
        posValue = strfind(tline, 'value="');
        boolName = tline(posName+6:posValue-3);
        boolValue = -1;
        if strcmp(tline(posValue+7:posValue+7),'t')
            boolValue = 1;
        end
        
        if isIDObject
            % Set bool value
            if isempty(objects.withID{IDObject_index}.bool)
                objects.withID{IDObject_index}.bool = boolValue;
            else
                [R, C] = size(objects.withID{IDObject_index}.bool);
                if firstBool
                    objects.withID{IDObject_index}.bool(R+1,1) = boolValue;
                else
                    b = find(~objects.withID{IDObject_index}.bool(R,:),1,'first');
                    if isempty(b)
                        b = C+1;
                    end
                    objects.withID{IDObject_index}.bool(R,b) = boolValue;
                end
            end
            
            % Set name of this Boolean
            [R, C] = size(objects.withID{IDObject_index}.bool);
            if (R < 2)
                objects.withID{IDObject_index}.bool_names{C} = boolName;
            end
        else
            % Set bool value
            if isempty(objects.noID{noIDObject_index}.bool)
                objects.noID{noIDObject_index}.bool = boolValue;
            else
                [R, C] = size(objects.noID{noIDObject_index}.bool);
                if firstKP
                    objects.noID{noIDObject_index}.bool(R+1,1) = boolValue;
                else
                    b = find(~objects.noID{noIDObject_index}.bool(R,:),1,'first');
                    if isempty(b)
                        b = C+1;
                    end
                    objects.noID{noIDObject_index}.bool(R,b) = boolValue;
                end
            end
            
            % Set name of this Boolean
            [R, C] = size(objects.noID{noIDObject_index}.bool);
            if (R < 2)
                objects.noID{noIDObject_index}.bool_names{C} = boolName;
            end
        end

        firstBool = 0;
        continue;
    end
    
    % KEYPOINT collection
    posKeyPoint = strfind(tline, '<KeyPoint Name=') ;
    if ( ~isempty(posKeyPoint))
        posValid = strfind(tline, 'Valid');
        posName = strfind(tline, 'Name="');
        KP_name = tline(posName+6:posValid-3);
        tline = tline(posValid:end-2);
        tline = strrep(tline, '/>',';');
        tline = strrep(tline, '"','');
        tline = strrep(tline, ' ',';');
        eval(tline);
        
        KP = [Valid X Y];
        
        % NOTE
        % KP should not contain zeros for evaluation purposes
        % So, if a KP contains value 0 just change it to 1 in order to make
        % processings easier (high accuracy is not required here) !!
        KP(KP==0) = 1;
        
        if isIDObject
            % Set Keypoint values
            if isempty(objects.withID{IDObject_index}.KP)
                objects.withID{IDObject_index}.KP = KP;
            else
                [R, C] = size(objects.withID{IDObject_index}.KP);
                if firstKP
                    objects.withID{IDObject_index}.KP(R+1,1:3) = KP;
                else
                    b = find(~objects.withID{IDObject_index}.KP(R,:),1,'first');
                    if isempty(b)
                        b = C+1;
                    end
                    objects.withID{IDObject_index}.KP(R,b:b+2) = KP;
                end
            end
            
            % Set name of this Keypoint
            [R, C] = size(objects.withID{IDObject_index}.KP);
            if (R < 2)
                objects.withID{IDObject_index}.KP_names{C/3} = KP_name;
            end
        else
            % Set Keypoint values
            if isempty(objects.noID{noIDObject_index}.KP)
                objects.noID{noIDObject_index}.KP = KP;
            else
                [R, C] = size(objects.noID{noIDObject_index}.KP);
                if firstKP
                    objects.noID{noIDObject_index}.KP(R+1,1:3) = KP;
                else
                    b = find(~objects.noID{noIDObject_index}.KP(R,:),1,'first');
                    if isempty(b)
                        b = C+1;
                    end
                    objects.noID{noIDObject_index}.KP(R,b:b+2) = KP;
                end
            end
            
            % Set name of this Keypoint
            [R, C] = size(objects.noID{noIDObject_index}.KP);
            if (R < 2)
                objects.noID{noIDObject_index}.KP_names{C/3} = KP_name;
            end
        end
        
        firstKP = 0;
        continue;
    end
    
    % BOUNDING BOX
    posBB = strfind(tline, '<box ') ;
    
    if ( ~isempty(posBB))
        tline = strrep(tline, '<box ','');
        tline = strrep(tline, '/>',';');
        tline = strrep(tline, '"','');
        tline = strrep(tline, ' ',';');
        eval(tline);
        
        BB = [(x-width/2) (y-height/2) width height];
        
        if isIDObject
            objects.withID{IDObject_index}.BB = [objects.withID{IDObject_index}.BB; BB];
        else
            objects.noID{noIDObject_index}.BB = [objects.noID{noIDObject_index}.BB; BB];
        end
        
        continue;
    end
end

fclose(f);