program hra_19_1_2024;                 //Beginner-10min,9x9      95x30 konzola
uses crt;                              //Expert-99min,30x16
const maxsirka=30;maxvyska=20;         //Intermediate-40min,16x16
type Tpole=record
                 state:boolean;
                 value:byte;
                 end;
var
  ch:char;
  i,j,k,l,poc,stavhry:integer;
  p:array [0..maxvyska+1,0..maxsirka+1] of Tpole;
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

procedure generujhru(var nn,vyska,sirka:integer);   //generovanie pola
begin
   //vynulovanie pola
   for i:=0 to vyska+1 do begin
    for j:=0 to sirka+1 do begin
      p[i,j].value:=0;
    end;
  end;
   generujminy(nn,sirka,vyska);
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
end;

procedure vypis(vyska,sirka,pocetmin:integer);    //vypis hracieho pola
begin
  clrscr;
  gotoxy(3,1);writeln('_____');
  gotoxy(3,2);writeln('|000|');
  if pocetmin<10 then gotoxy(6,2)
  else if pocetmin<100 then gotoxy(5,2)
  else gotoxy(4,2);
  write(pocetmin);
  gotoxy(4,3);
  for i:=0 to (sirka*3) do write('-'); writeln();

  for i:=1 to vyska do begin
    for j:=1 to sirka do begin
      if j=1 then begin
        if i<10 then write(' ',i,' ')
        else write(i,' ');
      end;
      if p[i,j].state=TRUE then begin  //odhalovanie
           if p[i,j].value=10 then begin
                write('|');
                textcolor(12);write('X ');textcolor(white);
           end
           else begin
                     write('|');
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
                     write(p[i,j].value,' ');textcolor(white);
                end;
        end
           else write('|  ');
      if j=sirka then write('|');
    end;
    writeln();
  end;
  gotoxy(4,vyska+4);
  for i:=0 to (sirka*3) do write('-');writeln();

  for i:=1 to sirka do begin //dolne pocitadlo(os x)
    if i=1 then write('    ');
    if i<10 then write(i,'  ')
    else write(i,' ');
  end; writeln();
end;

procedure odhalenie(row,col,vyska,sirka: integer);  //odhalovanie 0 v hre
var
  x, y: integer;
begin
  if (row >= 1) and (row <= vyska) and (col >= 1) and (col <=sirka) and (p[row, col].state = FALSE) then begin
    p[row, col].state:=TRUE;
    if p[row, col].value = 0 then begin
      for x := -1 to 1 do
        for y := -1 to 1 do
          if (x <> 0) or (y <> 0) then
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
   for i:=1 to x*y do begin
     if i<x then write('-')
     else if i mod x=0 then gotoxy(47-(x div 2),3+(i div x))
     else if i>x*(y-1) then write('-')
     else if (i mod x=1) or (i mod x=(x-1)) then write('|')
     else write(' ');
   end;
end;

function sipky(nnn,posX,posY:integer):integer;            // sipky v menu
var x:integer;
begin
  x:=0;
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

procedure hraj(stavhry,vyska,sirka,pocetmin:integer);   //hra
var stlpec,riadok:integer;
  ch:char;
begin
  repeat
     vypis(vyska,sirka,pocetmin);
     repeat  //skontrolovanie vstupu
           write('Zadaj suradnice kliku(stlpec"medzera"riadok): ');readln(stlpec,riadok);   //while not readln(...) do begin
     until ((stlpec>0) and (stlpec<=sirka)) and ((riadok>0) and (riadok<=vyska)) and (p[riadok,stlpec].state=FALSE);

     if p[riadok,stlpec].value=0 then begin
        odhalenie(riadok,stlpec,vyska,sirka);
     end
     else begin
        p[riadok,stlpec].state:=TRUE;
     end;
     poc:=0;
     for i:=1 to vyska do begin
       for j:=1 to sirka do begin
         if p[i,j].state=FALSE then poc:=poc+1; //spocitanie volnych poli
       end;
     end;
     if p[riadok,stlpec].value=10 then stavhry:=1  //podmienky na koniec hry
     else if poc=pocetmin then stavhry:=2;
  until (stavhry<>0);

  if stavhry=1 then begin
       for i:=1 to vyska do begin
         for j:=1 to sirka do begin
           p[i,j].state:=TRUE;
         end;
       end;
       vypis(vyska,sirka,pocetmin);
       gotoxy((sirka*3)div 2,2);
       textcolor(red);write('GAME OVER');
       textcolor(white);
       gotoxy(5,vyska+7);write('Pre vratenie do MENU stlacte niektore tlacitko...');
       repeat until keypressed;
  end
  else if stavhry=2 then begin
    for i:=1 to vyska do begin
         for j:=1 to sirka do begin
           p[i,j].state:=TRUE;
         end;
       end;
       vypis(vyska,sirka,pocetmin);
       gotoxy((sirka*3)div 2,2);
       textcolor(green);write('Vyhral si');
       textcolor(white);
       gotoxy(5,vyska+7);write('Pre vratenie do MENU stlacte niektore tlacitko...');
       repeat until keypressed;
  end;
end;

procedure menu();        //cela hra
var x,pocetmin,vyska,sirka,stavhry:integer;
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
   gotoxy(40,5);write('->');
   case sipky(3,40,5) of
   0:begin
          menuhranice(40,13);
          gotoxy(43,5);write('ZACIATOCNIK');
          gotoxy(43,7);write('POKROCILY');
          gotoxy(43,9);write('EXPERT');
          gotoxy(43,11);write('VLASTNE ROZLOZENIE');
          gotoxy(43,13);write('MENU');
          gotoxy(40,5);write('->');
          case sipky(4,40,5) of
          0:begin
            pocetmin:=10;vyska:=9;sirka:=9;
            generujhru(pocetmin,vyska,sirka);
            repeat
                  hraj(0,vyska,sirka,pocetmin);
            until stavhry <> 0;
            end;
          1:begin
            pocetmin:=40;vyska:=16;sirka:=16;
            generujhru(pocetmin,vyska,sirka);
            repeat
               hraj(0,vyska,sirka,pocetmin);
            until stavhry<>0;
            end;
          2:begin
            pocetmin:=99;vyska:=16;sirka:=30;
            generujhru(pocetmin,vyska,sirka);
            repeat
               hraj(0,vyska,sirka,pocetmin);
            until stavhry<>0;
            end;
          3:begin
            clrscr;
            menuhranice(50,8);
            gotoxy(30,4);
            writeln('Zadajte parametre hracieho pola: ');
            gotoxy(30,5);
            write('Vyska pola: ');readln(vyska);
            if vyska<=0 then vyska:=1;
            if vyska>maxvyska then vyska:=maxvyska;
            gotoxy(30,6);
            write('Sirka pola: ');readln(sirka);
            if sirka<=0 then sirka:=1;
            if sirka>maxsirka then sirka:=maxsirka;
            gotoxy(30,7);
            write('Pocet min: ');readln(pocetmin);
            if pocetmin<=0 then pocetmin:=1;
            if pocetmin>(sirka*vyska) then pocetmin:=(sirka*vyska)-1;
            generujhru(pocetmin,vyska,sirka);
            repeat
               hraj(0,vyska,sirka,pocetmin);
            until stavhry<>0;
            end;
          4:;
          end;
   end;
   1:;//REBRICEK
   2:begin
          menuhranice(90,13);
          gotoxy(12,4);write('Hracie pole je rozdelene na bunky s nahodne rozmiestnenymi minami.');
          gotoxy(12,5);write('Ak chcete vyhrat, musite otvorit vsetky bunky tak aby ostali na poli');
          gotoxy(12,6);write('neodhalene iba policka kde su umiestnene miny. Cislo v bunke ukazuje');
          gotoxy(12,7);write('pocet susediacich min. Pomocou tychto informacii mozete urcit bunky,');
          gotoxy(12,8);write('ktore su bezpecne, a bunky, ktore obsahuju miny. V lavom hornom rohu ');
          gotoxy(12,9);write('je zobrazeny pocet min v poli.');
          gotoxy(9,11);write('-> PATERNY');
          gotoxy(12,13);write('MENU');
          case sipky(1,9,11) of
          0:;
          1:;
          end;
     end;
   3:begin
          menuhranice(40,9);
          gotoxy(37,5);write('Naozaj chcete odist?');
          gotoxy(43,7);write('ANO');
          gotoxy(43,9);write('NIE');
          gotoxy(40,7);write('->');
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
  menu();

end.

