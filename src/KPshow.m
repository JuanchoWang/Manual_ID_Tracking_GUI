function KPshow(ube,fnum,axe)
%Connection between keypoints
[boolf, findex] = ismember(fnum,ube.frames);
LiW = 1.5;
Col = 'w';
cuv = [1 1];
if ube.KP(findex,26)~= -1 && ube.KP(findex,29) ~= -1 %Neck_nose
    line(axe,ube.KP(findex,[26 29]),ube.KP(findex,[27 30]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,26)~= -1 && ube.KP(findex,20) ~= -1 %Neck_Lsh
    line(axe,ube.KP(findex,[26 20]),ube.KP(findex,[27 21]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,26)~= -1 && ube.KP(findex,50) ~= -1 %Neck_Rsh
    line(axe,ube.KP(findex,[26 50]),ube.KP(findex,[27 51]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,26)~= -1 && ube.KP(findex,14) ~= -1 %Neck_LHip
    line(axe,ube.KP(findex,[26 14]),ube.KP(findex,[27 15]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,26)~= -1 && ube.KP(findex,20) ~= -1 %Neck_Lsh
    line(axe,ube.KP(findex,[26 20]),ube.KP(findex,[27 21]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,26)~= -1 && ube.KP(findex,44) ~= -1 %Neck_RHip
    line(axe,ube.KP(findex,[26 44]),ube.KP(findex,[27 45]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,47)~= -1 && ube.KP(findex,44) ~= -1 %RHip_RKne
    line(axe,ube.KP(findex,[47 44]),ube.KP(findex,[48 45]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,32)~= -1 && ube.KP(findex,47) ~= -1 %RKnw_Rank
    line(axe,ube.KP(findex,[32 47]),ube.KP(findex,[33 48]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,17)~= -1 && ube.KP(findex,14) ~= -1 %LHip_LKne
    line(axe,ube.KP(findex,[17 14]),ube.KP(findex,[18 15]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,17)~= -1 && ube.KP(findex,2) ~= -1 %LKne_Lank
    line(axe,ube.KP(findex,[17 2]),ube.KP(findex,[18 3]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,8)~= -1 && ube.KP(findex,20) ~= -1 %Lsh_Lelb
    line(axe,ube.KP(findex,[8 20]),ube.KP(findex,[9 21]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,8)~= -1 && ube.KP(findex,23) ~= -1 %Lelb_Lwri
    line(axe,ube.KP(findex,[8 23]),ube.KP(findex,[9 24]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,38)~= -1 && ube.KP(findex,50) ~= -1 %Rsh_Relb
    line(axe,ube.KP(findex,[38 50]),ube.KP(findex,[39 51]),'LineWidth',LiW,'Color',Col);
end
if ube.KP(findex,38)~= -1 && ube.KP(findex,53) ~= -1 %Relb_Rwri
    line(axe,ube.KP(findex,[38 53]),ube.KP(findex,[39 54]),'LineWidth',LiW,'Color',Col);
end
%% 
if ube.KP(findex,26)~= -1 %Neck
    rectangle(axe,'Position', [ube.KP(findex,[26 27])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,29)~= -1 %Nose
    rectangle(axe,'Position', [ube.KP(findex,[29 30])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,20)~= -1 %Lsh
    rectangle(axe,'Position', [ube.KP(findex,[20 21])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,50)~= -1 %Rsh
    rectangle(axe,'Position', [ube.KP(findex,[50 51])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,14)~= -1 %Lhip
    rectangle(axe,'Position', [ube.KP(findex,[14 15])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,44)~= -1 %Rhip
    rectangle(axe,'Position', [ube.KP(findex,[44 45])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,47)~= -1 %Rkne
    rectangle(axe,'Position', [ube.KP(findex,[47 48])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,17)~= -1 %Lkne
    rectangle(axe,'Position', [ube.KP(findex,[17 18])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,8)~= -1 %Lelb
    rectangle(axe,'Position', [ube.KP(findex,[8 9])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end
if ube.KP(findex,38)~= -1 %Relb
    rectangle(axe,'Position', [ube.KP(findex,[38 39])-3 6 6],'Curvature',cuv,'LineWidth',LiW,'EdgeColor',Col);
end

