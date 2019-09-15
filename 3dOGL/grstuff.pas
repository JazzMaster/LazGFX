unit GrStuff﻿;

//this unit sort of overrides crtstuff in SDL.
//extra routines for working w graphics mode text

//mini-dialog unit
interface



implementation
//lined boxes

//single


//double

//centered drawn boxes



//fullscreen dialogs are handled on the canvas- not as a SDL popup
//you have to program both the input-and the dialog(ive provided the drawing code), then what to do.

//windowed dialogs are handled by SDL(or customised form it)

//yes no
//also: the old: F-it, Abort,keeptrying dialog

procedure YesNoDialog(Question,WindowTitle:PChar);

var
    buttons:array[1..2] of PSDL_MessageBoxButtonData;
    colorScheme:array[1..5] of PSDL_Color;
    messageboxdata:PSDL_MessageBoxData;
    
    buttons[1] := ( 0, 0, "no" );
    buttons[2] := ( SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT, 1, "yes" );
    
{    
    //all are SDLColor:
    //background
    //TExtColor
    //ButtonBorder
    //ButtonBackground
    //ButtonSelected
    
    colorScheme[1] := ( 255,   0,   0 );       
    colorScheme[2] := (   0, 255,   0 );
    colorScheme[3] := ( 255, 255,   0 );
    colorScheme[4] := (   0,   0, 255 );
    colorScheme[5] := ( 255,   0, 255 );
}
    
    //@colorscheme or Nil as the last variable
    messageboxdata := (
        SDL_MESSAGEBOX_INFORMATION, 
        NiL, 
        title, 
        question, 
        2,
        buttons, 
        Nil
    );

    buttonid:integer;
    
begin    
    if (SDL_ShowMessageBox(@messageboxdata, @buttonid) < 0) then begin
        LogLn('error displaying dialog box');
        exit;
    end;

end;

//ok- (or any mindless "push here" button)
procedure OkDialog(title,Statement:PChar);

begin
	SDL_ShowSimpleMessageBox(flags, title,statement,Nil);
end;

//nav keys are handled elsewhere

begin
end.
