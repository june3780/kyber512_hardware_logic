module selector_zeta(i_cnt_stage, i_cnt_num, o_first, o_second, o_zeta);

       input        [2:0] i_cnt_stage;
       input        [6:0] i_cnt_num;
       output     reg   [7:0] o_first;
       output     reg   [7:0] o_second;
       output     reg   [11:0] o_zeta;


   always @(*)
   begin
      case(i_cnt_stage)
      3'd0:    
        begin
            o_first = i_cnt_num;   
                o_second = i_cnt_num+128;   
                o_zeta = 1201;
        end

      3'd1:
         if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+64;
                o_zeta = 1434;
            end   
         else
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+128;
                o_zeta = 2610;
            end
      
      3'd2:   
         if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+32;
                o_zeta = 2382;
            end   
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+64;
                o_zeta = 505;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+96;
                o_zeta = 226;
            end
         else
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+128;
                o_zeta = 1261;
            end

      3'd3: 
         if(i_cnt_num < 16)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+16;
                o_zeta = 2278;
            end   
         else if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+32;
                o_zeta = 455;
            end
         else if(i_cnt_num < 48)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+48;
                o_zeta = 1555;
            end
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+48;   
                o_second = i_cnt_num+64;
                o_zeta = 2092;
            end
         else if(i_cnt_num < 80)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+80;
                o_zeta = 2973;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+80;   
                o_second = i_cnt_num+96;
                o_zeta = 341;
            end
         else if(i_cnt_num < 112)
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+112;
                o_zeta = 324;
            end
         else
            begin
                o_first = i_cnt_num+112;   
                o_second = i_cnt_num+128;
                o_zeta = 924;
            end


      3'd4:
        if(i_cnt_num < 8)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+8;
                o_zeta = 660;
            end   
        else if(i_cnt_num < 16)
           begin
               o_first = i_cnt_num+8;   
                o_second = i_cnt_num+16;
                o_zeta = 2622;
           end
        else if(i_cnt_num < 24)
           begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+24;
                o_zeta = 1681;
           end
        else if(i_cnt_num < 32)
           begin
               o_first = i_cnt_num+24;   
                o_second = i_cnt_num+32;
                o_zeta = 232;
           end
        else if(i_cnt_num < 40)
           begin
               o_first = i_cnt_num+32;   
                o_second = i_cnt_num+40;
                o_zeta = 2653;
           end
        else if(i_cnt_num < 48)
           begin
               o_first = i_cnt_num+40;   
                o_second = i_cnt_num+48;
                o_zeta = 3004;
           end
        else if(i_cnt_num < 56)
           begin
               o_first = i_cnt_num+48;   
                o_second = i_cnt_num+56;
                o_zeta = 316;
           end
        else if(i_cnt_num < 64)
           begin
               o_first = i_cnt_num+56;   
                o_second = i_cnt_num+64;
                o_zeta = 408;
           end
        else if(i_cnt_num < 72)
           begin
               o_first = i_cnt_num+64;   
                o_second = i_cnt_num+72;
                o_zeta = 1830;
           end   
        else if(i_cnt_num < 80)
           begin
               o_first = i_cnt_num+72;   
                o_second = i_cnt_num+80;
                o_zeta = 1520;
           end
        else if(i_cnt_num < 88)
           begin
               o_first = i_cnt_num+80;   
                o_second = i_cnt_num+88;
                o_zeta = 878;
           end
        else if(i_cnt_num < 96)
           begin
               o_first = i_cnt_num+88;   
                o_second = i_cnt_num+96;
                o_zeta = 38;
           end
        else if(i_cnt_num < 104)
           begin
               o_first = i_cnt_num+96;   
                o_second = i_cnt_num+104;
                o_zeta = 1152;
           end
        else if(i_cnt_num < 112)
           begin
               o_first = i_cnt_num+104;   
                o_second = i_cnt_num+112;
                o_zeta = 1066;
           end
        else if(i_cnt_num < 120)
           begin
               o_first = i_cnt_num+112;   
                o_second = i_cnt_num+120;
                o_zeta = 2692;
           end
        else
           begin
               o_first = i_cnt_num+120;   
                o_second = i_cnt_num+128;
                o_zeta = 526;
           end

      3'd5:
         if(i_cnt_num < 4)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+4;
                o_zeta = 1949;
            end   
         else if(i_cnt_num < 8)
            begin
                o_first = i_cnt_num+4;   
                o_second = i_cnt_num+8;
                o_zeta = 873;
            end
         else if(i_cnt_num < 12)
            begin
                o_first = i_cnt_num+8;   
                o_second = i_cnt_num+12;
                o_zeta = 1630;
            end
         else if(i_cnt_num < 16)
            begin
                o_first = i_cnt_num+12;   
                o_second = i_cnt_num+16;
                o_zeta = 1936;
            end
         else if(i_cnt_num < 20)
            begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+20;
                o_zeta = 2624;
            end
         else if(i_cnt_num < 24)
            begin
                o_first = i_cnt_num+20;   
                o_second = i_cnt_num+24;
                o_zeta = 2798;
            end
         else if(i_cnt_num < 28)
            begin
                o_first = i_cnt_num+24;   
                o_second = i_cnt_num+28;
                o_zeta = 2063;
            end
         else if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num+28;   
                o_second = i_cnt_num+32;
                o_zeta = 1568;
            end
         else if(i_cnt_num < 36)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+36;
                o_zeta = 2529;
            end   
         else if(i_cnt_num < 40)
            begin
                o_first = i_cnt_num+36;   
                o_second = i_cnt_num+40;
                o_zeta = 1664;
            end
         else if(i_cnt_num < 44)
            begin
                o_first = i_cnt_num+40;   
                o_second = i_cnt_num+44;
                o_zeta = 3309;
            end
         else if(i_cnt_num < 48)
            begin
                o_first = i_cnt_num+44;   
                o_second = i_cnt_num+48;
                o_zeta = 2039;
            end
         else if(i_cnt_num < 52)
            begin
                o_first = i_cnt_num+48;   
                o_second = i_cnt_num+52;
                o_zeta = 315;
            end
         else if(i_cnt_num < 56)
            begin
                o_first = i_cnt_num+52;   
                o_second = i_cnt_num+56;
                o_zeta = 2008;
            end
         else if(i_cnt_num < 60)
            begin
                o_first = i_cnt_num+56;   
                o_second = i_cnt_num+60;
                o_zeta = 424;
            end
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+60;   
                o_second = i_cnt_num+64;
                o_zeta = 716;
            end
         else if(i_cnt_num < 68)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+68;
                o_zeta = 987;
            end   
         else if(i_cnt_num < 72)
            begin
                o_first = i_cnt_num+68;   
                o_second = i_cnt_num+72;
                o_zeta = 2075;
            end
         else if(i_cnt_num < 76)
            begin
                o_first = i_cnt_num+72;   
                o_second = i_cnt_num+76;
                o_zeta = 3104;
            end
         else if(i_cnt_num < 80)
            begin
                o_first = i_cnt_num+76;   
                o_second = i_cnt_num+80;
                o_zeta = 468;
            end
         else if(i_cnt_num < 84)
            begin
                o_first = i_cnt_num+80;   
                o_second = i_cnt_num+84;
                o_zeta = 1047;
            end
         else if(i_cnt_num < 88)
            begin
                o_first = i_cnt_num+84;   
                o_second = i_cnt_num+88;
                o_zeta = 2616;
            end
         else if(i_cnt_num < 92)
            begin
                o_first = i_cnt_num+88;
                o_second = i_cnt_num+92;
                o_zeta = 1441;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+92;   
                o_second = i_cnt_num+96;
                o_zeta = 1397;
            end
         else if(i_cnt_num < 100)
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+100;
                o_zeta = 2888;
            end   
         else if(i_cnt_num < 104)
            begin
                o_first = i_cnt_num+100;   
                o_second = i_cnt_num+104;
                o_zeta = 3181;
            end
         else if(i_cnt_num < 108)
            begin
                o_first = i_cnt_num+104;   
                o_second = i_cnt_num+108;
                o_zeta = 738;
            end
         else if(i_cnt_num < 112)
            begin
                o_first = i_cnt_num+108;   
                o_second = i_cnt_num+112;
                o_zeta = 995;
            end
         else if(i_cnt_num < 116)
            begin
                o_first = i_cnt_num+112;   
                o_second = i_cnt_num+116;
                o_zeta = 28;
            end
         else if(i_cnt_num < 120)
            begin
                o_first = i_cnt_num+116;   
                o_second = i_cnt_num+120;
                o_zeta = 1806;
            end
         else if(i_cnt_num < 124)
            begin
                o_first = i_cnt_num+120;   
                o_second = i_cnt_num+124;
                o_zeta = 2331;
            end
         else
            begin
                o_first = i_cnt_num+124;   
                o_second = i_cnt_num+128;
                o_zeta = 2209;
            end

      3'd6:
         if(i_cnt_num < 2)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+2;
                o_zeta = 3052;
            end   
         else if(i_cnt_num < 4)
            begin
                o_first = i_cnt_num+2;   
                o_second = i_cnt_num+4;
                o_zeta = 443;
            end
         else if(i_cnt_num < 6)
            begin
                o_first = i_cnt_num+4;   
                o_second = i_cnt_num+6;
                o_zeta = 1075;
            end
         else if(i_cnt_num < 8)
            begin
                o_first = i_cnt_num+6;   
                o_second = i_cnt_num+8;
                o_zeta = 1093;
            end
         else if(i_cnt_num < 10)
            begin
                o_first = i_cnt_num+8;   
                o_second = i_cnt_num+10;
                o_zeta = 546;
            end
         else if(i_cnt_num < 12)
            begin
                o_first = i_cnt_num+10;   
                o_second = i_cnt_num+12;
                o_zeta = 1927;
            end
         else if(i_cnt_num < 14)
            begin
                o_first = i_cnt_num+12;   
                o_second = i_cnt_num+14;
                o_zeta = 513;
            end
         else if(i_cnt_num < 16)
            begin
                o_first = i_cnt_num+14;   
                o_second = i_cnt_num+16;
                o_zeta = 1463;
            end
         else if(i_cnt_num < 18)
            begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+18;
                o_zeta = 2107;
            end   
         else if(i_cnt_num < 20)
            begin
                o_first = i_cnt_num+18;   
                o_second = i_cnt_num+20;
                o_zeta = 1077;
            end
         else if(i_cnt_num < 22)
            begin
                o_first = i_cnt_num+20;   
                o_second = i_cnt_num+22;
                o_zeta = 3132;
            end
         else if(i_cnt_num < 24)
            begin
                o_first = i_cnt_num+22;   
                o_second = i_cnt_num+24;
                o_zeta = 2274;
            end
         else if(i_cnt_num < 26)
            begin
                o_first = i_cnt_num+24;   
                o_second = i_cnt_num+26;
                o_zeta = 606;
            end
         else if(i_cnt_num < 28)
            begin
                o_first = i_cnt_num+26;   
                o_second = i_cnt_num+28;
                o_zeta = 2468;
            end
         else if(i_cnt_num < 30)
            begin
                o_first = i_cnt_num+28;   
                o_second = i_cnt_num+30;
                o_zeta = 2179;
            end
         else if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num+30;   
                o_second = i_cnt_num+32;
                o_zeta = 2392;
            end
         else if(i_cnt_num < 34)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+34;
                o_zeta = 1233;
            end   
         else if(i_cnt_num < 36)
            begin
                o_first = i_cnt_num+34;   
                o_second = i_cnt_num+36;
                o_zeta = 1297;
            end
         else if(i_cnt_num < 38)
            begin
                o_first = i_cnt_num+36;   
                o_second = i_cnt_num+38;
                o_zeta = 1945;
            end
         else if(i_cnt_num < 40)
            begin
                o_first = i_cnt_num+38;   
                o_second = i_cnt_num+40;
                o_zeta = 615;
            end
         else if(i_cnt_num < 42)
            begin
                o_first = i_cnt_num+40;   
                o_second = i_cnt_num+42;
                o_zeta = 1824;
            end
         else if(i_cnt_num < 44)
            begin
                o_first = i_cnt_num+42;   
                o_second = i_cnt_num+44;
                o_zeta = 1133;
            end
         else if(i_cnt_num < 46)
            begin
                o_first = i_cnt_num+44;   
                o_second = i_cnt_num+46;
                o_zeta = 2043;
            end
         else if(i_cnt_num < 48)
            begin
                o_first = i_cnt_num+46;   
                o_second = i_cnt_num+48;
                o_zeta = 278;
            end
         else if(i_cnt_num < 50)
            begin
                o_first = i_cnt_num+48;   
                o_second = i_cnt_num+50;
                o_zeta = 1149;
            end   
         else if(i_cnt_num < 52)
            begin
                o_first = i_cnt_num+50;   
                o_second = i_cnt_num+52;
                o_zeta = 2537;
            end
         else if(i_cnt_num < 54)
            begin
                o_first = i_cnt_num+52;   
                o_second = i_cnt_num+54;
                o_zeta = 1610;
            end
         else if(i_cnt_num < 56)
            begin
                o_first = i_cnt_num+54;   
                o_second = i_cnt_num+56;
                o_zeta = 646;
            end
         else if(i_cnt_num < 58)
            begin
                o_first = i_cnt_num+56;   
                o_second = i_cnt_num+58;
                o_zeta = 2939;
            end
         else if(i_cnt_num < 60)
            begin
                o_first = i_cnt_num+58;   
                o_second = i_cnt_num+60;
                o_zeta = 1477;
            end
         else if(i_cnt_num < 62)
            begin
                o_first = i_cnt_num+60;   
                o_second = i_cnt_num+62;
                o_zeta = 2487;
            end
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+62;   
                o_second = i_cnt_num+64;
                o_zeta = 2284;
            end
         else if(i_cnt_num < 66)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+66;
                o_zeta = 3172;
            end   
         else if(i_cnt_num < 68)
            begin
                o_first = i_cnt_num+66;   
                o_second = i_cnt_num+68;
                o_zeta = 1525;
            end
         else if(i_cnt_num < 70)
            begin
                o_first = i_cnt_num+68;   
                o_second = i_cnt_num+70;
                o_zeta = 1078;
            end
         else if(i_cnt_num < 72)
            begin
                o_first = i_cnt_num+70;   
                o_second = i_cnt_num+72;
                o_zeta = 2951;
            end
         else if(i_cnt_num < 74)
            begin
                o_first = i_cnt_num+72;   
                o_second = i_cnt_num+74;
                o_zeta = 1331;
            end
         else if(i_cnt_num < 76)
            begin
                o_first = i_cnt_num+74;   
                o_second = i_cnt_num+76;
                o_zeta = 960;
            end
         else if(i_cnt_num < 78)
            begin
                o_first = i_cnt_num+76;   
                o_second = i_cnt_num+78;
                o_zeta = 1781;
            end
         else if(i_cnt_num < 80)
            begin
                o_first = i_cnt_num+78;   
                o_second = i_cnt_num+80;
                o_zeta = 24;
            end
         else if(i_cnt_num < 82)
            begin
                o_first = i_cnt_num+80;   
                o_second = i_cnt_num+82;
                o_zeta = 3045;
            end   
         else if(i_cnt_num < 84)
            begin
                o_first = i_cnt_num+82;   
                o_second = i_cnt_num+84;
                o_zeta = 1656;
            end
         else if(i_cnt_num < 86)
            begin
                o_first = i_cnt_num+84;   
                o_second = i_cnt_num+86;
                o_zeta = 2989;
            end
         else if(i_cnt_num < 88)
            begin
                o_first = i_cnt_num+86;   
                o_second = i_cnt_num+88;
                o_zeta = 1373;
            end
         else if(i_cnt_num < 90)
            begin
                o_first = i_cnt_num+88;   
                o_second = i_cnt_num+90;
                o_zeta = 2026;
            end
         else if(i_cnt_num < 92)
            begin
                o_first = i_cnt_num+90;   
                o_second = i_cnt_num+92;
                o_zeta = 846;
            end
         else if(i_cnt_num < 94)
            begin
                o_first = i_cnt_num+92;   
                o_second = i_cnt_num+94;
                o_zeta = 550;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+94;   
                o_second = i_cnt_num+96;
                o_zeta = 2185;
            end
         else if(i_cnt_num < 98)
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+98;
                o_zeta = 134;
            end   
         else if(i_cnt_num < 100)
            begin
                o_first = i_cnt_num+98;   
                o_second = i_cnt_num+100;
                o_zeta = 1985;
            end
         else if(i_cnt_num < 102)
            begin
                o_first = i_cnt_num+100;   
                o_second = i_cnt_num+102;
                o_zeta = 2833;
            end
         else if(i_cnt_num < 104)
            begin
                o_first = i_cnt_num+102;   
                o_second = i_cnt_num+104;
                o_zeta = 1298;
            end
         else if(i_cnt_num < 106)
            begin
                o_first = i_cnt_num+104;   
                o_second = i_cnt_num+106;
                o_zeta = 1154;
            end
         else if(i_cnt_num < 108)
            begin
                o_first = i_cnt_num+106;   
                o_second = i_cnt_num+108;
                o_zeta = 1195;
            end
         else if(i_cnt_num < 110)
            begin
                o_first = i_cnt_num+108;   
                o_second = i_cnt_num+110;
                o_zeta = 1194;
            end
         else if(i_cnt_num < 112)
            begin
                o_first = i_cnt_num+110;   
                o_second = i_cnt_num+112;
                o_zeta = 446;
            end
         else if(i_cnt_num < 114)
            begin
                o_first = i_cnt_num+112;   
                o_second = i_cnt_num+114;
                o_zeta = 2490;
            end   
         else if(i_cnt_num < 116)
            begin
                o_first = i_cnt_num+114;   
                o_second = i_cnt_num+116;
                o_zeta = 813;
            end
         else if(i_cnt_num < 118)
            begin
                o_first = i_cnt_num+116;   
                o_second = i_cnt_num+118;
                o_zeta = 2559;
            end
         else if(i_cnt_num < 120)
            begin
                o_first = i_cnt_num+118;   
                o_second = i_cnt_num+120;
                o_zeta = 270;
            end
         else if(i_cnt_num < 122)
            begin
                o_first = i_cnt_num+120;   
                o_second = i_cnt_num+122;
                o_zeta = 476;
            end
         else if(i_cnt_num < 124)
            begin
                o_first = i_cnt_num+122;   
                o_second = i_cnt_num+124;
                o_zeta = 741;
            end
         else if(i_cnt_num < 126)
            begin
                o_first = i_cnt_num+124;   
                o_second = i_cnt_num+126;
                o_zeta = 3008;
            end
         else
            begin
                o_first = i_cnt_num+126;   
                o_second = i_cnt_num+128;
                o_zeta = 934;
            end
    
      default:
         begin
            o_first = 0;   
            o_second = 0;
            o_zeta = 0;
         end
      endcase
   end
   

    

endmodule
