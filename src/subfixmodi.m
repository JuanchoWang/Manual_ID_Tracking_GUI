function subfix = subfixmodi(pnum)
typetag = '.png';
if pnum<10
    subfix = strcat('0000',int2str(pnum),typetag);
else
    if pnum<100
        subfix = strcat('000',int2str(pnum),typetag);
    else
        if pnum<1000
            subfix = strcat('00',int2str(pnum),typetag);
        else
            if pnum<10000
                subfix = strcat('0',int2str(pnum),typetag);
            else
                if pnum<100000
                    subfix = strcat(int2str(pnum),typetag);
                else
                    disp('The picture number is too big')
                end
            end
        end
    end
end