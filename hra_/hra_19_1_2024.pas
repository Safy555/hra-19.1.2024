program hra_19_1_2024;                 //Beginner-10min,9x9      95x30 konzola
uses crt, unit2;                              //Expert-99min,30x16
const maxsirka=30;maxvyska=20;         //Intermediate-40min,16x16
      suborc='subor.txt';
type Tpole=record
                 state,flag:boolean;
                 value:byte;
                 end;
    Tleaderboard=record
                 menoh:string[16];
                 beginner,intermediate,expert:integer;
                 end;
var
  ch:char;
  meno:string;
  i,flags,j,k,l,poc,stavhry,hracX,hracY:integer;
  p:array [0..maxvyska+1,0..maxsirka+1] of Tpole;
  subor:file of Tleaderboard;
  rebricek:Tleaderboard;
procedure generujminy(n,sirka,vyska:integer);  //generovanie min
var x,y:integer;
begin
  for i:=1 to n do begin
    repeat
      x:=random(sirka)+1;y:=random(vyska)+1;
    until p[y,x].value=0;
    p[y,x].value:=10
  end;
end;

procedure generujhru(pocetmin,vyska,sirka:integer);   //generovanie pola
begin
   //vynulovanie pola
   for i:=0 to vyska+1 do begin
    for j:=0 to sirka+1 do begin
      p[i,j].value:=0; p[i,j].state:=FALSE; p[i,j].flag:=FALSE;
    end;
   end;

   flags:=pocetmin;
   generujminy(pocetmin,sirka,vyska);

   for i:=1 to vyska do begin //ocislovanie pola
    for j:=1 to sirka do begin
      if p[i,j].value<>10 then begin
        if p[i-1,j-1].value=10 then p[i,j].value:=p[i,j].value+1;
        if p[i-1,j].value=10 then p[i,j].value:=p[i,j].value+1;
        if p[i-1,j+1].value=10 then p[i,j].value:=p[i,j].value+1;
        if p[i,j-1].value=10 then p[i,j].value:=p[i,j].value+1;
        if p[i,j+1].value=10 then p[i,j].value:=p[i,j].value+1;
        if p[i+1,j-1].value=10 then p[i,j].value:=p[i,j].value+1;
        if p[i+1,j].value=10 then p[i,j].value:=p[i,j].value+1;
        if p[i+1,j+1].value=10 then p[i,j].value:=p[i,j].value+1;
      end;
    end;
  end;

  clrscr;   //hracia plocha
  gotoxy(47-((sirka*3) div 2),1);writeln('_____');
  gotoxy(47-((sirka*3) div 2),2);writeln('|000|');
  if pocetmin<10 then gotoxy(50-((sirka*3) div 2),2)
  else if pocetmin<100 then gotoxy(49-((sirka*3) div 2),2)
       else gotoxy(48-((sirka*3) div 2),2);
  write(pocetmin);
  gotoxy(47-((sirka*3) div 2),3);
  for i:=0 to (sirka*3) do write('-'); writeln();

  for i:=1 to vyska do begin
    for j:=1 to sirka do begin
      if j=1 then begin
        gotoxy(47-((sirka*3) div 2),3+i);
      end;
      write('|  ');
      if j=sirka then write('|');
    end;
  end;

  gotoxy(47-((sirka*3) div 2),vyska+4);
  for i:=0 to (sirka*3) do write('-');writeln();
  gotoxy(20,vyska+5);
  write('Pohyb "WASD", vlajka "F", menu "ESC", odhalenie "ENTER"');
  if sirka mod 2=0 then hracX:=sirka div 2
  else hracX:=(sirka div 2)+1;
  if sirka mod 2=0 then hracY:=vyska div 2
  else hracY:=(vyska div 2)+1;  //zaciatocna pozicia kurzora
  gotoxy((46-(sirka*3) div 2)+hracX*3,hracY+3);write('P');
end;

procedure vypis(vyska,sirka,hracXX,hracYY:integer);    //vypis hracieho pola
var i,j:integer;
begin

  for i:=1 to vyska do begin
    for j:=1 to sirka do begin
      if p[i,j].state=TRUE then begin  //odhalovanie
           if p[i,j].value=10 then begin
                gotoxy(45-((sirka*3) div 2)+(j*3),3+i);
                textcolor(12);write('X');textcolor(white);
           end
           else begin
                     case p[i,j].value of //farba cislam
                     1:textcolor(blue);
                     2:textcolor(green);
                     3:textcolor(red);
                     4:textcolor(brown);
                     5:textcolor(yellow);
                     6:textcolor(white);
                     7:textcolor(magenta);
                     8:textcolor(3);
                     end;
                     gotoxy(45-((sirka*3) div 2)+(j*3),3+i);
                     write(p[i,j].value,' ');textcolor(white);
                end;
        end;
      if p[i,j].flag=TRUE then begin  //farbenie vlajky
        gotoxy((45-((sirka*3) div 2)+(j*3)),3+i);textbackground(red);write(' ');textbackground(black);
      end;
    end;
    writeln();
  end;
               //kurzor
  gotoxy((46-(sirka*3) div 2)+hracXX*3,hracYY+3);write('P');

end;

procedure odhalenie(row,col,vyska,sirka: integer);  //odhalovanie 0 v hre
var
  x,y: integer;
begin
  if (row >= 1) and (row <= vyska) and (col >= 1) and (col <=sirka) and (p[row, col].state = FALSE) then begin
    p[row, col].state:=TRUE;
    if p[row, col].value = 0 then begin    //ak dalsia 0 tak dalsie odhalovanie
      for x := -1 to 1 do
        for y := -1 to 1 do
          if (x <> 0) or (y <> 0)  then
            odhalenie(row + x, col + y,vyska,sirka);
    end;
  end;
end;

procedure menuhranice(x,y:integer);  //vykreslenie boxu v menu
var i:integer;
begin
  clrscr;
   gotoxy(37,2);write('WORLD OF MINESWEEPER');
   gotoxy(47-(x div 2),3);
   for i:=1 to x do write('-');
   for i:=1 to y-2 do begin
     gotoxy(47-(x div 2),3+i);write('|');
     gotoxy(46+(x div 2),3+i);write('|');
     end;
   gotoxy(47-(x div 2),2+y);
   for i:=1 to x do write('-');
end;

function sipky(nnn,posX,posY:integer):integer;  // sipky v menu
var x:integer;
begin
  x:=0;
  gotoxy(posX,posY);write('->');  //startovacia pozicia
  repeat
      keypressed();
      ch:=readkey;
      if (lowercase(ch)='s') and (x<nnn) then begin  //sipka dole
        gotoxy(posX,posY+(2*x));write('   ');
        x:=x+1;
        gotoxy(posX,posY+(2*x));
        write('->');
      end
      else if (lowercase(ch)='w') and (x>0) then begin  //sipka hore
        gotoxy(posX,posY+(2*x));write('   ');
        x:=x-1;
        gotoxy(posX,posY+(2*x));
        write('->');
      end;
   until ord(ch)=13;
   sipky:=x;
   textcolor(white);
end;

procedure login(dlzka:integer); //login hraca
var poc:integer;
begin
  repeat
   poc:=0;
   reset(subor);
   menuhranice(60,7);
   gotoxy(40,8);write('(max ',dlzka,' znakov)');
   gotoxy(25,5); write('Vase meno: '); readln(meno);
  until (length(meno)>0) and (length(meno)<=dlzka); //kontrola dlzky mena

  for i:=1 to filesize(subor) do begin
         read(subor,rebricek);
         if rebricek.menoh=meno then begin
           poc:=1;
         end;
      end;

  rebricek.menoh:=meno;
  if poc=0 then begin
    seek(subor,filesize(subor));
    rebricek.beginner:=0;
    rebricek.intermediate:=0;
    rebricek.expert:=0;
    write(subor,rebricek);
  end;
end;

procedure hraj(stavhry,vyska,sirka,pocetmin:integer);   //hra
var stlpec,riadok,poc1:integer;
begin
  repeat
     gotoxy((46-(sirka*3) div 2)+hracX*3,hracY+3);write('P'); //vypis kurzora
     gotoxy((46-(sirka*3) div 2)+hracX*3,hracY+3);
     repeat                              //skontrolovanie vstupu
           ch:=readkey; ch:=upcase(ch);
     until (ch='W') or (ch='A') or (ch='S') or (ch='D') or (ch='F') or (ord(ch)=13) or (ord(ch)=27);
     case ch of
     'W':if hracY<>1 then begin
       gotoxy((46-(sirka*3) div 2)+hracX*3,3+hracY); write(' '); //posun kurzora hore
       hracY:=hracY-1;
     end;

     'A':if hracX<>1 then begin
       gotoxy((46-(sirka*3) div 2)+hracX*3,3+hracY); write(' '); //posun kurzora dolava
       hracX:=hracX-1;
       end;

     'S':if hracY<>vyska then begin
       gotoxy((46-(sirka*3) div 2)+hracX*3,3+hracY); write(' '); //posun kurzora dole
       hracY:=hracY+1;
       end;

     'D':if hracX<>sirka then begin
       gotoxy((46-(sirka*3) div 2)+hracX*3,3+hracY); write(' '); //posun kurzora doprava
       hracX:=hracX+1;
       end;

     'F':begin             //mechanika vlajociek
              if p[hracY,hracX].state=FALSE then begin
                 if p[hracY,hracX].flag=TRUE then begin    //vypnutie vlajky
                   p[hracY,hracX].flag:=FALSE;
                   flags:=flags+1;
                   gotoxy((45-((sirka*3) div 2)+(hracX*3)),3+hracY); write(' ');

                   if (flags<10)and(flags>=0) then begin      //pocitadlo min +
                     gotoxy(48-(sirka*3) div 2,2);write('00',flags);
                   end
                   else if ((flags<100)and(flags>=10)) or ((0>flags)and(flags>-10)) then begin
                     gotoxy(48-(sirka*3) div 2,2);write('0',flags);
                        end
                        else begin
                          gotoxy(48-(sirka*3) div 2,2);write(flags);
                        end;

                 end
                 else begin
                   p[hracY,hracX].flag:=TRUE;          //zapnutie vlajky
                   flags:=flags-1;
                                                       //farbenie vlajky
                   gotoxy((45-((sirka*3) div 2)+(hracX*3)),3+hracY);textbackground(red);write(' ');textbackground(black);

                   if (flags<10)and(flags>=0) then begin        //pocitadlo min -
                     gotoxy(48-(sirka*3) div 2,2);write('00',flags);
                   end
                   else if ((flags<100)and(flags>=10)) or ((0>flags)and(flags>-10)) then begin
                     gotoxy(48-(sirka*3) div 2,2);write('0',flags);
                        end
                        else begin
                             gotoxy(48-(sirka*3) div 2,2);write(flags);
                        end;
                 end;
            end;
       end;

     #13:begin                //ENTER odhalenie
              riadok:=hracY; stlpec:=hracX;

              poc:=0;
                for i:= -1 to 1 do                        //pocet vlajok okolo
                       for j:= -1 to 1 do
                           if (i <> 0) or (j <> 0) then
                              if p[riadok+i,stlpec+j].flag=TRUE then poc:=poc+1;

              if (p[riadok,stlpec].flag=FALSE) then begin
                if (p[riadok,stlpec].state=TRUE) and (p[riadok,stlpec].value=poc) and (p[riadok,stlpec].value<>0) then begin
                     poc1:=0;                             //pocet vlajok na minach
                     for i:= -1 to 1 do
                         for j:= -1 to 1 do
                             if (i <> 0) or (j <> 0) then
                                if p[riadok+i,stlpec+j].flag=TRUE then
                                   if p[riadok+i,stlpec+j].value=10 then poc1:=poc1+1;

                     if poc1=poc then begin            //odhalenie okolo
                        for i:= -1 to 1 do
                           for j:= -1 to 1 do
                             if (i <> 0) or (j <> 0) then
                               if (p[riadok+i,stlpec+j].flag=FALSE) and (p[riadok+i,stlpec+j].state=FALSE) and (riadok+i<>0) and (stlpec+j<>0) and (riadok+i<=vyska) and (stlpec+j<=sirka) then begin
                                    if (p[riadok+i,stlpec+j].value=0) and (riadok+i>0) and (stlpec+j>0) then begin
                                          odhalenie(riadok+i,stlpec+j,vyska,sirka);
                                          vypis(vyska,sirka,hracX,hracY);
                                    end
                                    else begin
                                      p[riadok+i,stlpec+j].state:=TRUE;
                                      case p[riadok+i,stlpec+j].value of //farba cislam
                                         1:textcolor(blue);
                                         2:textcolor(green);
                                         3:textcolor(red);
                                         4:textcolor(brown);
                                         5:textcolor(yellow);
                                         6:textcolor(white);
                                         7:textcolor(magenta);
                                         8:textcolor(3);
                                      end;
                                      gotoxy(45-((sirka*3) div 2)+((stlpec+j)*3),3+(riadok+i));
                                      write(p[riadok+i,stlpec+j].value,' ');textcolor(white);
                                    end;
                                 end;

                     end
                     else stavhry:=1;
                end;

              if (p[riadok,stlpec].state=FALSE) then begin
                if p[riadok,stlpec].value=0 then begin
                   odhalenie(riadok,stlpec,vyska,sirka);
                   vypis(vyska,sirka,hracX,hracY);
                end
                else if p[riadok,stlpec].value<>10 then begin
                  p[riadok,stlpec].state:=TRUE;
                  case p[riadok,stlpec].value of //farba cislam
                     1:textcolor(blue);
                     2:textcolor(green);
                     3:textcolor(red);
                     4:textcolor(brown);
                     5:textcolor(yellow);
                     6:textcolor(white);
                     7:textcolor(magenta);
                     8:textcolor(3);
                     end;
                     gotoxy(45-((sirka*3) div 2)+(stlpec*3),3+riadok);
                     write(p[riadok,stlpec].value,' ');textcolor(white);
                  end;
              end;

              poc:=0;
                for i:=1 to vyska do begin
                    for j:=1 to sirka do begin
                        if p[i,j].state=FALSE then poc:=poc+1; //spocitanie volnych poli
                    end;
                end;
                if p[riadok,stlpec].value=10 then stavhry:=1  //podmienky na koniec hry
                else if poc=pocetmin then stavhry:=2;
              end;
       end;

     #27: begin
          stavhry:=3; k:=1;
       end;       //ESC
     end;
  until (stavhry<>0);


  if (stavhry=1)or(stavhry=2) then begin
    if stavhry=1 then begin
         for i:=1 to vyska do begin
           for j:=1 to sirka do begin
             p[i,j].state:=TRUE;
             p[i,j].flag:=FALSE;
           end;
         end;
         vypis(vyska,sirka,hracX,hracY);
         gotoxy(20,vyska+5);write('                                                        ');
         gotoxy(42,vyska+6);
         textcolor(red);write('GAME OVER');            //prehra
         textcolor(white);
    end
    else if stavhry=2 then begin
      for i:=1 to vyska do begin
           for j:=1 to sirka do begin
             p[i,j].state:=TRUE;
             p[i,j].flag:=FALSE;
           end;
         end;
      vypis(vyska,sirka,hracX,hracY);
      gotoxy(20,vyska+5);write('                                                        ');
      gotoxy(42,vyska+6);
      textcolor(green);write('Vyhral si');                             //vyhra + zapisanie do rebricka
      textcolor(white);

      reset(subor);
      for i:=1 to filesize(subor) do begin
         read(subor,rebricek);
         if rebricek.menoh=meno then begin
           seek(subor,i-1);
           rebricek.menoh:=meno;
           if sirka=9 then rebricek.beginner:=rebricek.beginner+1
           else if sirka=16 then rebricek.intermediate:=rebricek.intermediate+1
                else if sirka=30 then rebricek.expert:=rebricek.expert+1;
           write(subor,rebricek);
         end;
      end;
    end;
    gotoxy(44,vyska+8);write('ZNOVA');
    gotoxy(44,vyska+10);write('MENU');
    case sipky(1,41,vyska+8) of
    0:k:=0;
    1:k:=1;
    end;
  end;
end;

procedure menu();        //cela hra
var x,pocetmin,vyska,sirka,stavhry:integer;
    vyskas,sirkas,pocetmins:string;
begin
  repeat
     clrscr;
   gotoxy(37,2);write('WORLD OF MINESWEEPER');
   gotoxy(27,3);
   menuhranice(40,11);
   gotoxy(43,5);write('HRA');
   gotoxy(43,7);write('REBRICEK');
   gotoxy(43,9);write('NAPOVEDA');
   gotoxy(43,11);write('KONIEC');

   case sipky(3,40,5) of
   0:begin
          menuhranice(40,13); k:=0;
          gotoxy(43,5);write('ZACIATOCNIK');
          gotoxy(43,7);write('POKROCILY');
          gotoxy(43,9);write('EXPERT');
          gotoxy(43,11);write('VLASTNE ROZLOZENIE');
          gotoxy(43,13);write('MENU');

          case sipky(4,40,5) of
          0:begin  //zaciatocnik
            repeat
              pocetmin:=10;vyska:=9;sirka:=9;
              generujhru(pocetmin,vyska,sirka);
              repeat
                    hraj(0,vyska,sirka,pocetmin);
              until stavhry <> 0;
            until k=1;
            end;

          1:begin  //pokrocily
            repeat
              pocetmin:=40;vyska:=16;sirka:=16;
              generujhru(pocetmin,vyska,sirka);
              repeat
                 hraj(0,vyska,sirka,pocetmin);
              until stavhry<>0;
            until k=1;
            end;

          2:begin   //expert
            repeat
              pocetmin:=99;vyska:=16;sirka:=30;
              generujhru(pocetmin,vyska,sirka);
              repeat
                 hraj(0,vyska,sirka,pocetmin);
              until stavhry<>0;
            until k=1;
            end;

          3:begin  //zadanie parametrov pre vlastne rozlozenie
            clrscr; menuhranice(50,8);
            gotoxy(30,4); writeln('Zadajte parametre hracieho pola: ');
            repeat
              gotoxy(30,5); write('Vyska pola:                  ');readln(vyskas);
              val(vyskas,vyska,k);
            until k=0;
            if vyska<=0 then vyska:=1;
            if vyska>maxvyska then vyska:=maxvyska;
            repeat
              gotoxy(30,6); write('Sirka pola:                  ');readln(sirkas);
              val(sirkas,sirka,k);
            until k=0;
            if sirka<=0 then sirka:=1;
            if sirka>maxsirka then sirka:=maxsirka;
            repeat
              gotoxy(30,7); write('Pocet min:                  ');readln(pocetmins);
              val(pocetmins,pocetmin,k);
            until k=0;
            if pocetmin<=0 then pocetmin:=1;
            if pocetmin>(sirka*vyska) then pocetmin:=(sirka*vyska)-1;

            repeat
              generujhru(pocetmin,vyska,sirka);
              repeat
                 hraj(0,vyska,sirka,pocetmin);
              until stavhry<>0;
            until k=1;

            end;
          4:;
          end;
   end;
   1:begin                                          //rebricek
          menuhranice(90,20);
          gotoxy(22,4);write('B.  I.  E.');
          reset(subor);
          for i:=1 to filesize(subor) do begin
            read(subor,rebricek);
            gotoxy(4,4+i);write(i,'.',rebricek.menoh);
            gotoxy(22,4+i);write(rebricek.beginner,'   ',rebricek.intermediate,'   ',rebricek.expert);
          end;
          repeat until keypressed;
     end;
   2:begin
          menuhranice(90,16);
          gotoxy(12,4);write('Hracie pole je rozdelene na bunky s nahodne rozmiestnenymi minami(');textcolor(12);write('X');textcolor(white);write(').');
          gotoxy(12,5);write('Akonahle odhalite minu tak prehrate.');
          gotoxy(12,6);write('Ak chcete vyhrat, musite otvorit vsetky bunky tak aby ostali na poli');
          gotoxy(12,7);write('neodhalene iba policka kde su umiestnene miny. Cislo v bunke ukazuje');
          gotoxy(12,8);write('pocet susediacich min. Pomocou tychto informacii mozete urcit bunky,');
          gotoxy(12,9);write('ktore su bezpecne, a bunky, ktore obsahuju miny. V lavom hornom rohu ');
          gotoxy(12,10);write('je zobrazeny pocet min v poli. Neodhalene miny mozete oznacit vlajkou.');
          gotoxy(12,11);write('Ak ma cislo okolo seba spravny pocet vlajociek tak mozete kliknut na');
          gotoxy(12,12);write('cislo pre odhalenie susednych poli.');
          gotoxy(12,14);write('PATERNY');
          gotoxy(12,16);write('MENU');

          case sipky(1,9,14) of
          0:;
          1:;
          end;
     end;

   3:begin
          menuhranice(40,9);
          gotoxy(37,5);write('Naozaj chcete odist?');
          gotoxy(43,7);write('ANO');
          gotoxy(43,9);write('NIE');

          case sipky(1,40,7) of
          0:x:=1;
          1:x:=0;
          end;
     end;
   end;
  until x=1;
end;

begin
  randomize;
  assign(subor,suborc);
  reset(subor);
  login(15);
  menu();
  close(subor);


end.

