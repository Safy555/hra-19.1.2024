program funkcie;
uses graph,crt;
var
  gd,gm:smallint;
  x,xx,y,i,c:integer;
procedure vypocetsuradnic(xxx:integer);
begin

  xx:=xxx+(getmaxx div 2);
  y:=-(xxx*xxx{<-sem dajte predpis funkcie, x zamente za xxx(dakujem)} div 100)+(getmaxy div 2);
end;
begin
  gd:=detect;
  initgraph(gd,gm,'C:\lazarus');
  moveto(0,getmaxy div 2);
  lineto(getmaxx,getmaxy div 2);
  moveto(getmaxx div 2,0);
  lineto(getmaxx div 2,getmaxy);


  moveto((getmaxx div 2)-10,(getmaxy div 2)+10);outtext('0');
  x:=0;
  repeat
     circle((getmaxx div 2)+x,(getmaxy div 2),2);
     circle((getmaxx div 2)-x,(getmaxy div 2),2);
     x:=x+100;
  until x>getmaxx div 2;

  y:=0;
  repeat
     circle((getmaxx div 2),(getmaxy div 2)+y,2);
     circle((getmaxx div 2),(getmaxy div 2)-y,2);
     y:=y+100;
  until y>getmaxy div 2;




  for x:=-720 to 720 do begin
    vypocetsuradnic(x);
    putpixel(xx,y,15);
  end;



  readln();
  closegraph();


 //putpixel(x+(getmaxx div 2),-(x*x div 100)+(getmaxy div 2),15);






  readln();
end.

