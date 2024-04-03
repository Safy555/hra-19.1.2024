program Project1;
uses graph,crt;
var
  gd,gm:smallint;
  x:integer;

begin
  gd:=detect;
  initgraph(gd,gm,'C:\lazarus');
  moveto(0,trunc(getmaxy*0.5));
  lineto(getmaxx,trunc(getmaxy*0.5));
  moveto(trunc(getmaxx*0.5),0);
  lineto(trunc(getmaxx*0.5),getmaxy);
  for x:=-720 to 720 do begin
    putpixel(x+(getmaxx div 2),-(x*x div 100)+(getmaxy div 2),15);
  end;
  circle((getmaxx div 2)-100,getmaxy div 2,2);
  circle((getmaxx div 2)+100,getmaxy div 2,2);
  circle((getmaxx div 2)-200,getmaxy div 2,2);
  circle((getmaxx div 2)+200,getmaxy div 2,2);
  circle((getmaxx div 2),(getmaxy div 2)-100,2);
  circle((getmaxx div 2),(getmaxy div 2)-200,2);
  circle((getmaxx div 2),(getmaxy div 2)-300,2);
  circle((getmaxx div 2),(getmaxy div 2)-400,2);
  circle((getmaxx div 2),(getmaxy div 2),2);

  readln();
  closegraph();









  readln();
end.

