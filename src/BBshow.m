function uobj = BBshow(objd,fnum,pnam,ppat,axe)
num_obj = 0;
colors = {[1 0 0], [1 1 0],[0 1 0],[0 1 1],[0 0 1],[1 0 1],[1 1 1],[1 0.5 0],...
    [0 0 0],[0.5 0 1]};
uobj = [];
%objd = setfield(objd{:,1}, 'col',[]);
axes(axe); 
H = imread(strcat(ppat, pnam));
imshow(H);
for i = 2:length(objd)
    %if fnum >= objd{1,i}.frames(1) && fnum <= objd{1,i}.frames(end)
    [boolf, findex] = ismember(fnum,objd{1,i}.frames);
    if boolf == 1
        uobj = [uobj;objd{1,i}];
        num_obj = num_obj + 1;
        switch mod(num_obj,10)+1
            case 1
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-red');
            case 2
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-yellow');
            case 3
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-green');
            case 4
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-cyan');
            case 5
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-blue');
            case 6
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-magenta');
            case 7
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-white');
            case 8
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-orange');
            case 9
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-black');
            case 10
                uobj(num_obj).ID = strcat(int2str(uobj(num_obj).ID),'-purple');
        end
        pos_BB = objd{1,i}.BB(findex,:);
        %axes(axe);        
        rectangle('Position',pos_BB,'EdgeColor',colors{mod(num_obj,10)+1});
        text(pos_BB(1) + 2, pos_BB(2) + 6, uobj(num_obj).ID, 'Color', 'y');
    end
end