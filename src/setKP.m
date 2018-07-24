function KP_CVMLformat = setKP(KP_JSON)
KP_CVMLformat = zeros(1,54);
KP_CVMLformat(1:3:end) = 1;
KP_CVMLformat(2:3:end) = -1;
KP_CVMLformat(3:3:end) = -1;
for k = 3:3:51
    if KP_JSON(k) == 0
        continue
    end
    switch k
        case 48 %LAnkle
            KP_CVMLformat(2) = KP_JSON(46);
            KP_CVMLformat(3) = KP_JSON(47);
        case 12 %LEar
            KP_CVMLformat(5) = KP_JSON(10);
            KP_CVMLformat(6) = KP_JSON(11);
        case 24 %LElbow
            KP_CVMLformat(8) = KP_JSON(22);
            KP_CVMLformat(9) = KP_JSON(23);
        case 6 %LElbow
            KP_CVMLformat(11) = KP_JSON(4);
            KP_CVMLformat(12) = KP_JSON(5);
        case 36 %LHip
            KP_CVMLformat(14) = KP_JSON(34);
            KP_CVMLformat(15) = KP_JSON(35);
        case 42 %LKnee
            KP_CVMLformat(17) = KP_JSON(40);
            KP_CVMLformat(18) = KP_JSON(41);
            
        case 18 %LShoulder
            KP_CVMLformat(20) = KP_JSON(16);
            KP_CVMLformat(21) = KP_JSON(17);
        case 30 %LWrist
            KP_CVMLformat(23) = KP_JSON(28);
            KP_CVMLformat(24) = KP_JSON(29);
        case 3 %Nose
            KP_CVMLformat(29) = KP_JSON(1);
            KP_CVMLformat(30) = KP_JSON(2);
        case 51 %RAnkle
            KP_CVMLformat(32) = KP_JSON(49);
            KP_CVMLformat(33) = KP_JSON(50);
        case 15 %REar
            KP_CVMLformat(35) = KP_JSON(13);
            KP_CVMLformat(36) = KP_JSON(14);
            
        case 27 %RElbow
            KP_CVMLformat(38) = KP_JSON(25);
            KP_CVMLformat(39) = KP_JSON(26);
        case 9 %REye
            KP_CVMLformat(41) = KP_JSON(7);
            KP_CVMLformat(42) = KP_JSON(8);
        case 39 %RHip
            KP_CVMLformat(44) = KP_JSON(37);
            KP_CVMLformat(45) = KP_JSON(38);
        case 45 %Rknee
            KP_CVMLformat(47) = KP_JSON(43);
            KP_CVMLformat(48) = KP_JSON(44);
        case 21 %RShoulder
            KP_CVMLformat(50) = KP_JSON(19);
            KP_CVMLformat(51) = KP_JSON(20);
        case 33 %RWrist
            KP_CVMLformat(53) = KP_JSON(31);
            KP_CVMLformat(54) = KP_JSON(32);
    end
end
if KP_JSON(18) == 1 && KP_JSON(21) == 1 %Neck
    KP_CVMLformat(26) = (KP_JSON(16)+KP_JSON(19))/2;
    KP_CVMLformat(27) = (KP_JSON(17)+KP_JSON(20))/2;
end
