//see RasPi TestXX demo c file here:
// https://github.com/rst-/raspberry-compote/blob/master/fb/fbtestXX.c

//Bresenham's 'crude' line algorithm -applied to circles
procedure DrawCircle(x0,y0:word; radius:single);

var
	x,y:word;
	decisionOver2:single;

begin
	x:=radius
	y:=0
	decisionOver2:=1-x
 
	while x>=y do begin
		putpixel( x + x0,  y + y0)
		putpixel( y + x0,  x + y0)
		putpixel(-x + x0,  y + y0)
		putpixel(-y + x0,  x + y0)
		putpixel(-x + x0, -y + y0)
		putpixel(-y + x0, -x + y0)
		putpixel( x + x0, -y + y0)
		putpixel( y + x0, -x + y0)
 
		inc(y);
 
		if decisionOver2<=0 then
			decisionOver2:=decisionOver2+2*y+1;
		else
			dec(x);
      			decisionOver2:=decisionOver2+2*(y-x)+1;
		end;
	end;
	
End;