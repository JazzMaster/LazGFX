Unit Laz_Sound;

interface

//briefly, this defines all notes
type

    Notes=(A,B,C,D,E,F,G);
    Octaves=(1,2,3,4,5,6,7); //Or "octave window"
    NoteFXtype=(None,Sharp,Flat); //Flat of one is Sharp of another. At least in Guitar
    Instruments=(Pianos,Guitars,Lutes,Harps,Drums,Flutes,Oboes,Uprights,Violins,Ukeleles,Banjoes); //SoundFont defined- this is to look at

var
    //"whacky Pascal redefinitions" to use the enums
    Octave:Octaves;
    Note:Notes;
    NoteFX:NoteFXtype;

//realistically- this is whats used
//FX are based on instrument used- Grand Piano is "fairly basic plucked" CLEAN TONE.

//(normal Pianos have Pedals for FX-I never understood thier use)

const
//frequencies in Hz
//seven octaves standard "GAMUT" -as it were

//some instruments go higher, some lower

//"Grand Piano computer" example

    middleA=440;
    middleC=220;

//delays(in ms)

    sixteenth=63; //62.5
    eigth=125;
    quarter=250;
    half=500;
    whole=1000;


procedure LoadSoundFont;
{
Im still working on this-

The idea is to load a sound FONT- (a bunch of instrument definitions) before "typing" audio notes...
(using the sound card of course- much like OPLv3 synthesis)

D2X-Rebirth uses this method- much like The original Descent I and II - uses MIDI(or similar) output
-and we dont want it to sound like ASS- 

what we need instead is a simulation of MIDI(synthesis)- 
        we need instruments
        and we need notes to play on them (like a MIDI driver board produces)

playing middle C is fine- 
    but on which instrument/synthboard?? 
Notes by themselves dont produce sound.

(Programatically, however, we use "Grand" Piano frequencies)

}

begin

end;

{

For the basics:

Note definitions, scalle definitions (never thought Id be re writing this code)
Are included here. There are several implementations and I am trying to standardize these also.

A=440Hz


}

implementation



begin //main()
end.
