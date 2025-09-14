module selector(i_cnt_stage, i_cnt_num, o_first, o_second);

       input        [2:0] i_cnt_stage;
       input        [6:0] i_cnt_num;
       output     reg   [7:0] o_first;
       output     reg   [7:0] o_second;


   always @(*)
   begin
      case(i_cnt_stage)
      3'd0:    
        begin
            o_first = i_cnt_num;   
                o_second = i_cnt_num+128;   
        end

      3'd1:
         if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+64;
            end   
         else
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+128;
            end
      
      3'd2:   
         if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+32;
            end   
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+64;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+96;
            end
         else
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+128;
            end

      3'd3: 
         if(i_cnt_num < 16)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+16;
            end   
         else if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+32;
            end
         else if(i_cnt_num < 48)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+48;
            end
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+48;   
                o_second = i_cnt_num+64;
            end
         else if(i_cnt_num < 80)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+80;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+80;   
                o_second = i_cnt_num+96;
            end
         else if(i_cnt_num < 112)
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+112;
            end
         else
            begin
                o_first = i_cnt_num+112;   
                o_second = i_cnt_num+128;
            end


      3'd4:
        if(i_cnt_num < 8)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+8;
            end   
        else if(i_cnt_num < 16)
           begin
               o_first = i_cnt_num+8;   
                o_second = i_cnt_num+16;
           end
        else if(i_cnt_num < 24)
           begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+24;
           end
        else if(i_cnt_num < 32)
           begin
               o_first = i_cnt_num+24;   
                o_second = i_cnt_num+32;
           end
        else if(i_cnt_num < 40)
           begin
               o_first = i_cnt_num+32;   
                o_second = i_cnt_num+40;
           end
        else if(i_cnt_num < 48)
           begin
               o_first = i_cnt_num+40;   
                o_second = i_cnt_num+48;
           end
        else if(i_cnt_num < 56)
           begin
               o_first = i_cnt_num+48;   
                o_second = i_cnt_num+56;
           end
        else if(i_cnt_num < 64)
           begin
               o_first = i_cnt_num+56;   
                o_second = i_cnt_num+64;
           end
        else if(i_cnt_num < 72)
           begin
               o_first = i_cnt_num+64;   
                o_second = i_cnt_num+72;
           end   
        else if(i_cnt_num < 80)
           begin
               o_first = i_cnt_num+72;   
                o_second = i_cnt_num+80;
           end
        else if(i_cnt_num < 88)
           begin
               o_first = i_cnt_num+80;   
                o_second = i_cnt_num+88;
           end
        else if(i_cnt_num < 96)
           begin
               o_first = i_cnt_num+88;   
                o_second = i_cnt_num+96;
           end
        else if(i_cnt_num < 104)
           begin
               o_first = i_cnt_num+96;   
                o_second = i_cnt_num+104;
           end
        else if(i_cnt_num < 112)
           begin
               o_first = i_cnt_num+104;   
                o_second = i_cnt_num+112;
           end
        else if(i_cnt_num < 120)
           begin
               o_first = i_cnt_num+112;   
                o_second = i_cnt_num+120;
           end
        else
           begin
               o_first = i_cnt_num+120;   
                o_second = i_cnt_num+128;
           end

      3'd5:
         if(i_cnt_num < 4)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+4;
            end   
         else if(i_cnt_num < 8)
            begin
                o_first = i_cnt_num+4;   
                o_second = i_cnt_num+8;
            end
         else if(i_cnt_num < 12)
            begin
                o_first = i_cnt_num+8;   
                o_second = i_cnt_num+12;
            end
         else if(i_cnt_num < 16)
            begin
                o_first = i_cnt_num+12;   
                o_second = i_cnt_num+16;
            end
         else if(i_cnt_num < 20)
            begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+20;
            end
         else if(i_cnt_num < 24)
            begin
                o_first = i_cnt_num+20;   
                o_second = i_cnt_num+24;
            end
         else if(i_cnt_num < 28)
            begin
                o_first = i_cnt_num+24;   
                o_second = i_cnt_num+28;
            end
         else if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num+28;   
                o_second = i_cnt_num+32;
            end
         else if(i_cnt_num < 36)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+36;
            end   
         else if(i_cnt_num < 40)
            begin
                o_first = i_cnt_num+36;   
                o_second = i_cnt_num+40;
            end
         else if(i_cnt_num < 44)
            begin
                o_first = i_cnt_num+40;   
                o_second = i_cnt_num+44;
            end
         else if(i_cnt_num < 48)
            begin
                o_first = i_cnt_num+44;   
                o_second = i_cnt_num+48;
            end
         else if(i_cnt_num < 52)
            begin
                o_first = i_cnt_num+48;   
                o_second = i_cnt_num+52;
            end
         else if(i_cnt_num < 56)
            begin
                o_first = i_cnt_num+52;   
                o_second = i_cnt_num+56;
            end
         else if(i_cnt_num < 60)
            begin
                o_first = i_cnt_num+56;   
                o_second = i_cnt_num+60;
            end
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+60;   
                o_second = i_cnt_num+64;
            end
         else if(i_cnt_num < 68)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+68;
            end   
         else if(i_cnt_num < 72)
            begin
                o_first = i_cnt_num+68;   
                o_second = i_cnt_num+72;
            end
         else if(i_cnt_num < 76)
            begin
                o_first = i_cnt_num+72;   
                o_second = i_cnt_num+76;
            end
         else if(i_cnt_num < 80)
            begin
                o_first = i_cnt_num+76;   
                o_second = i_cnt_num+80;
            end
         else if(i_cnt_num < 84)
            begin
                o_first = i_cnt_num+80;   
                o_second = i_cnt_num+84;
            end
         else if(i_cnt_num < 88)
            begin
                o_first = i_cnt_num+84;   
                o_second = i_cnt_num+88;
            end
         else if(i_cnt_num < 92)
            begin
                o_first = i_cnt_num+88;   
                o_second = i_cnt_num+92;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+92;   
                o_second = i_cnt_num+96;
            end
         else if(i_cnt_num < 100)
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+100;
            end   
         else if(i_cnt_num < 104)
            begin
                o_first = i_cnt_num+100;   
                o_second = i_cnt_num+104;
            end
         else if(i_cnt_num < 108)
            begin
                o_first = i_cnt_num+104;   
                o_second = i_cnt_num+108;
            end
         else if(i_cnt_num < 112)
            begin
                o_first = i_cnt_num+108;   
                o_second = i_cnt_num+112;
            end
         else if(i_cnt_num < 116)
            begin
                o_first = i_cnt_num+112;   
                o_second = i_cnt_num+116;
            end
         else if(i_cnt_num < 120)
            begin
                o_first = i_cnt_num+116;   
                o_second = i_cnt_num+120;
            end
         else if(i_cnt_num < 124)
            begin
                o_first = i_cnt_num+120;   
                o_second = i_cnt_num+124;
            end
         else
            begin
                o_first = i_cnt_num+124;   
                o_second = i_cnt_num+128;
            end

      3'd6:
         if(i_cnt_num < 2)
            begin
                o_first = i_cnt_num;   
                o_second = i_cnt_num+2;
            end   
         else if(i_cnt_num < 4)
            begin
                o_first = i_cnt_num+2;   
                o_second = i_cnt_num+4;
            end
         else if(i_cnt_num < 6)
            begin
                o_first = i_cnt_num+4;   
                o_second = i_cnt_num+6;
            end
         else if(i_cnt_num < 8)
            begin
                o_first = i_cnt_num+6;   
                o_second = i_cnt_num+8;
            end
         else if(i_cnt_num < 10)
            begin
                o_first = i_cnt_num+8;   
                o_second = i_cnt_num+10;
            end
         else if(i_cnt_num < 12)
            begin
                o_first = i_cnt_num+10;   
                o_second = i_cnt_num+12;
            end
         else if(i_cnt_num < 14)
            begin
                o_first = i_cnt_num+12;   
                o_second = i_cnt_num+14;
            end
         else if(i_cnt_num < 16)
            begin
                o_first = i_cnt_num+14;   
                o_second = i_cnt_num+16;
            end
         else if(i_cnt_num < 18)
            begin
                o_first = i_cnt_num+16;   
                o_second = i_cnt_num+18;
            end   
         else if(i_cnt_num < 20)
            begin
                o_first = i_cnt_num+18;   
                o_second = i_cnt_num+20;
            end
         else if(i_cnt_num < 22)
            begin
                o_first = i_cnt_num+20;   
                o_second = i_cnt_num+22;
            end
         else if(i_cnt_num < 24)
            begin
                o_first = i_cnt_num+22;   
                o_second = i_cnt_num+24;
            end
         else if(i_cnt_num < 26)
            begin
                o_first = i_cnt_num+24;   
                o_second = i_cnt_num+26;
            end
         else if(i_cnt_num < 28)
            begin
                o_first = i_cnt_num+26;   
                o_second = i_cnt_num+28;
            end
         else if(i_cnt_num < 30)
            begin
                o_first = i_cnt_num+28;   
                o_second = i_cnt_num+30;
            end
         else if(i_cnt_num < 32)
            begin
                o_first = i_cnt_num+30;   
                o_second = i_cnt_num+32;
            end
         else if(i_cnt_num < 34)
            begin
                o_first = i_cnt_num+32;   
                o_second = i_cnt_num+34;
            end   
         else if(i_cnt_num < 36)
            begin
                o_first = i_cnt_num+34;   
                o_second = i_cnt_num+36;
            end
         else if(i_cnt_num < 38)
            begin
                o_first = i_cnt_num+36;   
                o_second = i_cnt_num+38;
            end
         else if(i_cnt_num < 40)
            begin
                o_first = i_cnt_num+38;   
                o_second = i_cnt_num+40;
            end
         else if(i_cnt_num < 42)
            begin
                o_first = i_cnt_num+40;   
                o_second = i_cnt_num+42;
            end
         else if(i_cnt_num < 44)
            begin
                o_first = i_cnt_num+42;   
                o_second = i_cnt_num+44;
            end
         else if(i_cnt_num < 46)
            begin
                o_first = i_cnt_num+44;   
                o_second = i_cnt_num+46;
            end
         else if(i_cnt_num < 48)
            begin
                o_first = i_cnt_num+46;   
                o_second = i_cnt_num+48;
            end
         else if(i_cnt_num < 50)
            begin
                o_first = i_cnt_num+48;   
                o_second = i_cnt_num+50;
            end   
         else if(i_cnt_num < 52)
            begin
                o_first = i_cnt_num+50;   
                o_second = i_cnt_num+52;
            end
         else if(i_cnt_num < 54)
            begin
                o_first = i_cnt_num+52;   
                o_second = i_cnt_num+54;
            end
         else if(i_cnt_num < 56)
            begin
                o_first = i_cnt_num+54;   
                o_second = i_cnt_num+56;
            end
         else if(i_cnt_num < 58)
            begin
                o_first = i_cnt_num+56;   
                o_second = i_cnt_num+58;
            end
         else if(i_cnt_num < 60)
            begin
                o_first = i_cnt_num+58;   
                o_second = i_cnt_num+60;
            end
         else if(i_cnt_num < 62)
            begin
                o_first = i_cnt_num+60;   
                o_second = i_cnt_num+62;
            end
         else if(i_cnt_num < 64)
            begin
                o_first = i_cnt_num+62;   
                o_second = i_cnt_num+64;
            end
         else if(i_cnt_num < 66)
            begin
                o_first = i_cnt_num+64;   
                o_second = i_cnt_num+66;
            end   
         else if(i_cnt_num < 68)
            begin
                o_first = i_cnt_num+66;   
                o_second = i_cnt_num+68;
            end
         else if(i_cnt_num < 70)
            begin
                o_first = i_cnt_num+68;   
                o_second = i_cnt_num+70;
            end
         else if(i_cnt_num < 72)
            begin
                o_first = i_cnt_num+70;   
                o_second = i_cnt_num+72;
            end
         else if(i_cnt_num < 74)
            begin
                o_first = i_cnt_num+72;   
                o_second = i_cnt_num+74;
            end
         else if(i_cnt_num < 76)
            begin
                o_first = i_cnt_num+74;   
                o_second = i_cnt_num+76;
            end
         else if(i_cnt_num < 78)
            begin
                o_first = i_cnt_num+76;   
                o_second = i_cnt_num+78;
            end
         else if(i_cnt_num < 80)
            begin
                o_first = i_cnt_num+78;   
                o_second = i_cnt_num+80;
            end
         else if(i_cnt_num < 82)
            begin
                o_first = i_cnt_num+80;   
                o_second = i_cnt_num+82;
            end   
         else if(i_cnt_num < 84)
            begin
                o_first = i_cnt_num+82;   
                o_second = i_cnt_num+84;
            end
         else if(i_cnt_num < 86)
            begin
                o_first = i_cnt_num+84;   
                o_second = i_cnt_num+86;
            end
         else if(i_cnt_num < 88)
            begin
                o_first = i_cnt_num+86;   
                o_second = i_cnt_num+88;
            end
         else if(i_cnt_num < 90)
            begin
                o_first = i_cnt_num+88;   
                o_second = i_cnt_num+90;
            end
         else if(i_cnt_num < 92)
            begin
                o_first = i_cnt_num+90;   
                o_second = i_cnt_num+92;
            end
         else if(i_cnt_num < 94)
            begin
                o_first = i_cnt_num+92;   
                o_second = i_cnt_num+94;
            end
         else if(i_cnt_num < 96)
            begin
                o_first = i_cnt_num+94;   
                o_second = i_cnt_num+96;
            end
         else if(i_cnt_num < 98)
            begin
                o_first = i_cnt_num+96;   
                o_second = i_cnt_num+98;
            end   
         else if(i_cnt_num < 100)
            begin
                o_first = i_cnt_num+98;   
                o_second = i_cnt_num+100;
            end
         else if(i_cnt_num < 102)
            begin
                o_first = i_cnt_num+100;   
                o_second = i_cnt_num+102;
            end
         else if(i_cnt_num < 104)
            begin
                o_first = i_cnt_num+102;   
                o_second = i_cnt_num+104;
            end
         else if(i_cnt_num < 106)
            begin
                o_first = i_cnt_num+104;   
                o_second = i_cnt_num+106;
            end
         else if(i_cnt_num < 108)
            begin
                o_first = i_cnt_num+106;   
                o_second = i_cnt_num+108;
            end
         else if(i_cnt_num < 110)
            begin
                o_first = i_cnt_num+108;   
                o_second = i_cnt_num+110;
            end
         else if(i_cnt_num < 112)
            begin
                o_first = i_cnt_num+110;   
                o_second = i_cnt_num+112;
            end
         else if(i_cnt_num < 114)
            begin
                o_first = i_cnt_num+112;   
                o_second = i_cnt_num+114;
            end   
         else if(i_cnt_num < 116)
            begin
                o_first = i_cnt_num+114;   
                o_second = i_cnt_num+116;
            end
         else if(i_cnt_num < 118)
            begin
                o_first = i_cnt_num+116;   
                o_second = i_cnt_num+118;
            end
         else if(i_cnt_num < 120)
            begin
                o_first = i_cnt_num+118;   
                o_second = i_cnt_num+120;
            end
         else if(i_cnt_num < 122)
            begin
                o_first = i_cnt_num+120;   
                o_second = i_cnt_num+122;
            end
         else if(i_cnt_num < 124)
            begin
                o_first = i_cnt_num+122;   
                o_second = i_cnt_num+124;
            end
         else if(i_cnt_num < 126)
            begin
                o_first = i_cnt_num+124;   
                o_second = i_cnt_num+126;
            end
         else
            begin
                o_first = i_cnt_num+126;   
                o_second = i_cnt_num+128;
            end
    
      default:
         begin
            o_first = 0;   
            o_second = 0;
         end
      endcase
   end
   

    

endmodule
