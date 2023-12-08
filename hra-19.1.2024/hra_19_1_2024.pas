program hra_19_1_2024;
uses crt;
const mc=9; nc=9;
var
  i,j,k,l,x,y,c,poc:integer;
  p:array [0..mc+1,0..nc+1] of byte;
procedure vypis();
begin
  clrscr;
  for i:=1 to mc do begin
    for j:=1 to nc do begin
      if p[i,j]<>10 then begin
        if p[i-1,j-1]=10 then p[i,j]:=p[i,j]+1;
        if p[i-1,j]=10 then p[i,j]:=p[i,j]+1;
        if p[i-1,j+1]=10 then p[i,j]:=p[i,j]+1;
        if p[i,j-1]=10 then p[i,j]:=p[i,j]+1;
        if p[i,j+1]=10 then p[i,j]:=p[i,j]+1;
        if p[i+1,j-1]=10 then p[i,j]:=p[i,j]+1;
        if p[i+1,j]=10 then p[i,j]:=p[i,j]+1;
        if p[i+1,j+1]=10 then p[i,j]:=p[i,j]+1;
      end;
    end;
  end;
  for i:=1 to mc do begin
    for j:=1 to nc do begin
      if p[i,j]=10 then write('* ')
      else write(p[i,j],' ');
    end;
    writeln();
  end;
end;
procedure generujbombs(n:integer);
begin
  for i:=1 to n do begin
    repeat
      x:=random(mc)+1;y:=random(nc)+1;
    until p[y,x]=0;
    p[y,x]:=10
  end;
end;
begin
  randomize;
  for i:=0 to mc+1 do begin
    for j:=0 to nc+1 do begin
      p[i,j]:=0;
    end;
  end;

  generujbombs(10);
  vypis();

  readln();
end.

