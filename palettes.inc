{
greyscale palettes are required for either loading or displaying in BW, or some subset thereof.
this isnt "exactly" duplicated code

hardspec it first, then allow user defined- or "pre-saved" files
that not to say you cant init, save, then load thru the main code instead of useing the hard spec.

the hardspec is here as a default setting, much like most 8x8 font sometimes are included
by default in graphics modes source code.

these are zero based colors. for 16 color modes- 88 or even 80 is not correct, 70 or 7f is.
the 256 hex color data was pulled from xterm (and CGA) specs.


the only guaranteed perfect palette code is (m)CGA -tweaked by me, and Greyscale 256.
(greyscale mCGA is a hackish guess based on rough math, given 14 colors, and also black and white)
256 should mimic xterm colors IF the endianess is correct and I dont need DWord hex math ops

Float to byte routine are optional-
	added because loads of OpenGL examples use floats (but YOU dont need to).

Since I went thru all the effort of using SDL bytes- 
 	Im going to BYTE YOU- instead of floating the boat(he he he).
}

//SDL to GL value conversion-and back- (I dont see this anywhere)


//for generic floats above value of 1.0	
function FloatToByte(someFloat:single):byte
begin
   if someFloat < 2.55 then
	  FloatToByte:=byte(round(someFloat));
   else 
      exit;	  
end;

//For GLFloats with max value of 1.0
function GLFloatToByte(someFloat:single):byte
begin
   if (someFloat > 1.0) then 
		exit;
   FloatToByte:=byte(round(someFloat));
end;

//DWord,etc needs to be a byte first (hi(DWord),(lo(DWORD))
//OpenGl doesnt use DWords- it uses RGB(A) Clusters instead


//simply put: a float of 3.0 wont work if GLFloat maxes out at 1.0
//output gives "whole numbers" as bytes cant have partials.

function ByteToGLFloat(someByte:byte):single;
var
	BInt:single;

begin
   //first make the value sane (<100)
   //this means that for each byte value- there are >2.5x values for each float/integer derived
   if (ord(someByte) > 64) then
	  BInt:=(ord(someByte) / 2.55); //base convert: 255(hex) = 1.0(float)
   
   ByteToGLFloat:= single(BInt mod 100); //convert 100 to 1.0
end;

//gimmie a float- I dont care if its GL compatible.
function ByteToFloat(someByte:byte):single;

begin
   ByteToGLFloat:= (single(ord(someByte)) mod 100);
end;


procedure initPaletteGrey16;

var
   i,num:integer;


begin  

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;
valuelist16[3]:=$11;
valuelist16[4]:=$11;
valuelist16[5]:=$11;
valuelist16[6]:=$22;
valuelist16[7]:=$22;
valuelist16[8]:=$22;
valuelist16[9]:=$33;
valuelist16[10]:=$33;
valuelist16[11]:=$33;
valuelist16[12]:=$44;
valuelist16[13]:=$44;
valuelist16[14]:=$44;
valuelist16[15]:=$55;
valuelist16[16]:=$55;
valuelist16[17]:=$55;
valuelist16[18]:=$66;
valuelist16[19]:=$66;
valuelist16[20]:=$66;
valuelist16[21]:=$77;
valuelist16[22]:=$77;
valuelist16[23]:=$77;
valuelist16[24]:=$88;
valuelist16[25]:=$88;
valuelist16[26]:=$88;
valuelist16[27]:=$99;
valuelist16[28]:=$99;
valuelist16[29]:=$99;
valuelist16[30]:=$aa;
valuelist16[31]:=$aa;
valuelist16[32]:=$aa;
valuelist16[33]:=$bb;
valuelist16[34]:=$bb;
valuelist16[35]:=$bb;
valuelist16[36]:=$cc;
valuelist16[37]:=$cc;
valuelist16[38]:=$cc;
valuelist16[39]:=$dd;
valuelist16[40]:=$dd;
valuelist16[41]:=$dd;
valuelist16[42]:=$ee;
valuelist16[43]:=$ee;
valuelist16[44]:=$ee;
valuelist16[45]:=$ff;
valuelist16[46]:=$ff;
valuelist16[47]:=$ff;

   i:=0;
   num:=0; 
   repeat 
      Tpalette16.colors[num]^.r:=valuelist16[i];
      Tpalette16.colors[num]^.g:=valuelist16[i+1];
      Tpalette16.colors[num]^.b:=valuelist16[i+2];
      Tpalette16.colors[num]^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=15;

//we dont need no stinkin DWORDS!

end;


procedure initPaletteGrey256;

//easy peasy to setup.

var
    i,num:integer;


begin  

//(we dont setup valuelist by hand this time)

   i:=0;
  repeat 
      Tpalette256Grey.colors[num]^.r:=Byte(longint(i));
      Tpalette256Grey.colors[num]^.g:=Byte(longint(i));
      Tpalette256Grey.colors[num]^.b:=Byte(longint(i));
      Tpalette256Grey.colors[num]^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i); //notice the difference <-HERE ..where RGB are the same values
  until i=255;

	

end;

procedure initPalette16;

var
   num,i:integer;

begin  
//Color Sequence:
//K HiR HiG HiB HiC HiM HiY HiGR LoGr LoR LoG LoB LoC LoM LoY W
//these are binary driven FULL ON /FULL OFF

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;

valuelist16[3]:=$7f;
valuelist16[4]:=$00;
valuelist16[5]:=$00;

valuelist16[6]:=$00;
valuelist16[7]:=$7f;
valuelist16[8]:=$00;

valuelist16[9]:=$00;
valuelist16[10]:=$00;
valuelist16[11]:=$7f;

//yellow
valuelist16[12]:=$7f;
valuelist16[13]:=$7f;
valuelist16[14]:=$00;

valuelist16[15]:=$7f;
valuelist16[16]:=$00;
valuelist16[17]:=$7f;

valuelist16[18]:=$00;
valuelist16[19]:=$7f;
valuelist16[20]:=$7f;

//2 greys
valuelist16[21]:=$f0;
valuelist16[22]:=$f0;
valuelist16[23]:=$f0;

valuelist16[24]:=$f0;
valuelist16[25]:=$f0;
valuelist16[26]:=$f0;
//end greys

valuelist16[27]:=$ff;
valuelist16[28]:=$00;
valuelist16[29]:=$00;

valuelist16[30]:=$00;
valuelist16[31]:=$ff;
valuelist16[32]:=$00;

valuelist16[33]:=$00;
valuelist16[34]:=$00;
valuelist16[35]:=$ff;

valuelist16[36]:=$00;
valuelist16[37]:=$ff;
valuelist16[38]:=$ff;

valuelist16[39]:=$ff;
valuelist16[40]:=$00;
valuelist16[41]:=$ff;

//14=Y
valuelist16[42]:=$7f;
valuelist16[43]:=$7f;
valuelist16[44]:=$00;

//white is specified later(wonky palette)

   i:=0;
   num:=0; 
   repeat 
      Tpalette16.colors[num]^.r:=valuelist16[i];
      Tpalette16.colors[num]^.g:=valuelist16[i+1];
      Tpalette16.colors[num]^.b:=valuelist16[i+2];
      Tpalette16.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=7;

   i:=25;
   num:=8; 
   repeat 
      Tpalette16.colors[num]^.r:=valuelist16[i];
      Tpalette16.colors[num]^.g:=valuelist16[i+1];
      Tpalette16.colors[num]^.b:=valuelist16[i+2];
      Tpalette16.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=14;
  //white
      Tpalette16.colors[15]^.r:=$ff;
      Tpalette16.colors[15]^.g:=$ff;
      Tpalette16.colors[15]^.b:=$ff;
      Tpalette16.colors[15]^.a:=$ff;
  

end;


procedure Save16Palette(filename:string);

var
	palette16File : File of TRec16;
	i,num            : integer;

Begin
	initPalette16;
	Assign(palette16File, filename);
	ReWrite(palette16File);

	Write(palette16File, TPalette16); //dump everything out
	Close(palette16File);
	
End;

//we should ask if we want to read a color or BW file, else we duplicate code for one line of changes.
//there is a way to check- but we would have to peek inside the file or just display it and assume things.
//this could shove a BW file in the color section or a color file in the BW section...
//anyway, theres two sets of arrays and you can reset to defaults if you need to.

procedure Read16Palette(filename:string; ReadColorFile:boolean);

Var
	palette16File  : File of TRec16;
	i,num            : integer;
    palette:PSDL_Palette;

Begin
	Assign(palette16File, filename);
	ReSet(palette16File);
    Seek(palette16File, 0); //find first record
    if ReadColorFile =true then
		Read(palette16File, TPalette16) //read everything in
	else
		Read(palette16File, TPalette16GRey); 
	    
	Close(palette16File);
	
     SDL_AllocPalette(16);    
    if ReadColorFile =true then
          
          SDL_SetPaletteColors(palette,Tpalette16.colors,0,16)
    else
          SDL_SetPaletteColors(palette,Tpalette16GRey.colors,0,16);

end;

procedure initPalette256;

//256 color VGA palette based on XTerm colors(Unix)
// however the first 16 are off according to mCGA specs and have been corrected.
//xterms dont use "bold text by deault" an maybe this is where the confusion is.

//furthermore there are other 256rgb palettes.


var
    num,i:integer;


begin  
//old cga palette
valuelist256[0]:=$00;
valuelist256[1]:=$00;
valuelist256[2]:=$00;

valuelist256[3]:=$7f;
valuelist256[4]:=$00;
valuelist256[5]:=$00;

valuelist256[6]:=$00;
valuelist256[7]:=$7f;
valuelist256[8]:=$00;

valuelist256[9]:=$00;
valuelist256[10]:=$00;
valuelist256[11]:=$7f;

valuelist256[12]:=$7f;
valuelist256[13]:=$7f;
valuelist256[14]:=$00;

valuelist256[15]:=$7f;
valuelist256[16]:=$00;
valuelist256[17]:=$7f;

valuelist256[18]:=$00;
valuelist256[19]:=$7f;
valuelist256[20]:=$7f;

valuelist256[21]:=$f0;
valuelist256[22]:=$f0;
valuelist256[23]:=$f0;

valuelist256[24]:=$f0;
valuelist256[25]:=$f0;
valuelist256[26]:=$f0;

valuelist256[27]:=$ff;
valuelist256[28]:=$00;
valuelist256[29]:=$00;

valuelist256[30]:=$00;
valuelist256[31]:=$ff;
valuelist256[32]:=$00;

valuelist256[33]:=$00;
valuelist256[34]:=$00;
valuelist256[35]:=$ff;

valuelist256[36]:=$00;
valuelist256[37]:=$00;
valuelist256[38]:=$ff;

valuelist256[39]:=$ff;
valuelist256[40]:=$00;
valuelist256[41]:=$ff;

valuelist256[42]:=$7f;
valuelist256[43]:=$7f;
valuelist256[44]:=$00;

valuelist256[45]:=$ff;
valuelist256[46]:=$ff;
valuelist256[47]:=$ff;

//end old 16 color palette

valuelist256[48]:=$00;
valuelist256[49]:=$00;
valuelist256[50]:=$00;

valuelist256[51]:=$00;
valuelist256[52]:=$00;
valuelist256[53]:=$5f;
valuelist256[54]:=$00;
valuelist256[55]:=$00;
valuelist256[56]:=$87;
valuelist256[57]:=$00;
valuelist256[58]:=$00;
valuelist256[59]:=$af;
valuelist256[60]:=$00;
valuelist256[61]:=$00;
valuelist256[62]:=$d7;
valuelist256[63]:=$00;
valuelist256[64]:=$00;
valuelist256[65]:=$ff;
valuelist256[66]:=$00;
valuelist256[67]:=$5f;
valuelist256[68]:=$00;
valuelist256[69]:=$00;
valuelist256[70]:=$5f;
valuelist256[71]:=$5f;
valuelist256[72]:=$00;
valuelist256[73]:=$5f;
valuelist256[74]:=$87;
valuelist256[75]:=$00;
valuelist256[76]:=$5f;
valuelist256[77]:=$af;
valuelist256[78]:=$00;
valuelist256[79]:=$5f;
valuelist256[80]:=$d7;
valuelist256[81]:=$00;
valuelist256[82]:=$5f;
valuelist256[83]:=$ff;
valuelist256[84]:=$00;
valuelist256[85]:=$87;
valuelist256[86]:=$00;
valuelist256[87]:=$00;
valuelist256[88]:=$87;
valuelist256[89]:=$5f;
valuelist256[90]:=$00;
valuelist256[91]:=$87;
valuelist256[92]:=$87;
valuelist256[93]:=$00;
valuelist256[94]:=$87;
valuelist256[95]:=$af;
valuelist256[96]:=$00;
valuelist256[97]:=$87;
valuelist256[98]:=$d7;
valuelist256[99]:=$00;
valuelist256[100]:=$87;

valuelist256[101]:=$ff;
valuelist256[102]:=$00;
valuelist256[103]:=$af;
valuelist256[104]:=$00;
valuelist256[105]:=$00;
valuelist256[106]:=$af;
valuelist256[107]:=$5f;
valuelist256[108]:=$00;
valuelist256[109]:=$af;
valuelist256[110]:=$87;
valuelist256[111]:=$00;
valuelist256[112]:=$af;
valuelist256[113]:=$af;
valuelist256[114]:=$00;
valuelist256[115]:=$af;
valuelist256[116]:=$d7;
valuelist256[117]:=$00;
valuelist256[118]:=$af;
valuelist256[119]:=$ff;
valuelist256[120]:=$00;
valuelist256[121]:=$d7;
valuelist256[122]:=$00;
valuelist256[123]:=$00;
valuelist256[124]:=$d7;
valuelist256[125]:=$5f;
valuelist256[126]:=$00;
valuelist256[127]:=$d7;
valuelist256[128]:=$87;
valuelist256[129]:=$00;
valuelist256[130]:=$d7;
valuelist256[131]:=$af;
valuelist256[132]:=$00;
valuelist256[133]:=$d7;
valuelist256[134]:=$d7;
valuelist256[135]:=$00;
valuelist256[136]:=$d7;
valuelist256[137]:=$ff;
valuelist256[138]:=$00;
valuelist256[139]:=$ff;
valuelist256[140]:=$00;
valuelist256[141]:=$00;
valuelist256[142]:=$ff;
valuelist256[143]:=$5f;
valuelist256[144]:=$00;
valuelist256[145]:=$ff;
valuelist256[146]:=$87;
valuelist256[147]:=$00;
valuelist256[148]:=$ff;
valuelist256[149]:=$af;
valuelist256[150]:=$00;

valuelist256[151]:=$ff;
valuelist256[152]:=$d7;
valuelist256[153]:=$00;
valuelist256[154]:=$ff;
valuelist256[155]:=$ff;
valuelist256[156]:=$5f;
valuelist256[157]:=$00;
valuelist256[158]:=$00;
valuelist256[159]:=$5f;
valuelist256[160]:=$00;
valuelist256[161]:=$5f;
valuelist256[162]:=$5f;
valuelist256[163]:=$00;
valuelist256[164]:=$87;
valuelist256[165]:=$5f;
valuelist256[166]:=$00;
valuelist256[167]:=$af;
valuelist256[168]:=$5f;
valuelist256[169]:=$00;
valuelist256[170]:=$d7;
valuelist256[171]:=$5f;
valuelist256[172]:=$00;
valuelist256[173]:=$ff;
valuelist256[174]:=$5f;
valuelist256[175]:=$5f;
valuelist256[176]:=$00;
valuelist256[177]:=$5f;
valuelist256[178]:=$5f;
valuelist256[179]:=$5f;
valuelist256[180]:=$5f;
valuelist256[181]:=$5f;
valuelist256[182]:=$87;
valuelist256[183]:=$5f;
valuelist256[184]:=$5f;
valuelist256[185]:=$af;
valuelist256[186]:=$5f;
valuelist256[187]:=$5f;
valuelist256[188]:=$d7;
valuelist256[189]:=$5f;
valuelist256[190]:=$5f;
valuelist256[191]:=$ff;
valuelist256[192]:=$5f;
valuelist256[193]:=$87;
valuelist256[194]:=$00;
valuelist256[195]:=$5f;
valuelist256[196]:=$87;
valuelist256[197]:=$5f;
valuelist256[198]:=$5f;
valuelist256[199]:=$87;
valuelist256[200]:=$87;

valuelist256[201]:=$5f;
valuelist256[202]:=$87;
valuelist256[203]:=$af;
valuelist256[204]:=$5f;
valuelist256[205]:=$87;
valuelist256[206]:=$d7;
valuelist256[207]:=$5f;
valuelist256[208]:=$87;
valuelist256[209]:=$ff;
valuelist256[210]:=$5f;
valuelist256[211]:=$af;
valuelist256[212]:=$00;
valuelist256[213]:=$5f;
valuelist256[214]:=$af;
valuelist256[215]:=$5f;
valuelist256[216]:=$5f;
valuelist256[217]:=$af;
valuelist256[218]:=$87;
valuelist256[219]:=$5f;
valuelist256[220]:=$af;
valuelist256[221]:=$af;
valuelist256[222]:=$5f;
valuelist256[223]:=$af;
valuelist256[224]:=$d7;
valuelist256[225]:=$5f;
valuelist256[226]:=$af;
valuelist256[227]:=$ff;
valuelist256[228]:=$5f;
valuelist256[229]:=$d7;
valuelist256[230]:=$00;
valuelist256[231]:=$5f;
valuelist256[232]:=$d7;
valuelist256[233]:=$5f;
valuelist256[234]:=$5f;
valuelist256[235]:=$d7;
valuelist256[236]:=$87;
valuelist256[237]:=$5f;
valuelist256[238]:=$d7;
valuelist256[239]:=$af;
valuelist256[240]:=$5f;
valuelist256[241]:=$d7;
valuelist256[242]:=$d7;
valuelist256[243]:=$5f;
valuelist256[244]:=$d7;
valuelist256[245]:=$ff;
valuelist256[246]:=$5f;
valuelist256[247]:=$ff;
valuelist256[248]:=$00;
valuelist256[249]:=$5f;
valuelist256[250]:=$ff;
valuelist256[251]:=$5f;
valuelist256[252]:=$5f;
valuelist256[253]:=$ff;
valuelist256[254]:=$87;
valuelist256[255]:=$5f;
valuelist256[256]:=$ff;
valuelist256[257]:=$af;
valuelist256[258]:=$5f;
valuelist256[259]:=$ff;
valuelist256[260]:=$d7;

valuelist256[261]:=$5f;
valuelist256[262]:=$ff;
valuelist256[263]:=$ff;
valuelist256[264]:=$87;
valuelist256[265]:=$00;
valuelist256[266]:=$00;
valuelist256[267]:=$87;
valuelist256[268]:=$00;
valuelist256[269]:=$5f;
valuelist256[270]:=$87;
valuelist256[271]:=$00;
valuelist256[272]:=$87;
valuelist256[273]:=$87;
valuelist256[274]:=$00;
valuelist256[275]:=$af;
valuelist256[276]:=$87;
valuelist256[277]:=$00;
valuelist256[278]:=$d7;
valuelist256[279]:=$87;
valuelist256[280]:=$00;
valuelist256[281]:=$ff;
valuelist256[282]:=$87;
valuelist256[283]:=$5f;
valuelist256[284]:=$00;
valuelist256[285]:=$87;
valuelist256[286]:=$5f;
valuelist256[287]:=$5f;
valuelist256[288]:=$87;
valuelist256[289]:=$5f;
valuelist256[290]:=$87;
valuelist256[291]:=$87;
valuelist256[292]:=$5f;
valuelist256[293]:=$af;
valuelist256[294]:=$87;
valuelist256[295]:=$5f;
valuelist256[296]:=$d7;
valuelist256[297]:=$87;
valuelist256[298]:=$5f;
valuelist256[299]:=$ff;
valuelist256[300]:=$87;

valuelist256[301]:=$87;
valuelist256[302]:=$00;
valuelist256[303]:=$87;
valuelist256[304]:=$87;
valuelist256[305]:=$5f;
valuelist256[306]:=$87;
valuelist256[307]:=$87;
valuelist256[308]:=$87;
valuelist256[309]:=$87;
valuelist256[310]:=$87;
valuelist256[311]:=$af;
valuelist256[312]:=$87;
valuelist256[313]:=$87;
valuelist256[314]:=$d7;
valuelist256[315]:=$87;
valuelist256[316]:=$87;
valuelist256[317]:=$ff;
valuelist256[318]:=$87;
valuelist256[319]:=$af;
valuelist256[320]:=$00;
valuelist256[321]:=$87;
valuelist256[322]:=$af;
valuelist256[323]:=$5f;
valuelist256[324]:=$87;
valuelist256[325]:=$af;
valuelist256[326]:=$87;
valuelist256[327]:=$87;
valuelist256[328]:=$af;
valuelist256[329]:=$af;
valuelist256[330]:=$87;
valuelist256[331]:=$af;
valuelist256[332]:=$d7;
valuelist256[333]:=$87;
valuelist256[334]:=$af;
valuelist256[335]:=$ff;
valuelist256[336]:=$87;
valuelist256[337]:=$d7;
valuelist256[338]:=$00;
valuelist256[339]:=$87;
valuelist256[340]:=$d7;
valuelist256[341]:=$5f;
valuelist256[342]:=$87;
valuelist256[343]:=$d7;
valuelist256[344]:=$87;
valuelist256[345]:=$87;
valuelist256[346]:=$d7;
valuelist256[347]:=$af;
valuelist256[348]:=$87;
valuelist256[349]:=$d7;
valuelist256[350]:=$d7;
valuelist256[351]:=$87;
valuelist256[352]:=$d7;
valuelist256[353]:=$ff;
valuelist256[354]:=$87;
valuelist256[355]:=$ff;
valuelist256[356]:=$00;
valuelist256[357]:=$87;
valuelist256[358]:=$ff;
valuelist256[359]:=$5f;
valuelist256[360]:=$87;
valuelist256[361]:=$ff;
valuelist256[362]:=$87;
valuelist256[363]:=$87;
valuelist256[364]:=$ff;
valuelist256[365]:=$af;
valuelist256[366]:=$87;
valuelist256[367]:=$ff;
valuelist256[368]:=$d7;
valuelist256[369]:=$87;
valuelist256[370]:=$ff;
valuelist256[371]:=$ff;
valuelist256[372]:=$af;
valuelist256[373]:=$00;
valuelist256[374]:=$00;
valuelist256[375]:=$af;
valuelist256[376]:=$00;
valuelist256[377]:=$5f;
valuelist256[378]:=$af;
valuelist256[379]:=$00;
valuelist256[380]:=$87;
valuelist256[381]:=$af;
valuelist256[382]:=$00;
valuelist256[383]:=$af;
valuelist256[384]:=$af;
valuelist256[385]:=$00;
valuelist256[386]:=$d7;
valuelist256[387]:=$af;
valuelist256[388]:=$00;
valuelist256[389]:=$af;
valuelist256[390]:=$af;
valuelist256[391]:=$5f;
valuelist256[392]:=$00;
valuelist256[393]:=$af;
valuelist256[394]:=$5f;
valuelist256[395]:=$5f;
valuelist256[396]:=$af;
valuelist256[397]:=$5f;
valuelist256[398]:=$87;
valuelist256[399]:=$af;
valuelist256[400]:=$5f;

valuelist256[401]:=$af;
valuelist256[402]:=$af;
valuelist256[403]:=$5f;
valuelist256[404]:=$d7;
valuelist256[405]:=$af;
valuelist256[406]:=$5f;
valuelist256[407]:=$ff;
valuelist256[408]:=$af;
valuelist256[409]:=$87;
valuelist256[410]:=$00;
valuelist256[411]:=$af;
valuelist256[412]:=$87;
valuelist256[413]:=$5f;
valuelist256[414]:=$af;
valuelist256[415]:=$87;
valuelist256[416]:=$87;
valuelist256[417]:=$af;
valuelist256[418]:=$87;
valuelist256[419]:=$af;
valuelist256[420]:=$af;
valuelist256[421]:=$87;
valuelist256[422]:=$d7;
valuelist256[423]:=$af;
valuelist256[424]:=$87;
valuelist256[425]:=$ff;
valuelist256[426]:=$af;
valuelist256[427]:=$af;
valuelist256[428]:=$00;
valuelist256[429]:=$af;
valuelist256[430]:=$af;
valuelist256[431]:=$5f;
valuelist256[432]:=$af;
valuelist256[433]:=$af;
valuelist256[434]:=$87;
valuelist256[435]:=$af;
valuelist256[436]:=$af;
valuelist256[437]:=$af;
valuelist256[438]:=$af;
valuelist256[439]:=$af;
valuelist256[440]:=$d7;


valuelist256[441]:=$af;
valuelist256[442]:=$af;
valuelist256[443]:=$ff;
valuelist256[444]:=$af;
valuelist256[445]:=$d7;
valuelist256[446]:=$00;
valuelist256[447]:=$af;
valuelist256[448]:=$d7;
valuelist256[449]:=$5f;

valuelist256[450]:=$af;
valuelist256[451]:=$d7;
valuelist256[452]:=$87;
valuelist256[453]:=$af;
valuelist256[454]:=$d7;
valuelist256[455]:=$af;
valuelist256[456]:=$af;
valuelist256[457]:=$d7;
valuelist256[458]:=$d7;
valuelist256[459]:=$af;

valuelist256[460]:=$d7;
valuelist256[461]:=$ff;
valuelist256[462]:=$af;
valuelist256[463]:=$ff;
valuelist256[464]:=$00;
valuelist256[465]:=$af;
valuelist256[466]:=$ff;
valuelist256[467]:=$5f;
valuelist256[468]:=$af;
valuelist256[469]:=$ff;

valuelist256[470]:=$87;
valuelist256[471]:=$af;
valuelist256[472]:=$ff;
valuelist256[473]:=$af;
valuelist256[474]:=$af;
valuelist256[475]:=$ff;
valuelist256[476]:=$d7;
valuelist256[477]:=$af;
valuelist256[478]:=$ff;
valuelist256[479]:=$ff;

valuelist256[480]:=$d7;
valuelist256[481]:=$00;
valuelist256[482]:=$00;
valuelist256[483]:=$d7;
valuelist256[484]:=$00;
valuelist256[485]:=$5f;
valuelist256[486]:=$d7;
valuelist256[487]:=$00;
valuelist256[488]:=$87;
valuelist256[489]:=$d7;
valuelist256[490]:=$00;

valuelist256[491]:=$af;
valuelist256[492]:=$d7;
valuelist256[493]:=$00;
valuelist256[494]:=$d7;
valuelist256[495]:=$d7;
valuelist256[496]:=$00;
valuelist256[497]:=$ff;
valuelist256[498]:=$d7;
valuelist256[499]:=$5f;

valuelist256[500]:=$00;
valuelist256[501]:=$d7;
valuelist256[502]:=$5f;
valuelist256[503]:=$5f;
valuelist256[504]:=$d7;
valuelist256[505]:=$5f;
valuelist256[506]:=$87;
valuelist256[507]:=$d7;
valuelist256[508]:=$5f;
valuelist256[509]:=$af;
valuelist256[510]:=$d7;
valuelist256[511]:=$5f;
valuelist256[512]:=$d7;
valuelist256[513]:=$d7;
valuelist256[514]:=$5f;
valuelist256[515]:=$ff;
valuelist256[516]:=$d7;
valuelist256[517]:=$87;
valuelist256[518]:=$00;
valuelist256[519]:=$d7;
valuelist256[520]:=$87;
valuelist256[521]:=$5f;
valuelist256[522]:=$d7;
valuelist256[523]:=$87;
valuelist256[524]:=$87;
valuelist256[525]:=$d7;
valuelist256[526]:=$87;
valuelist256[527]:=$af;
valuelist256[528]:=$d7;
valuelist256[529]:=$87;

valuelist256[530]:=$d7;
valuelist256[531]:=$d7;
valuelist256[532]:=$87;
valuelist256[533]:=$ff;
valuelist256[534]:=$d7;
valuelist256[535]:=$af;
valuelist256[536]:=$00;
valuelist256[537]:=$d7;
valuelist256[538]:=$af;
valuelist256[539]:=$5f;

valuelist256[540]:=$d7;
valuelist256[541]:=$af;
valuelist256[542]:=$87;
valuelist256[543]:=$d7;
valuelist256[544]:=$af;
valuelist256[545]:=$af;
valuelist256[546]:=$d7;
valuelist256[547]:=$af;
valuelist256[548]:=$d7;
valuelist256[549]:=$d7;
valuelist256[550]:=$af;
valuelist256[551]:=$ff;
valuelist256[552]:=$d7;
valuelist256[553]:=$d7;
valuelist256[554]:=$00;
valuelist256[555]:=$d7;
valuelist256[556]:=$d7;
valuelist256[557]:=$5f;
valuelist256[558]:=$d7;
valuelist256[559]:=$d7;
valuelist256[560]:=$87;

valuelist256[561]:=$d7;
valuelist256[562]:=$d7;
valuelist256[563]:=$af;
valuelist256[564]:=$d7;
valuelist256[565]:=$d7;
valuelist256[566]:=$d7;
valuelist256[567]:=$d7;
valuelist256[568]:=$d7;
valuelist256[569]:=$ff;

valuelist256[570]:=$d7;
valuelist256[571]:=$ff;
valuelist256[572]:=$00;
valuelist256[573]:=$d7;
valuelist256[574]:=$ff;
valuelist256[575]:=$5f;
valuelist256[576]:=$d7;
valuelist256[577]:=$ff;
valuelist256[578]:=$87;
valuelist256[579]:=$d7;

valuelist256[580]:=$ff;
valuelist256[581]:=$af;
valuelist256[582]:=$d7;
valuelist256[583]:=$ff;
valuelist256[584]:=$d7;
valuelist256[585]:=$d7;
valuelist256[586]:=$ff;
valuelist256[587]:=$ff;
valuelist256[588]:=$ff;
valuelist256[589]:=$00;

valuelist256[590]:=$00;
valuelist256[591]:=$ff;
valuelist256[592]:=$00;
valuelist256[593]:=$5f;
valuelist256[594]:=$ff;
valuelist256[595]:=$00;
valuelist256[596]:=$87;
valuelist256[597]:=$ff;
valuelist256[598]:=$00;
valuelist256[599]:=$af;

valuelist256[600]:=$ff;
valuelist256[601]:=$00;
valuelist256[602]:=$d7;
valuelist256[603]:=$ff;
valuelist256[604]:=$00;
valuelist256[605]:=$ff;
valuelist256[606]:=$ff;
valuelist256[607]:=$5f;
valuelist256[608]:=$00;
valuelist256[609]:=$ff;

valuelist256[610]:=$5f;
valuelist256[611]:=$5f;
valuelist256[612]:=$ff;
valuelist256[613]:=$5f;
valuelist256[614]:=$87;
valuelist256[615]:=$ff;
valuelist256[616]:=$5f;
valuelist256[617]:=$af;
valuelist256[618]:=$ff;
valuelist256[619]:=$5f;

valuelist256[620]:=$d7;
valuelist256[621]:=$ff;
valuelist256[622]:=$5f;
valuelist256[623]:=$ff;
valuelist256[624]:=$ff;
valuelist256[625]:=$87;
valuelist256[626]:=$00;
valuelist256[627]:=$ff;
valuelist256[628]:=$87;
valuelist256[629]:=$5f;

valuelist256[630]:=$ff;
valuelist256[631]:=$87;
valuelist256[632]:=$87;
valuelist256[633]:=$ff;
valuelist256[634]:=$87;
valuelist256[635]:=$af;
valuelist256[636]:=$ff;
valuelist256[637]:=$87;
valuelist256[638]:=$d7;
valuelist256[639]:=$ff;

valuelist256[640]:=$87;
valuelist256[641]:=$ff;
valuelist256[642]:=$ff;
valuelist256[643]:=$af;
valuelist256[644]:=$00;
valuelist256[645]:=$ff;
valuelist256[646]:=$af;
valuelist256[647]:=$5f;
valuelist256[648]:=$ff;
valuelist256[649]:=$af;

valuelist256[650]:=$87;
valuelist256[651]:=$ff;
valuelist256[652]:=$af;
valuelist256[653]:=$af;
valuelist256[654]:=$ff;
valuelist256[655]:=$af;
valuelist256[656]:=$d7;
valuelist256[657]:=$ff;
valuelist256[658]:=$af;
valuelist256[659]:=$ff;

valuelist256[660]:=$ff;
valuelist256[661]:=$d7;
valuelist256[662]:=$00;
valuelist256[663]:=$ff;
valuelist256[664]:=$d7;
valuelist256[665]:=$5f;
valuelist256[666]:=$ff;
valuelist256[667]:=$d7;
valuelist256[668]:=$87;
valuelist256[669]:=$ff;

valuelist256[670]:=$d7;
valuelist256[671]:=$af;
valuelist256[672]:=$ff;
valuelist256[673]:=$d7;
valuelist256[674]:=$d7;
valuelist256[675]:=$ff;
valuelist256[676]:=$d7;
valuelist256[677]:=$ff;
valuelist256[678]:=$ff;
valuelist256[679]:=$ff;

valuelist256[680]:=$00;
valuelist256[681]:=$ff;
valuelist256[682]:=$ff;
valuelist256[683]:=$5f;
valuelist256[684]:=$ff;
valuelist256[685]:=$ff;
valuelist256[686]:=$87;
valuelist256[687]:=$ff;
valuelist256[688]:=$ff;
valuelist256[689]:=$af;

valuelist256[690]:=$ff;
valuelist256[691]:=$ff;
valuelist256[692]:=$d7;
valuelist256[693]:=$ff;
valuelist256[694]:=$ff;
valuelist256[695]:=$ff;
valuelist256[696]:=$08;
valuelist256[697]:=$08;
valuelist256[698]:=$08;
valuelist256[699]:=$12;

valuelist256[700]:=$12;
valuelist256[701]:=$12;
valuelist256[702]:=$1c;
valuelist256[703]:=$1c;
valuelist256[704]:=$1c;
valuelist256[705]:=$26;
valuelist256[706]:=$26;
valuelist256[707]:=$26;
valuelist256[708]:=$30;
valuelist256[709]:=$30;

valuelist256[710]:=$30;
valuelist256[711]:=$3a;
valuelist256[712]:=$3a;
valuelist256[713]:=$3a;
valuelist256[714]:=$44;
valuelist256[715]:=$44;
valuelist256[716]:=$44;
valuelist256[717]:=$4e;
valuelist256[718]:=$4e;
valuelist256[719]:=$4e;

valuelist256[720]:=$58;
valuelist256[721]:=$58;
valuelist256[722]:=$58;
valuelist256[723]:=$62;
valuelist256[724]:=$62;
valuelist256[725]:=$62;
valuelist256[726]:=$6c;
valuelist256[727]:=$6c;
valuelist256[728]:=$6c;
valuelist256[729]:=$76;

valuelist256[730]:=$76;
valuelist256[731]:=$76;
valuelist256[732]:=$80;
valuelist256[733]:=$80;
valuelist256[734]:=$80;
valuelist256[735]:=$8a;
valuelist256[736]:=$8a;
valuelist256[737]:=$8a;
valuelist256[738]:=$94;
valuelist256[739]:=$94;

valuelist256[740]:=$94;
valuelist256[741]:=$9e;
valuelist256[742]:=$9e;
valuelist256[743]:=$9e;
valuelist256[744]:=$a8;
valuelist256[745]:=$a8;
valuelist256[746]:=$a8;
valuelist256[747]:=$b2;
valuelist256[748]:=$b2;
valuelist256[749]:=$b2;

valuelist256[750]:=$bc;
valuelist256[751]:=$bc;
valuelist256[752]:=$bc;
valuelist256[753]:=$c6;
valuelist256[754]:=$c6;
valuelist256[755]:=$c6;
valuelist256[756]:=$d0;
valuelist256[757]:=$d0;
valuelist256[758]:=$d0;
valuelist256[759]:=$da;

valuelist256[760]:=$da;
valuelist256[761]:=$da;
valuelist256[762]:=$e4;
valuelist256[763]:=$e4;
valuelist256[764]:=$e4;
valuelist256[765]:=$ee;
valuelist256[766]:=$ee;
valuelist256[767]:=$ee;

//correct for the wonky cga palette

   i:=0;
   num:=0; 
   repeat 
      Tpalette16.colors[num]^.r:=valuelist256[i];
      Tpalette16.colors[num]^.g:=valuelist256[i+1];
      Tpalette16.colors[num]^.b:=valuelist256[i+2];
      Tpalette16.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=7;

   i:=25;
   num:=8; 
   repeat 
      Tpalette256.colors[num]^.r:=valuelist256[i];
      Tpalette256.colors[num]^.g:=valuelist256[i+1];
      Tpalette256.colors[num]^.b:=valuelist256[i+2];
      Tpalette256.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=14;

  //white
      Tpalette256.colors[15]^.r:=$ff;
      Tpalette256.colors[15]^.g:=$ff;
      Tpalette256.colors[15]^.b:=$ff;
      Tpalette256.colors[15]^.a:=$ff;
  
//continue w rest of colors

   i:=48;
   num:=16; 
   repeat
      Tpalette256.colors[num]^.r:=valuelist256[i];
      Tpalette256.colors[num]^.g:=valuelist256[i+1];
      Tpalette256.colors[num]^.b:=valuelist256[i+2];
      Tpalette256.colors[num]^.a:=$ff; 
      inc(i,3);
      inc(num); 
  until num=767;

	
end;


//supply a filename like:
// yes, you should be using long file names
// PAL256C.dat or PAL256BW.dat

//(dont make me duplicate code to change two lines)

procedure Save256Palette(filename:string);

Var
	palette256File  : File of TRec256;
	i,num            : integer;

Begin

    //save us a lot of code and work
    initPalette256;
	Assign(palette256File, filename);
	ReWrite(palette256File);

	Write(palette256File, TPalette256); 
	Close(palette256File);
	
End;


procedure Read256Palette(filename:string; ReadColorFile:boolean);

Var
	palette256File  : File of TRec256;
	i,num            : integer;
    palette: PSDL_Palette;

Begin
	Assign(palette256File, filename);
	ReSet(palette256File);
    Seek(palette256File, 0); //find first record

	Read(palette256File, TPalette256); 
	Close(palette256File);	
    SDL_AllocPalette(256);    
    if ReadColorFile =true then
          SDL_SetPaletteColors(palette,Tpalette256.colors,0,256)
    else
          SDL_SetPaletteColors(palette,Tpalette256GRey.colors,0,256);

end;

