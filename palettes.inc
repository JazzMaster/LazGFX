//greyscale palettes are required for either loading or displaying in BW, or some subset thereof.
//this isnt "exactly" duplicated code

//hardspec it first, then allow user defined- or "pre-saved" files
//that not to say you cant init, save, then load thru the main code instead of useing the hard spec.

//the hardspec is here as a default setting, much like most 8x8 font sometimes are included
//by default in graphics modes source code.

//these are zero based colors. for 16 color modes- 88 or even 80 is not correct, 70 or 77 is.
// the 256 hex color data was pulled from xterm specs.


//the only guaranteed perfect palette code is (m)CGA -tweaked by me, and Greyscale 256.
//(greyscale mCGA is a hackish guess based on rough math, given 14 colors, and also black and white)


procedure init16PaletteGrey;

var
   i:integer;


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
   for num:=0 to 15 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;


TPalette16GRey.DWords[0]:=$000000ff;
TPalette16GRey.DWords[1]:=$111111ff;
TPalette16GRey.DWords[2]:=$222222ff;
TPalette16GRey.DWords[3]:=$333333ff;
TPalette16GRey.DWords[4]:=$444444ff;
TPalette16GRey.DWords[5]:=$555555ff;
TPalette16GRey.DWords[6]:=$666666ff;
TPalette16GRey.DWords[7]:=$777777ff;
TPalette16GRey.DWords[8]:=$888888ff;
TPalette16GRey.DWords[9]:=$999999ff;
TPalette16GRey.DWords[10]:=$aaaaaaff;
TPalette16GRey.DWords[11]:=$bbbbbbff;
TPalette16GRey.DWords[12]:=$ccccccff;
TPalette16GRey.DWords[13]:=$ddddddff;
TPalette16GRey.DWords[14]:=$eeeeeeff;
TPalette16GRey.DWords[15]:=$ffffffff; 


end;


procedure init256PaletteGrey;

//easy peasy to setup.


var
    i:integer;


begin  


//(we dont setup valuelist by hand this time)

   i:=0;
   num:=0; 
   for num:=0 to 768 do begin 
      palette256.colors[num].r:=hex(i);
      palette256.colors[num].g:=hex(i);
      palette256.colors[num].b:=hex(i);
      palette256.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i); //notice the difference <-HERE where RGB are the same values
      inc(num); 
  end;

	
//00-FF as shown above with all value the same in the DWord except the Alpha/transparency Bit, which stays at FF
//these need to be corrected before use
TPalette256.DWords[0]:=$000000ff;
TPalette256.DWords[1]:=$010101ff;
TPalette256.DWords[2]:=$020202ff;

TPalette256.DWords[3]:=$808000ff;
TPalette256.DWords[4]:=$000080ff;
TPalette256.DWords[5]:=$800080ff;
TPalette256.DWords[6]:=$008080ff;
TPalette256.DWords[7]:=$c0c0c0ff;
TPalette256.DWords[8]:=$808080ff;
TPalette256.DWords[9]:=$ff0000ff;
TPalette256.DWords[10]:=$00ff00ff;
TPalette256.DWords[11]:=$ffff00ff;
TPalette256.DWords[12]:=$0000ffff;
TPalette256.DWords[13]:=$ff00ffff;
TPalette256.DWords[14]:=$00ffffff;
TPalette256.DWords[15]:=$ffffffff;

TPalette256.DWords[16]:=$000000ff;
TPalette256.DWords[17]:=$00005fff,
TPalette256.DWords[18]:=$000087ff,
TPalette256.DWords[19]:=$0000afff,
TPalette256.DWords[20]:=$0000d7ff,
TPalette256.DWords[21]:=$0000ffff,
TPalette256.DWords[22]:=$005f00ff,
TPalette256.DWords[23]:=$005f5fff,
TPalette256.DWords[24]:=$005f87ff,
TPalette256.DWords[25]:=$005fafff,
TPalette256.DWords[26]:=$005fd7ff,
TPalette256.DWords[27]:=$005fffff,
TPalette256.DWords[28]:=$008700ff,
TPalette256.DWords[29]:=$00875fff,
TPalette256.DWords[30]:=$008787ff,

TPalette256.DWords[31]:=$0087afff,
TPalette256.DWords[32]:=$0087d7ff,
TPalette256.DWords[33]:=$0087ffff,
TPalette256.DWords[34]:=$00af00ff,
TPalette256.DWords[35]:=$00af5fff,
TPalette256.DWords[36]:=$00af87ff,
TPalette256.DWords[37]:=$00afafff,
TPalette256.DWords[38]:=$00afd7ff,
TPalette256.DWords[39]:=$00afffff,
TPalette256.DWords[40]:=$00d700ff,
TPalette256.DWords[41]:=$00d75fff,
TPalette256.DWords[42]:=$00d787ff,
TPalette256.DWords[43]:=$00d7afff,
TPalette256.DWords[44]:=$00d7d7ff,
TPalette256.DWords[45]:=$00d7ffff,

TPalette256.DWords[46]:=$00ff00ff,
TPalette256.DWords[47]:=$00ff5fff,
TPalette256.DWords[48]:=$00ff87ff,
TPalette256.DWords[49]:=$00ffafff,
TPalette256.DWords[50]:=$00ffd7ff,
TPalette256.DWords[51]:=$00ffffff,
TPalette256.DWords[52]:=$5f0000ff,
TPalette256.DWords[53]:=$5f005fff,
TPalette256.DWords[54]:=$5f0087ff,
TPalette256.DWords[55]:=$5f00afff,
TPalette256.DWords[56]:=$5f00d7ff,
TPalette256.DWords[57]:=$5f00ffff,
TPalette256.DWords[58]:=$5f5f00ff,
TPalette256.DWords[59]:=$5f5f5fff,
TPalette256.DWords[60]:=$5f5f87ff,

TPalette256.DWords[61]:=$5f5fafff,
TPalette256.DWords[62]:=$5f5fd7ff,
TPalette256.DWords[63]:=$5f5fffff,
TPalette256.DWords[64]:=$5f8700ff,
TPalette256.DWords[65]:=$5f875fff,
TPalette256.DWords[66]:=$5f8787ff,
TPalette256.DWords[67]:=$5f87afff,
TPalette256.DWords[68]:=$5f87d7ff,
TPalette256.DWords[69]:=$5f87ffff,
TPalette256.DWords[70]:=$5faf00ff,
TPalette256.DWords[71]:=$5faf5fff,
TPalette256.DWords[72]:=$5faf87ff,
TPalette256.DWords[73]:=$5fafafff,
TPalette256.DWords[74]:=$5fafd7ff,
TPalette256.DWords[75]:=$5fafffff,

TPalette256.DWords[76]:=$5fd700ff,
TPalette256.DWords[77]:=$5fd75fff,
TPalette256.DWords[78]:=$5fd787ff,
TPalette256.DWords[79]:=$5fd7afff,
TPalette256.DWords[80]:=$5fd7d7ff,
TPalette256.DWords[81]:=$5fd7ffff,
TPalette256.DWords[82]:=$5fff00ff,
TPalette256.DWords[83]:=$5fff5fff,
TPalette256.DWords[84]:=$5fff87ff,
TPalette256.DWords[85]:=$5fffafff,
TPalette256.DWords[86]:=$5fffd7ff,
TPalette256.DWords[87]:=$5fffffff,
TPalette256.DWords[88]:=$870000ff,
TPalette256.DWords[89]:=$87005fff,
TPalette256.DWords[90]:=$870087ff,

TPalette256.DWords[91]:=$8700afff,
TPalette256.DWords[92]:=$8700d7ff,
TPalette256.DWords[93]:=$8700ffff,
TPalette256.DWords[94]:=$875f00ff,
TPalette256.DWords[95]:=$875f5fff,
TPalette256.DWords[96]:=$875f87ff,
TPalette256.DWords[97]:=$875fafff,
TPalette256.DWords[98]:=$875fd7ff,
TPalette256.DWords[99]:=$875fffff,
TPalette256.DWords[100]:=$878700ff,
TPalette256.DWords[101]:=$87875fff,
TPalette256.DWords[102]:=$878787ff,
TPalette256.DWords[103]:=$8787afff,
TPalette256.DWords[104]:=$8787d7ff,
TPalette256.DWords[105]:=$8787ffff,

TPalette256.DWords[106]:=$87af00ff,
TPalette256.DWords[107]:=$87af5fff,
TPalette256.DWords[108]:=$87af87ff,
TPalette256.DWords[109]:=$87afafff,


TPalette256.DWords[110]:=$87afd7ff,
TPalette256.DWords[111]:=$87afffff,
TPalette256.DWords[112]:=$87d700ff,
TPalette256.DWords[113]:=$87d75fff,
TPalette256.DWords[114]:=$87d787ff,
TPalette256.DWords[115]:=$87d7afff,
TPalette256.DWords[116]:=$87d7d7ff,
TPalette256.DWords[117]:=$87d7ffff,
TPalette256.DWords[118]:=$87ff00ff
TPalette256.DWords[119]:=$87ff5fff,
TPalette256.DWords[120]:=$87ff87ff,

TPalette256.DWords[121]:=$87ffafff,
TPalette256.DWords[122]:=$87ffd7ff,
TPalette256.DWords[123]:=$87ffffff,
TPalette256.DWords[124]:=$af0000ff,
TPalette256.DWords[125]:=$af005fff,
TPalette256.DWords[126]:=$af0087ff,
TPalette256.DWords[127]:=$af00afff,
TPalette256.DWords[128]:=$af00d7ff,
TPalette256.DWords[129]:=$af00ffff,
TPalette256.DWords[130]:=$af5f00ff,
TPalette256.DWords[131]:=$af5f5fff,
TPalette256.DWords[132]:=$af5f87ff,
TPalette256.DWords[133]:=$af5fafff,
TPalette256.DWords[134]:=$af5fd7ff,
TPalette256.DWords[135]:=$af5fffff,

TPalette256.DWords[136]:=$af8700ff,
TPalette256.DWords[137]:=$af875fff,
TPalette256.DWords[138]:=$af8787ff,
TPalette256.DWords[139]:=$af87afff,
TPalette256.DWords[140]:=$af87d7ff,
TPalette256.DWords[141]:=$af87ffff,
TPalette256.DWords[142]:=$afaf00ff,
TPalette256.DWords[143]:=$afaf5fff,
TPalette256.DWords[144]:=$afaf87ff,
TPalette256.DWords[145]:=$afafafff,
TPalette256.DWords[146]:=$afafd7ff,
TPalette256.DWords[147]:=$afafffff,
TPalette256.DWords[148]:=$afd700ff,
TPalette256.DWords[149]:=$afd75fff,
TPalette256.DWords[150]:=$afd787ff,

TPalette256.DWords[151]:=$afd7afff,
TPalette256.DWords[152]:=$afd7d7ff,
TPalette256.DWords[153]:=$afd7ffff,
TPalette256.DWords[154]:=$afff00ff,
TPalette256.DWords[155]:=$afff5fff,
TPalette256.DWords[156]:=$afff87ff,
TPalette256.DWords[157]:=$afffafff,
TPalette256.DWords[158]:=$afffd7ff,
TPalette256.DWords[159]:=$afffffff,
TPalette256.DWords[160]:=$d70000ff,
TPalette256.DWords[161]:=$d7005fff,
TPalette256.DWords[162]:=$d70087ff,
TPalette256.DWords[163]:=$d700afff,
TPalette256.DWords[164]:=$d700d7ff,
TPalette256.DWords[165]:=$d700ffff,

TPalette256.DWords[166]:=$d75f00ff,
TPalette256.DWords[167]:=$d75f5fff,
TPalette256.DWords[168]:=$d75f87ff,
TPalette256.DWords[169]:=$d75fafff,
TPalette256.DWords[170]:=$d75fd7ff,
TPalette256.DWords[171]:=$d75fffff,
TPalette256.DWords[172]:=$d78700ff,
TPalette256.DWords[173]:=$d7875fff,
TPalette256.DWords[174]:=$d78787ff,
TPalette256.DWords[175]:=$d787afff,
TPalette256.DWords[176]:=$d787d7ff,
TPalette256.DWords[177]:=$d787ffff,
TPalette256.DWords[178]:=$d7af00ff,
TPalette256.DWords[179]:=$d7af5fff,
TPalette256.DWords[180]:=$d7af87ff,

TPalette256.DWords[181]:=$d7afafff,
TPalette256.DWords[182]:=$d7afd7ff,
TPalette256.DWords[183]:=$d7afffff,
TPalette256.DWords[184]:=$d7d700ff,
TPalette256.DWords[185]:=$d7d75fff,
TPalette256.DWords[186]:=$d7d787ff,
TPalette256.DWords[187]:=$d7d7afff,
TPalette256.DWords[188]:=$d7d7d7ff,
TPalette256.DWords[189]:=$d7d7ffff,
TPalette256.DWords[190]:=$d7ff00ff,
TPalette256.DWords[191]:=$d7ff5fff,
TPalette256.DWords[192]:=$d7ff87ff,
TPalette256.DWords[193]:=$d7ffafff,
TPalette256.DWords[194]:=$d7ffd7ff,
TPalette256.DWords[195]:=$d7ffffff,

TPalette256.DWords[196]:=$ff0000ff,
TPalette256.DWords[197]:=$ff005fff,
TPalette256.DWords[198]:=$ff0087ff,
TPalette256.DWords[199]:=$ff00afff,
TPalette256.DWords[200]:=$ff00d7ff,
TPalette256.DWords[201]:=$ff00ffff,
TPalette256.DWords[202]:=$ff5f00ff,
TPalette256.DWords[203]:=$ff5f5fff,
TPalette256.DWords[204]:=$ff5f87ff,
TPalette256.DWords[205]:=$ff5fafff,
TPalette256.DWords[206]:=$ff5fd7ff,
TPalette256.DWords[207]:=$ff5fffff,
TPalette256.DWords[208]:=$ff8700ff,
TPalette256.DWords[209]:=$ff875fff,
TPalette256.DWords[210]:=$ff8787ff,

TPalette256.DWords[211]:=$ff87afff,
TPalette256.DWords[212]:=$ff87d7ff,
TPalette256.DWords[213]:=$ff87ffff,
TPalette256.DWords[214]:=$ffaf00ff,
TPalette256.DWords[215]:=$ffaf5fff,
TPalette256.DWords[216]:=$ffaf87ff,
TPalette256.DWords[217]:=$ffafafff,
TPalette256.DWords[218]:=$ffafd7ff,
TPalette256.DWords[219]:=$ffafffff,
TPalette256.DWords[220]:=$ffd700ff,

TPalette256.DWords[221]:=$ffd75fff,
TPalette256.DWords[222]:=$ffd787ff,
TPalette256.DWords[223]:=$ffd7afff,
TPalette256.DWords[224]:=$ffd7d7ff,

TPalette256.DWords[225]:=$ffd7ffff,
TPalette256.DWords[226]:=$ffff00ff,
TPalette256.DWords[227]:=$ffff5fff,
TPalette256.DWords[228]:=$ffff87ff,
TPalette256.DWords[229]:=$ffffafff,
TPalette256.DWords[230]:=$ffffd7ff,


TPalette256.DWords[231]:=$ffffffff;
TPalette256.DWords[232]:=$080808ff;
TPalette256.DWords[233]:=$121212ff;
TPalette256.DWords[234]:=$1c1c1cff;
TPalette256.DWords[235]:=$262626ff;
TPalette256.DWords[236]:=$303030ff;
TPalette256.DWords[237]:=$3a3a3aff;
TPalette256.DWords[238]:=$444444ff;
TPalette256.DWords[239]:=$4e4e4eff;
TPalette256.DWords[240]:=$585858ff;
TPalette256.DWords[241]:=$626262ff;
TPalette256.DWords[242]:=$6c6c6cff;
TPalette256.DWords[243]:=$767676ff;
TPalette256.DWords[244]:=$808080ff;
TPalette256.DWords[245]:=$8a8a8aff;
TPalette256.DWords[246]:=$949494ff;
TPalette256.DWords[247]:=$9e9e9eff;
TPalette256.DWords[248]:=$a8a8a8ff;
TPalette256.DWords[249]:=$b2b2b2ff;
TPalette256.DWords[250]:=$bcbcbcff;
TPalette256.DWords[251]:=$c6c6c6ff;
TPalette256.DWords[252]:=$d0d0d0ff;
TPalette256.DWords[253]:=$dadadaff;
TPalette256.DWords[254]:=$e4e4e4ff;
TPalette256.DWords[255]:=$eeeeeeff;



end;

//FIXED- for good this time. (Oct-19-18)
procedure init16Palette;

var
   i:integer;
//80 in hex is beyond the halfway point at 128. 127 (7f) is more correct.

begin  
//Color Sequence:
//K HiR HiG HiB HiC HiM HiY HiGR LoGr LoR LoG LoB LoC LoM LoY W

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;

valuelist16[3]:=$ff;
valuelist16[4]:=$00;
valuelist16[5]:=$00;

valuelist16[6]:=$00;
valuelist16[7]:=$ff;
valuelist16[8]:=$00;

valuelist16[9]:=$ff;
valuelist16[10]:=$ff;
valuelist16[11]:=$00;

valuelist16[12]:=$00;
valuelist16[13]:=$00;
valuelist16[14]:=$ff;

valuelist16[15]:=$ff;
valuelist16[16]:=$00;
valuelist16[17]:=$ff;

valuelist16[18]:=$ff;
valuelist16[19]:=$ff;
valuelist16[20]:=$00;


valuelist16[21]:=$c0;
valuelist16[22]:=$c0;
valuelist16[23]:=$c0;

valuelist16[24]:=$7f;
valuelist16[25]:=$7f;
valuelist16[26]:=$7f;


valuelist16[27]:=$7f;
valuelist16[28]:=$00;
valuelist16[29]:=$00;

valuelist16[30]:=$00;
valuelist16[31]:=$7f;
valuelist16[32]:=$00;

valuelist16[33]:=$7f;
valuelist16[34]:=$7f;
valuelist16[35]:=$00;

valuelist16[36]:=$00;
valuelist16[37]:=$00;
valuelist16[38]:=$7f;

valuelist16[39]:=$7f;
valuelist16[40]:=$00;
valuelist16[41]:=$7f;

valuelist16[42]:=$00;
valuelist16[43]:=$7f;
valuelist16[44]:=$7f;

valuelist16[45]:=$ff;
valuelist16[46]:=$ff;
valuelist16[47]:=$ff;


   i:=0;
   num:=0; 
   for num:=0 to 14 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      //see the remmed out notes below
      inc(i,3);
      inc(num); 
  end;

//This is the proper way to do it but we have transparencys, not just intensities now.
//mucking w the alpha bit changes opacity levels- we dont want that.
//so we assume we are not going to "muck with it". 
//YOU can if you want.

{
//yes this is hackish- as were the days of (m)CGA...

   i:=0;
   num:=0; 
   for num:=0 to 7 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;


  num:=8;//force it
  i:=24;
   for num:=8 to 14 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#7f; 
      inc(i,3);
      inc(num); 
  end;

  Tpalette16.colors[15].r:=valuelist16[45];
  Tpalette16.colors[15].g:=valuelist16[46];
  Tpalette16.colors[15].b:=valuelist16[47];
  Tpalette16.colors[15].a:=#ff; 

Color Sequence:

K HiR HiG HiB HiC HiM HiY HiGR LoGr LoR LoG LoB LoC LoM LoY W
}


TPalette16.DWords[0]:=$000000ff;

TPalette16.DWords[1]:=$ff0000ff;
TPalette16.DWords[2]:=$00ff00ff;
TPalette16.DWords[3]:=$ffff00ff;

TPalette16.DWords[4]:=$0000ffff;
TPalette16.DWords[5]:=$ff00ffff;
TPalette16.DWords[6]:=$ffff55ff;


TPalette16.DWords[7]:=$c0c0c0ff;
TPalette16.DWords[8]:=$7f7f7fff;

TPalette16.DWords[9]:=$7f0000ff;
TPalette16.DWords[10]:=$007f00ff;
TPalette16.DWords[11]:=$7f7f00ff;

TPalette16.DWords[12]:=$00007fff;
TPalette16.DWords[13]:=$7f007fff;
TPalette16.DWords[14]:=$007f7fff;

TPalette16.DWords[15]:=$ffffffff;

end;


procedure Save16Palette(filename:string);

Var
	palette16File  : File of Tpalette16;
	i,num            : integer;

Begin
	init16Palette;
	Assign(palette16File, filename);
	ReWrite(palette16File);
    
	For num := 1 to 16 do

	Begin;
	  Write(palette16File, TPalette16.colors[num]); //sdl_Color
      inc(num);
	End;


    i:=0;
	For i := 1 to 16 do
	Begin;
		Write(palette16File, TPalette16.DWords[i]); //dword
		inc(i);
	End;

	Close(palette16File);
	
End;

procedure Read16Palette(filename:string);

Var
	palette16File  : File of Tpalette16;
	i,num            : integer;

Begin
	Assign(palette16File, filename);
	ReSet(palette16File);
    Seek(palette16File, 0); //find first record
    
	For num := 1 to 16 do

	Begin;
	  Read(palette16File, TPalette16.colors[num]); //sdl_Color
      inc(num); 
	End;

    i:=0;
	For i := 1 to 16 do
	Begin;
		Read(palette16File, TPalette16.DWords[i]); //dword
		inc(i);
	End;

	Close(palette16File);
	//much much easier now....
    SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, Tpalette16.colors, 0, 16 );

end;

procedure init256Palette;

//furthermore there are other 256rgb palettes.
//semi-accurate as per xterm specs.


var
    i:integer;


begin  

valuelist256[0]:=$00;
valuelist256[1]:=$00;
valuelist256[2]:=$00;
valuelist256[3]:=$ff;
valuelist256[4]:=$00;
valuelist256[5]:=$00;
valuelist256[6]:=$00;
valuelist256[7]:=$ff;
valuelist256[8]:=$00;
valuelist256[9]:=$ff;
valuelist256[10]:=$ff;
valuelist256[11]:=$00;
valuelist256[12]:=$00;
valuelist256[13]:=$00;
valuelist256[14]:=$ff;
valuelist256[15]:=$ff;
valuelist256[16]:=$00;
valuelist256[17]:=$ff;
valuelist256[18]:=$ff;
valuelist256[19]:=$ff;
valuelist256[20]:=$00;
valuelist256[21]:=$c0;
valuelist256[22]:=$c0;
valuelist256[23]:=$c0;
valuelist256[24]:=$7f;
valuelist256[25]:=$7f;
valuelist256[26]:=$7f;
valuelist256[27]:=$7f;
valuelist256[28]:=$00;
valuelist256[29]:=$00;
valuelist256[30]:=$00;
valuelist256[31]:=$7f;
valuelist256[32]:=$00;
valuelist256[33]:=$7f;
valuelist256[34]:=$7f;
valuelist256[35]:=$00;
valuelist256[36]:=$00;
valuelist256[37]:=$00;
valuelist256[38]:=$7f;
valuelist256[39]:=$7f;
valuelist256[40]:=$00;
valuelist256[41]:=$7f;
valuelist256[42]:=$00;
valuelist256[43]:=$7f;
valuelist256[44]:=$7f;
valuelist256[45]:=$ff;
valuelist256[46]:=$ff;
valuelist256[47]:=$ff;
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

valuelist256[]:=$5f
valuelist256[]:=$00
valuelist256[]:=$af

valuelist256[]:=$5f
valuelist256[]:=$00
valuelist256[]:=$d7


//more to come!
{

$5f, $00, $ff,
$5f, $5f, $00,
$5f, $5f, $5f,
$5f, $5f, $87,
$5f, $5f, $af,
$5f, $5f, $d7,
$5f, $5f, $ff,
$5f, $87, $00,

$5f, $87, $5f,
$5f, $87, $87,
$5f, $87, $af,
$5f, $87, $d7,
$5f, $87, $ff,
$5f, $af, $00,
$5f, $af, $5f,
$5f, $af, $87,
$5f, $af, $af,
$5f, $af, $d7,

$5f, $af, $ff,
$5f, $d7, $00,
$5f, $d7, $5f,
$5f, $d7, $87,
$5f, $d7, $af,
$5f, $d7, $d7,
$5f, $d7, $ff,
$5f, $ff, $00,
$5f, $ff, $5f,
$5f, $ff, $87,

$5f, $ff, $af,
$5f, $ff, $d7,
$5f, $ff, $ff,
$87, $00, $00,
$87, $00, $5f,
$87, $00, $87,
$87, $00, $af,
$87, $00, $d7,
$87, $00, $ff,
$87, $5f, $00,

$87, $5f, $5f,
$87, $5f, $87,
$87, $5f, $af,
$87, $5f, $d7,
$87, $5f, $ff,
$87, $87, $00,
$87, $87, $5f,
$87, $87, $87,
$87, $87, $af,
$87, $87, $d7,

$87, $87, $ff,
$87, $af, $00,
$87, $af, $5f,
$87, $af, $87,
$87, $af, $af,
$87, $af, $d7,
$87, $af, $ff,
$87, $d7, $00,
$87, $d7, $5f,
$87, $d7, $87,

$87, $d7, $af,
$87, $d7, $d7,
$87, $d7, $ff,
$87, $ff, $00,
$87, $ff, $5f,
$87, $ff, $87,
$87, $ff, $af,
$87, $ff, $d7,
$87, $ff, $ff,
$af, $00, $00,

$af, $00, $5f,
$af, $00, $87,
$af, $00, $af,
$af, $00, $d7,
$af, $00, $ff,
$af, $5f, $00,
$af, $5f, $5f,
$af, $5f, $87,
$af, $5f, $af,
$af, $5f, $d7,

$af, $5f, $ff,
$af, $87, $00,
$af, $87, $5f,
$af, $87, $87,
$af, $87, $af,
$af, $87, $d7,

$af, $87, $ff,
$af, $af, $00,
$af, $af, $5f,
$af, $af, $87,
$af, $af, $af,
$af, $af, $d7,
$af, $af, $ff,
$af, $d7, $00,
$af, $d7, $5f,
$af, $d7, $87,
$af, $d7, $af,

$af, $d7, $d7,
$af, $d7, $ff,
$af, $ff, $00,
$af, $ff, $5f,
$af, $ff, $87,
$af, $ff, $af,
$af, $ff, $d7,
$af, $ff, $ff,
$d7, $00, $00,
$d7, $00, $5f,
$d7, $00, $87,

$d7, $00, $af,
$d7, $00, $d7,
$d7, $00, $ff,
$d7, $5f, $00,
$d7, $5f, $5f,
$d7, $5f, $87,
$d7, $5f, $af,
$d7, $5f, $d7,
$d7, $5f, $ff,
$d7, $87, $00,
$d7, $87, $5f,

$d7, $87, $87,
$d7, $87, $af,
$d7, $87, $d7,
$d7, $87, $ff,
$d7, $af, $00,
$d7, $af, $5f,
$d7, $af, $87,
$d7, $af, $af,
$d7, $af, $d7,
$d7, $af, $ff,
$d7, $d7, $00,

$d7, $d7, $5f,
$d7, $d7, $87,
$d7, $d7, $af,
$d7, $d7, $d7,
$d7, $d7, $ff,
$d7, $ff, $00,
$d7, $ff, $5f,
$d7, $ff, $87,
$d7, $ff, $af,
$d7, $ff, $d7,
$d7, $ff, $ff,

$ff, $00, $00,
$ff, $00, $5f,
$ff, $00, $87,
$ff, $00, $af,
$ff, $00, $d7,
$ff, $00, $ff,
$ff, $5f, $00,
$ff, $5f, $5f,
$ff, $5f, $87,
$ff, $5f, $af,
$ff, $5f, $d7,

$ff, $5f, $ff,
$ff, $87, $00,
$ff, $87, $5f,
$ff, $87, $87,
$ff, $87, $af,
$ff, $87, $d7,
$ff, $87, $ff,
$ff, $af, $00,
$ff, $af, $5f,
$ff, $af, $87,
$ff, $af, $af,
$ff, $af, $d7,

$ff, $af, $ff,
$ff, $d7, $00,
$ff, $d7, $5f,
$ff, $d7, $87,
$ff, $d7, $af,
$ff, $d7, $d7,
$ff, $d7, $ff,
$ff, $ff, $00,
$ff, $ff, $5f,
$ff, $ff, $87,
$ff, $ff, $af,

$ff, $ff, $d7,
$ff, $ff, $ff,
$08, $08, $08,
$12, $12, $12,
$1c, $1c, $1c,
$26, $26, $26,
$30, $30, $30,
$3a, $3a, $3a,
$44, $44, $44,
$4e, $4e, $4e,
$58, $58, $58,

$62, $62, $62,
$6c, $6c, $6c,
$76, $76, $76,
$80, $80, $80,
$8a, $8a, $8a,
$94, $94, $94,
$9e, $9e, $9e,
$a8, $a8, $a8,
$b2, $b2, $b2,
$bc, $bc, $bc,

$c6, $c6, $c6,
$d0, $d0, $d0,
$da, $da, $da,
$e4, $e4, $e4,
$ee, $ee, $ee
}


   i:=0;
   num:=0; 
   for num:=0 to 768 do begin 
      palette256.colors[num].r:=valuelist256[i];
      palette256.colors[num].g:=valuelist256[i+1];
      palette256.colors[num].b:=valuelist256[i+2];
      palette256.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;

	
//256 color VGA palette based on XTerm colors(Unix)
//first 16 colors now should be more accurate!

TPalette256.DWords[0]:=$000000ff;
TPalette256.DWords[1]:=$ff0000ff;
TPalette256.DWords[2]:=$00ff00ff;
TPalette256.DWords[3]:=$ffff00ff;
TPalette256.DWords[4]:=$0000ffff;
TPalette256.DWords[5]:=$ff00ffff;
TPalette256.DWords[6]:=$ffff55ff;
TPalette256.DWords[7]:=$c0c0c0ff;
TPalette256.DWords[8]:=$7f7f7fff;
TPalette256.DWords[9]:=$7f0000ff;
TPalette256.DWords[10]:=$007f00ff;
TPalette256.DWords[11]:=$7f7f00ff;
TPalette256.DWords[12]:=$00007fff;
TPalette256.DWords[13]:=$7f007fff;
TPalette256.DWords[14]:=$007f7fff;
TPalette256.DWords[15]:=$ffffffff;

TPalette256.DWords[16]:=$000000ff;
TPalette256.DWords[17]:=$00005fff,
TPalette256.DWords[18]:=$000087ff,
TPalette256.DWords[19]:=$0000afff,
TPalette256.DWords[20]:=$0000d7ff,
TPalette256.DWords[21]:=$0000ffff,
TPalette256.DWords[22]:=$005f00ff,
TPalette256.DWords[23]:=$005f5fff,
TPalette256.DWords[24]:=$005f87ff,
TPalette256.DWords[25]:=$005fafff,
TPalette256.DWords[26]:=$005fd7ff,
TPalette256.DWords[27]:=$005fffff,
TPalette256.DWords[28]:=$008700ff,
TPalette256.DWords[29]:=$00875fff,
TPalette256.DWords[30]:=$008787ff,

TPalette256.DWords[31]:=$0087afff,
TPalette256.DWords[32]:=$0087d7ff,
TPalette256.DWords[33]:=$0087ffff,
TPalette256.DWords[34]:=$00af00ff,
TPalette256.DWords[35]:=$00af5fff,
TPalette256.DWords[36]:=$00af87ff,
TPalette256.DWords[37]:=$00afafff,
TPalette256.DWords[38]:=$00afd7ff,
TPalette256.DWords[39]:=$00afffff,
TPalette256.DWords[40]:=$00d700ff,
TPalette256.DWords[41]:=$00d75fff,
TPalette256.DWords[42]:=$00d787ff,
TPalette256.DWords[43]:=$00d7afff,
TPalette256.DWords[44]:=$00d7d7ff,
TPalette256.DWords[45]:=$00d7ffff,

TPalette256.DWords[46]:=$00ff00ff,
TPalette256.DWords[47]:=$00ff5fff,
TPalette256.DWords[48]:=$00ff87ff,
TPalette256.DWords[49]:=$00ffafff,
TPalette256.DWords[50]:=$00ffd7ff,
TPalette256.DWords[51]:=$00ffffff,
TPalette256.DWords[52]:=$5f0000ff,
TPalette256.DWords[53]:=$5f005fff,
TPalette256.DWords[54]:=$5f0087ff,
TPalette256.DWords[55]:=$5f00afff,
TPalette256.DWords[56]:=$5f00d7ff,
TPalette256.DWords[57]:=$5f00ffff,
TPalette256.DWords[58]:=$5f5f00ff,
TPalette256.DWords[59]:=$5f5f5fff,
TPalette256.DWords[60]:=$5f5f87ff,

TPalette256.DWords[61]:=$5f5fafff,
TPalette256.DWords[62]:=$5f5fd7ff,
TPalette256.DWords[63]:=$5f5fffff,
TPalette256.DWords[64]:=$5f8700ff,
TPalette256.DWords[65]:=$5f875fff,
TPalette256.DWords[66]:=$5f8787ff,
TPalette256.DWords[67]:=$5f87afff,
TPalette256.DWords[68]:=$5f87d7ff,
TPalette256.DWords[69]:=$5f87ffff,
TPalette256.DWords[70]:=$5faf00ff,
TPalette256.DWords[71]:=$5faf5fff,
TPalette256.DWords[72]:=$5faf87ff,
TPalette256.DWords[73]:=$5fafafff,
TPalette256.DWords[74]:=$5fafd7ff,
TPalette256.DWords[75]:=$5fafffff,

TPalette256.DWords[76]:=$5fd700ff,
TPalette256.DWords[77]:=$5fd75fff,
TPalette256.DWords[78]:=$5fd787ff,
TPalette256.DWords[79]:=$5fd7afff,
TPalette256.DWords[80]:=$5fd7d7ff,
TPalette256.DWords[81]:=$5fd7ffff,
TPalette256.DWords[82]:=$5fff00ff,
TPalette256.DWords[83]:=$5fff5fff,
TPalette256.DWords[84]:=$5fff87ff,
TPalette256.DWords[85]:=$5fffafff,
TPalette256.DWords[86]:=$5fffd7ff,
TPalette256.DWords[87]:=$5fffffff,
TPalette256.DWords[88]:=$870000ff,
TPalette256.DWords[89]:=$87005fff,
TPalette256.DWords[90]:=$870087ff,

TPalette256.DWords[91]:=$8700afff,
TPalette256.DWords[92]:=$8700d7ff,
TPalette256.DWords[93]:=$8700ffff,
TPalette256.DWords[94]:=$875f00ff,
TPalette256.DWords[95]:=$875f5fff,
TPalette256.DWords[96]:=$875f87ff,
TPalette256.DWords[97]:=$875fafff,
TPalette256.DWords[98]:=$875fd7ff,
TPalette256.DWords[99]:=$875fffff,
TPalette256.DWords[100]:=$878700ff,
TPalette256.DWords[101]:=$87875fff,
TPalette256.DWords[102]:=$878787ff,
TPalette256.DWords[103]:=$8787afff,
TPalette256.DWords[104]:=$8787d7ff,
TPalette256.DWords[105]:=$8787ffff,

TPalette256.DWords[106]:=$87af00ff,
TPalette256.DWords[107]:=$87af5fff,
TPalette256.DWords[108]:=$87af87ff,
TPalette256.DWords[109]:=$87afafff,


TPalette256.DWords[110]:=$87afd7ff,
TPalette256.DWords[111]:=$87afffff,
TPalette256.DWords[112]:=$87d700ff,
TPalette256.DWords[113]:=$87d75fff,
TPalette256.DWords[114]:=$87d787ff,
TPalette256.DWords[115]:=$87d7afff,
TPalette256.DWords[116]:=$87d7d7ff,
TPalette256.DWords[117]:=$87d7ffff,
TPalette256.DWords[118]:=$87ff00ff
TPalette256.DWords[119]:=$87ff5fff,
TPalette256.DWords[120]:=$87ff87ff,

TPalette256.DWords[121]:=$87ffafff,
TPalette256.DWords[122]:=$87ffd7ff,
TPalette256.DWords[123]:=$87ffffff,
TPalette256.DWords[124]:=$af0000ff,
TPalette256.DWords[125]:=$af005fff,
TPalette256.DWords[126]:=$af0087ff,
TPalette256.DWords[127]:=$af00afff,
TPalette256.DWords[128]:=$af00d7ff,
TPalette256.DWords[129]:=$af00ffff,
TPalette256.DWords[130]:=$af5f00ff,
TPalette256.DWords[131]:=$af5f5fff,
TPalette256.DWords[132]:=$af5f87ff,
TPalette256.DWords[133]:=$af5fafff,
TPalette256.DWords[134]:=$af5fd7ff,
TPalette256.DWords[135]:=$af5fffff,

TPalette256.DWords[136]:=$af8700ff,
TPalette256.DWords[137]:=$af875fff,
TPalette256.DWords[138]:=$af8787ff,
TPalette256.DWords[139]:=$af87afff,
TPalette256.DWords[140]:=$af87d7ff,
TPalette256.DWords[141]:=$af87ffff,
TPalette256.DWords[142]:=$afaf00ff,
TPalette256.DWords[143]:=$afaf5fff,
TPalette256.DWords[144]:=$afaf87ff,
TPalette256.DWords[145]:=$afafafff,
TPalette256.DWords[146]:=$afafd7ff,
TPalette256.DWords[147]:=$afafffff,
TPalette256.DWords[148]:=$afd700ff,
TPalette256.DWords[149]:=$afd75fff,
TPalette256.DWords[150]:=$afd787ff,

TPalette256.DWords[151]:=$afd7afff,
TPalette256.DWords[152]:=$afd7d7ff,
TPalette256.DWords[153]:=$afd7ffff,
TPalette256.DWords[154]:=$afff00ff,
TPalette256.DWords[155]:=$afff5fff,
TPalette256.DWords[156]:=$afff87ff,
TPalette256.DWords[157]:=$afffafff,
TPalette256.DWords[158]:=$afffd7ff,
TPalette256.DWords[159]:=$afffffff,
TPalette256.DWords[160]:=$d70000ff,
TPalette256.DWords[161]:=$d7005fff,
TPalette256.DWords[162]:=$d70087ff,
TPalette256.DWords[163]:=$d700afff,
TPalette256.DWords[164]:=$d700d7ff,
TPalette256.DWords[165]:=$d700ffff,

TPalette256.DWords[166]:=$d75f00ff,
TPalette256.DWords[167]:=$d75f5fff,
TPalette256.DWords[168]:=$d75f87ff,
TPalette256.DWords[169]:=$d75fafff,
TPalette256.DWords[170]:=$d75fd7ff,
TPalette256.DWords[171]:=$d75fffff,
TPalette256.DWords[172]:=$d78700ff,
TPalette256.DWords[173]:=$d7875fff,
TPalette256.DWords[174]:=$d78787ff,
TPalette256.DWords[175]:=$d787afff,
TPalette256.DWords[176]:=$d787d7ff,
TPalette256.DWords[177]:=$d787ffff,
TPalette256.DWords[178]:=$d7af00ff,
TPalette256.DWords[179]:=$d7af5fff,
TPalette256.DWords[180]:=$d7af87ff,

TPalette256.DWords[181]:=$d7afafff,
TPalette256.DWords[182]:=$d7afd7ff,
TPalette256.DWords[183]:=$d7afffff,
TPalette256.DWords[184]:=$d7d700ff,
TPalette256.DWords[185]:=$d7d75fff,
TPalette256.DWords[186]:=$d7d787ff,
TPalette256.DWords[187]:=$d7d7afff,
TPalette256.DWords[188]:=$d7d7d7ff,
TPalette256.DWords[189]:=$d7d7ffff,
TPalette256.DWords[190]:=$d7ff00ff,
TPalette256.DWords[191]:=$d7ff5fff,
TPalette256.DWords[192]:=$d7ff87ff,
TPalette256.DWords[193]:=$d7ffafff,
TPalette256.DWords[194]:=$d7ffd7ff,
TPalette256.DWords[195]:=$d7ffffff,

TPalette256.DWords[196]:=$ff0000ff,
TPalette256.DWords[197]:=$ff005fff,
TPalette256.DWords[198]:=$ff0087ff,
TPalette256.DWords[199]:=$ff00afff,
TPalette256.DWords[200]:=$ff00d7ff,
TPalette256.DWords[201]:=$ff00ffff,
TPalette256.DWords[202]:=$ff5f00ff,
TPalette256.DWords[203]:=$ff5f5fff,
TPalette256.DWords[204]:=$ff5f87ff,
TPalette256.DWords[205]:=$ff5fafff,
TPalette256.DWords[206]:=$ff5fd7ff,
TPalette256.DWords[207]:=$ff5fffff,
TPalette256.DWords[208]:=$ff8700ff,
TPalette256.DWords[209]:=$ff875fff,
TPalette256.DWords[210]:=$ff8787ff,

TPalette256.DWords[211]:=$ff87afff,
TPalette256.DWords[212]:=$ff87d7ff,
TPalette256.DWords[213]:=$ff87ffff,
TPalette256.DWords[214]:=$ffaf00ff,
TPalette256.DWords[215]:=$ffaf5fff,
TPalette256.DWords[216]:=$ffaf87ff,
TPalette256.DWords[217]:=$ffafafff,
TPalette256.DWords[218]:=$ffafd7ff,
TPalette256.DWords[219]:=$ffafffff,
TPalette256.DWords[220]:=$ffd700ff,

TPalette256.DWords[221]:=$ffd75fff,
TPalette256.DWords[222]:=$ffd787ff,
TPalette256.DWords[223]:=$ffd7afff,
TPalette256.DWords[224]:=$ffd7d7ff,

TPalette256.DWords[225]:=$ffd7ffff,
TPalette256.DWords[226]:=$ffff00ff,
TPalette256.DWords[227]:=$ffff5fff,
TPalette256.DWords[228]:=$ffff87ff,
TPalette256.DWords[229]:=$ffffafff,
TPalette256.DWords[230]:=$ffffd7ff,


TPalette256.DWords[231]:=$ffffffff;
TPalette256.DWords[232]:=$080808ff;
TPalette256.DWords[233]:=$121212ff;
TPalette256.DWords[234]:=$1c1c1cff;
TPalette256.DWords[235]:=$262626ff;
TPalette256.DWords[236]:=$303030ff;
TPalette256.DWords[237]:=$3a3a3aff;
TPalette256.DWords[238]:=$444444ff;
TPalette256.DWords[239]:=$4e4e4eff;
TPalette256.DWords[240]:=$585858ff;
TPalette256.DWords[241]:=$626262ff;
TPalette256.DWords[242]:=$6c6c6cff;
TPalette256.DWords[243]:=$767676ff;
TPalette256.DWords[244]:=$808080ff;
TPalette256.DWords[245]:=$8a8a8aff;
TPalette256.DWords[246]:=$949494ff;
TPalette256.DWords[247]:=$9e9e9eff;
TPalette256.DWords[248]:=$a8a8a8ff;
TPalette256.DWords[249]:=$b2b2b2ff;
TPalette256.DWords[250]:=$bcbcbcff;
TPalette256.DWords[251]:=$c6c6c6ff;
TPalette256.DWords[252]:=$d0d0d0ff;
TPalette256.DWords[253]:=$dadadaff;
TPalette256.DWords[254]:=$e4e4e4ff;
TPalette256.DWords[255]:=$eeeeeeff;

end;


//supply a filename like:
// yes, you should be using long file names
// PAL256C.dat or PAL256BW.dat

//(dont make me duplicate code to change two lines)

procedure Save256Palette(filename:string);

Var
	palette256File  : File of Tpalette256;
	i,num            : integer;

Begin

    //save us a lot of code and work
    init256Palette;
	Assign(palette256File, filename);
	ReWrite(palette256File);

    i:=0;
    num:=0;
    
	For num := 1 to 256 do

	Begin;
	  Write(palette256File, TPalette256.colors[num]); //sdl_Color
      inc(num);
	End;


    i:=0;
	For i := 1 to 256 do
	Begin;
		Write(palette256File, TPalette256.DWords[i]); //dword
		inc(i);
	End;

	Close(palette256File);
	
End;


procedure Read256Palette(filename:string);

Var
	palette16File  : File of Tpalette256;
	i,num            : integer;

Begin
	Assign(palette256File, filename);
	ReSet(palette256File);
    Seek(palette256File, 0); //find first record
    
	For num := 1 to 256 do

	Begin;
	  Read(palette256File, TPalette256.colors[num]); //sdl_Color
      inc(num); 
	End;


    i:=0;
	For i := 1 to 256 do
	Begin;
		Read(palette256File, TPalette256.DWords[i]); //dword
		inc(i);
	End;

	Close(palette256File);
	//much much easier now....
    SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, Tpalette16.colors, 0, 16 );

end;


