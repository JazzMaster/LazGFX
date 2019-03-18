unit sdl;
{
  $Id: sdl.pas,v 1.38 2008/01/26 10:09:32 savage Exp $

}
{******************************************************************************}
{                                                                              }
{          JEDI-SDL : Pascal units for SDL - Simple DirectMedia Layer          }
{             Conversion of the Simple DirectMedia Layer Headers               }
{                                                                              }
{ Portions created by Sam Lantinga <slouken@devolution.com> are                }
{ Copyright (C) 1997-2004  Sam Lantinga                                        }
{ 5635-34 Springhouse Dr.                                                      }
{ Pleasanton, CA 94588 (USA)                                                   }
{                                                                              }
{ All Rights Reserved.                                                         }
{                                                                              }
{ The original files are : SDL.h                                               }
{                          SDL_main.h                                          }
{                          SDL_types.h                                         }
{                          SDL_rwops.h                                         }
{                          SDL_timer.h                                         }
{                          SDL_audio.h                                         }
{                          SDL_cdrom.h                                         }
{                          SDL_joystick.h                                      }
{                          SDL_mouse.h                                         }
{                          SDL_keyboard.h                                      }
{                          SDL_events.h                                        }
{                          SDL_video.h                                         }
{                          SDL_byteorder.h                                     }
{                          SDL_version.h                                       }
{                          SDL_active.h                                        }
{                          SDL_thread.h                                        }
{                          SDL_mutex .h                                        }
{                          SDL_getenv.h                                        }
{                          SDL_loadso.h                                        }
{                                                                              }
{ The initial developer of this Pascal code was :                              }
{ Dominique Louis <Dominique@SavageSoftware.com.au>                            }
{                                                                              }
{ Portions created by Dominique Louis are                                      }
{ Copyright (C) 2000 - 2004 Dominique Louis.                                   }
{                                                                              }
{                                                                              }
{ Contributor(s)                                                               }
{ --------------                                                               }
{ Tom Jones <tigertomjones@gmx.de>  His Project inspired this conversion       }
{ Matthias Thoma <ma.thoma@gmx.de>                                             }
{ Richard Jasmin (code cleanup)  hollowmaster95@gmail.com                      }
{ Obtained through:                                                            }
{ Joint Endeavour of Delphi Innovators ( Project JEDI )                        }
{                                                                              }
{ You may retrieve the latest version of this file at the Project              }
{ JEDI home page, located at http://delphi-jedi.org                            }
{                                                                              }
{ The contents of this file are used with permission, subject to               }
{ the Mozilla Public License Version 1.1 (the "License"); you may              }
{ not use this file except in compliance with the License. You may             }
{ obtain a copy of the License at                                              }
{ http://www.mozilla.org/MPL/MPL-1.1.html                                      }
{                                                                              }
{ Software distributed under the License is distributed on an                  }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or               }
{ implied. See the License for the specific language governing                 }
{ rights and limitations under the License.                                    }
{                                                                              }
{                                                                              }
{ Requires                                                                     }
{ --------                                                                     }
{   The SDL Runtime libraris on Win32  : SDL.dll on Linux : libSDL.so          }
{   They are available from...                                                 }
{   http://www.libsdl.org .                                                    }
{                                                                              }
{******************************************************************************}

{$IFNDEF JEDI_INC}
{$DEFINE JEDI_INC}

{**************************************************************************************************}
{                                                                                                  }
{  Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF  }
{  ANY KIND, either express or implied. See the License for the specific language governing rights }
{  and limitations under the License.                                                              }
{                                                                                                  }
{  The Original Code is: jedi.inc.                                                                 }
{  The Initial Developer of the Original Code is Project JEDI http://www.delphi-jedi.org           }
{                                                                                                  }
{                                                                                                  }
{  For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html                    }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{  This file defines various generic compiler directives used in different libraries, e.g. in the  }
{  JEDI Code Library (JCL) and JEDI Visual Component Library Library (JVCL). The directives in     }
{  this file are of generic nature and consist mostly of mappings from the VERXXX directives       }
{  defined by Delphi, C++Builder and FPC to friendly names such as DELPHI5 and                     }
{  SUPPORTS_WIDESTRING. These friendly names are subsequently used in the libraries to test for    }
{  compiler versions and/or whether the compiler supports certain features (such as widestrings or }
{  64 bit integers. The libraries provide an additional, library specific, include file. For the   }
{  JCL e.g. this is jcl.inc. }

(*

- Development environment directives

  This file defines two directives to indicate which development environment the
  library is being compiled with. Currently this can either be Delphi, Kylix,
  C++Builder or FPC.

  Directive           Description
  ------------------------------------------------------------------------------
  DELPHI              Defined if compiled with Delphi
  KYLIX               Defined if compiled with Kylix
  DELPHICOMPILER      Defined if compiled with Delphi or Kylix/Delphi
  BCB                 Defined if compiled with C++Builder
  CPPBUILDER          Defined if compiled with C++Builder (alias for BCB)
  BCBCOMPILER         Defined if compiled with C++Builder or Kylix/C++
  DELPHILANGUAGE      Defined if compiled with Delphi, Kylix or C++Builder
  BORLAND             Defined if compiled with Delphi, Kylix or C++Builder
  FPC                 Defined if compiled with FPC

- Platform Directives

  Platform directives are not all explicitly defined in this file, some are
  defined by the compiler itself. They are listed here only for completeness.

  Directive           Description
  ------------------------------------------------------------------------------
  WIN32               Defined when target platform is 32 bit Windows
  WIN64               Defined when target platform is 64 bit Windows
  MSWINDOWS           Defined when target platform is 32 bit Windows
  LINUX               Defined when target platform is Linux
  UNIX                Defined when target platform is Unix-like (including Linux)
  CLR                 Defined when target platform is .NET

- Architecture directives. These are auto-defined by FPC
  CPU32 and CPU64 are mostly for generic pointer size dependant differences rather
  than for a specific architecture.

  CPU386              Defined when target platform is native x86 (win32)
  CPUx86_64           Defined when target platform is native x86_64 (win64)
  CPU32               Defined when target is 32-bit
  CPU64	              Defined when target is 64-bit
  CPUASM              Defined when target assembler is available

- Visual library Directives

  The following directives indicate for a visual library. In a Delphi/BCB
  (Win32) application you need to define the VisualCLX symbol in the project
  options, if  you want to use the VisualCLX library. Alternatively you can use
  the IDE expert, which is distributed with the JCL to do this automatically.

  Directive           Description
  ------------------------------------------------------------------------------
  VCL                 Defined for Delphi/BCB (Win32) exactly if VisualCLX is not defined
  VisualCLX           Defined for Kylix; needs to be defined for Delphi/BCB to
                      use JCL with VisualCLX applications.


- Other cross-platform related defines

  These symbols are intended to help in writing portable code.

  Directive           Description
  ------------------------------------------------------------------------------
  PUREPASCAL          Code is machine-independent (as opposed to assembler code)
  Win32API            Code is specific for the Win32 API;
                      use instead of "{$IFNDEF CLR} {$IFDEF MSWINDOWS}" constructs


- Delphi Versions

  The following directives are direct mappings from the VERXXX directives to a
  friendly name of the associated compiler. These directives are only defined if
  the compiler is Delphi (ie DELPHI is defined).

  Directive           Description
  ------------------------------------------------------------------------------
  DELPHI1             Defined when compiling with Delphi 1 (Codename WASABI/MANGO)
  DELPHI2             Defined when compiling with Delphi 2 (Codename POLARIS)
  DELPHI3             Defined when compiling with Delphi 3 (Codename IVORY)
  DELPHI4             Defined when compiling with Delphi 4 (Codename ALLEGRO)
  DELPHI5             Defined when compiling with Delphi 5 (Codename ARGUS)
  DELPHI6             Defined when compiling with Delphi 6 (Codename ILLIAD)
  DELPHI7             Defined when compiling with Delphi 7 (Codename AURORA)
  DELPHI8             Defined when compiling with Delphi 8 (Codename OCTANE)
  DELPHI2005          Defined when compiling with Delphi 2005 (Codename DIAMONDBACK)
  DELPHI9             Alias for DELPHI2005
  DELPHI10            Defined when compiling with Delphi 2006 (Codename DEXTER)
  DELPHI2006          Alias for DELPHI10
  DELPHI11            Defined when compiling with Delphi 2007 for Win32 (Codename SPACELY)
  DELPHI2007          Alias for DELPHI11
  DELPHI12            Defined when compiling with Delphi 2009 for Win32 (Codename TIBURON)
  DELPHI2009          Alias for DELPHI12
  DELPHI14            Defined when compiling with Delphi 2010 for Win32 (Codename WEAVER)
  DELPHI2010          Alias for DELPHI14
  DELPHI15            Defined when compiling with Delphi XE for Win32 (Codename FULCRUM)
  DELPHIXE            Alias for DELPHI15
  DELPHI16            Defined when compiling with Delphi XE2 for Win32 (Codename PULSAR)
  DELPHIXE2           Alias for DELPHI16
  DELPHI17            Defined when compiling with Delphi XE3 for Win32 (Codename WATERDRAGON)
  DELPHIXE3           Alias for DELPHI17
  DELPHI18            Defined when compiling with Delphi XE4 for Win32 (Codename QUINTESSENCE)
  DELPHIXE4           Alias for DELPHI18
  DELPHI19            Defined when compiling with Delphi XE5 for Win32 (Codename ZEPHYR)
  DELPHIXE5           Alias for DELPHI19
  DELPHI20            Defined when compiling with Delphi XE6 for Win32 (Codename PROTEUS)
  DELPHIXE6           Alias for DELPHI20
  DELPHI21            Defined when compiling with Delphi XE7 for Win32 (Codename CARPATHIA)
  DELPHIXE7           Alias for DELPHI21
  DELPHI22            Defined when compiling with Delphi XE8 for Win32 (Codename ELBRUS)
  DELPHIXE8           Alias for DELPHI22
  DELPHI23            Defined when compiling with Delphi 10 for Win32 (Codename AITANA)
  DELPHIX_SEATTLE     Alias for DELPHI23
  DELPHI1_UP          Defined when compiling with Delphi 1 or higher
  DELPHI2_UP          Defined when compiling with Delphi 2 or higher
  DELPHI3_UP          Defined when compiling with Delphi 3 or higher
  DELPHI4_UP          Defined when compiling with Delphi 4 or higher
  DELPHI5_UP          Defined when compiling with Delphi 5 or higher
  DELPHI6_UP          Defined when compiling with Delphi 6 or higher
  DELPHI7_UP          Defined when compiling with Delphi 7 or higher
  DELPHI8_UP          Defined when compiling with Delphi 8 or higher
  DELPHI2005_UP       Defined when compiling with Delphi 2005 or higher
  DELPHI9_UP          Alias for DELPHI2005_UP
  DELPHI10_UP         Defined when compiling with Delphi 2006 or higher
  DELPHI2006_UP       Alias for DELPHI10_UP
  DELPHI11_UP         Defined when compiling with Delphi 2007 for Win32 or higher
  DELPHI2007_UP       Alias for DELPHI11_UP
  DELPHI12_UP         Defined when compiling with Delphi 2009 for Win32 or higher
  DELPHI2009_UP       Alias for DELPHI12_UP
  DELPHI14_UP         Defined when compiling with Delphi 2010 for Win32 or higher
  DELPHI2010_UP       Alias for DELPHI14_UP
  DELPHI15_UP         Defined when compiling with Delphi XE for Win32 or higher
  DELPHIXE_UP         Alias for DELPHI15_UP
  DELPHI16_UP         Defined when compiling with Delphi XE2 for Win32 or higher
  DELPHIXE2_UP        Alias for DELPHI16_UP
  DELPHI17_UP         Defined when compiling with Delphi XE3 for Win32 or higher
  DELPHIXE3_UP        Alias for DELPHI17_UP
  DELPHI18_UP         Defined when compiling with Delphi XE4 for Win32 or higher
  DELPHIXE4_UP        Alias for DELPHI18_UP
  DELPHI19_UP         Defined when compiling with Delphi XE5 for Win32 or higher
  DELPHIXE5_UP        Alias for DELPHI19_UP
  DELPHI20_UP         Defined when compiling with Delphi XE6 for Win32 or higher
  DELPHIXE6_UP        Alias for DELPHI20_UP
  DELPHI21_UP         Defined when compiling with Delphi XE7 for Win32 or higher
  DELPHIXE7_UP        Alias for DELPHI21_UP
  DELPHI22_UP         Defined when compiling with Delphi XE8 for Win32 or higher
  DELPHIXE8_UP        Alias for DELPHI22_UP
  DELPHI23_UP         Defined when compiling with Delphi 10 for Win32 or higher
  DELPHIX_SEATTLE_UP  Alias for DELPHI23_UP


- Kylix Versions

  The following directives are direct mappings from the VERXXX directives to a
  friendly name of the associated compiler. These directives are only defined if
  the compiler is Kylix (ie KYLIX is defined).

  Directive           Description
  ------------------------------------------------------------------------------
  KYLIX1              Defined when compiling with Kylix 1
  KYLIX2              Defined when compiling with Kylix 2
  KYLIX3              Defined when compiling with Kylix 3 (Codename CORTEZ)
  KYLIX1_UP           Defined when compiling with Kylix 1 or higher
  KYLIX2_UP           Defined when compiling with Kylix 2 or higher
  KYLIX3_UP           Defined when compiling with Kylix 3 or higher


- Delphi Compiler Versions (Delphi / Kylix, not in BCB mode)

  Directive           Description
  ------------------------------------------------------------------------------
  DELPHICOMPILER1      Defined when compiling with Delphi 1
  DELPHICOMPILER2      Defined when compiling with Delphi 2
  DELPHICOMPILER3      Defined when compiling with Delphi 3
  DELPHICOMPILER4      Defined when compiling with Delphi 4
  DELPHICOMPILER5      Defined when compiling with Delphi 5
  DELPHICOMPILER6      Defined when compiling with Delphi 6 or Kylix 1, 2 or 3
  DELPHICOMPILER7      Defined when compiling with Delphi 7
  DELPHICOMPILER8      Defined when compiling with Delphi 8
  DELPHICOMPILER9      Defined when compiling with Delphi 2005
  DELPHICOMPILER10     Defined when compiling with Delphi Personality of BDS 4.0
  DELPHICOMPILER11     Defined when compiling with Delphi 2007 for Win32
  DELPHICOMPILER12     Defined when compiling with Delphi Personality of BDS 6.0
  DELPHICOMPILER14     Defined when compiling with Delphi Personality of BDS 7.0
  DELPHICOMPILER15     Defined when compiling with Delphi Personality of BDS 8.0
  DELPHICOMPILER16     Defined when compiling with Delphi Personality of BDS 9.0
  DELPHICOMPILER17     Defined when compiling with Delphi Personality of BDS 10.0
  DELPHICOMPILER18     Defined when compiling with Delphi Personality of BDS 11.0
  DELPHICOMPILER19     Defined when compiling with Delphi Personality of BDS 12.0
  DELPHICOMPILER20     Defined when compiling with Delphi Personality of BDS 14.0
  DELPHICOMPILER21     Defined when compiling with Delphi Personality of BDS 15.0
  DELPHICOMPILER22     Defined when compiling with Delphi Personality of BDS 16.0
  DELPHICOMPILER23     Defined when compiling with Delphi Personality of BDS 17.0
  DELPHICOMPILER1_UP   Defined when compiling with Delphi 1 or higher
  DELPHICOMPILER2_UP   Defined when compiling with Delphi 2 or higher
  DELPHICOMPILER3_UP   Defined when compiling with Delphi 3 or higher
  DELPHICOMPILER4_UP   Defined when compiling with Delphi 4 or higher
  DELPHICOMPILER5_UP   Defined when compiling with Delphi 5 or higher
  DELPHICOMPILER6_UP   Defined when compiling with Delphi 6 or Kylix 1, 2 or 3 or higher
  DELPHICOMPILER7_UP   Defined when compiling with Delphi 7 or higher
  DELPHICOMPILER8_UP   Defined when compiling with Delphi 8 or higher
  DELPHICOMPILER9_UP   Defined when compiling with Delphi 2005
  DELPHICOMPILER10_UP  Defined when compiling with Delphi 2006 or higher
  DELPHICOMPILER11_UP  Defined when compiling with Delphi 2007 for Win32 or higher
  DELPHICOMPILER12_UP  Defined when compiling with Delphi 2009 for Win32 or higher
  DELPHICOMPILER14_UP  Defined when compiling with Delphi 2010 for Win32 or higher
  DELPHICOMPILER15_UP  Defined when compiling with Delphi XE for Win32 or higher
  DELPHICOMPILER16_UP  Defined when compiling with Delphi XE2 for Win32 or higher
  DELPHICOMPILER17_UP  Defined when compiling with Delphi XE3 for Win32 or higher
  DELPHICOMPILER18_UP  Defined when compiling with Delphi XE4 for Win32 or higher
  DELPHICOMPILER19_UP  Defined when compiling with Delphi XE5 for Win32 or higher
  DELPHICOMPILER20_UP  Defined when compiling with Delphi XE6 for Win32 or higher
  DELPHICOMPILER21_UP  Defined when compiling with Delphi XE7 for Win32 or higher
  DELPHICOMPILER22_UP  Defined when compiling with Delphi XE8 for Win32 or higher
  DELPHICOMPILER23_UP  Defined when compiling with Delphi 10 for Win32 or higher


- C++Builder Versions

  The following directives are direct mappings from the VERXXX directives to a
  friendly name of the associated compiler. These directives are only defined if
  the compiler is C++Builder (ie BCB is defined).

  Directive    Description
  ------------------------------------------------------------------------------
  BCB1         Defined when compiling with C++Builder 1
  BCB3         Defined when compiling with C++Builder 3
  BCB4         Defined when compiling with C++Builder 4
  BCB5         Defined when compiling with C++Builder 5 (Codename RAMPAGE)
  BCB6         Defined when compiling with C++Builder 6 (Codename RIPTIDE)
  BCB10        Defined when compiling with C++Builder Personality of BDS 4.0 (also known as C++Builder 2006) (Codename DEXTER)
  BCB11        Defined when compiling with C++Builder Personality of RAD Studio 2007 (also known as C++Builder 2007) (Codename COGSWELL)
  BCB12        Defined when compiling with C++Builder Personality of RAD Studio 2009 (also known as C++Builder 2009) (Codename TIBURON)
  BCB14        Defined when compiling with C++Builder Personality of RAD Studio 2010 (also known as C++Builder 2010) (Codename WEAVER)
  BCB15        Defined when compiling with C++Builder Personality of RAD Studio XE (also known as C++Builder XE) (Codename FULCRUM)
  BCB16        Defined when compiling with C++Builder Personality of RAD Studio XE2 (also known as C++Builder XE2) (Codename PULSAR)
  BCB17        Defined when compiling with C++Builder Personality of RAD Studio XE3 (also known as C++Builder XE3) (Codename WATERDRAGON)
  BCB18        Defined when compiling with C++Builder Personality of RAD Studio XE4 (also known as C++Builder XE4) (Codename QUINTESSENCE)
  BCB19        Defined when compiling with C++Builder Personality of RAD Studio XE5 (also known as C++Builder XE5) (Codename ZEPHYR)
  BCB20        Defined when compiling with C++Builder Personality of RAD Studio XE6 (also known as C++Builder XE6) (Codename PROTEUS)
  BCB21        Defined when compiling with C++Builder Personality of RAD Studio XE7 (also known as C++Builder XE7) (Codename CARPATHIA)
  BCB22        Defined when compiling with C++Builder Personality of RAD Studio XE8 (also known as C++Builder XE8) (Codename ELBRUS)
  BCB23        Defined when compiling with C++Builder Personality of RAD Studio 10 Seattle (also known as C++Builder 10 Seattle) (Codename AITANA)
  BCB1_UP      Defined when compiling with C++Builder 1 or higher
  BCB3_UP      Defined when compiling with C++Builder 3 or higher
  BCB4_UP      Defined when compiling with C++Builder 4 or higher
  BCB5_UP      Defined when compiling with C++Builder 5 or higher
  BCB6_UP      Defined when compiling with C++Builder 6 or higher
  BCB10_UP     Defined when compiling with C++Builder Personality of BDS 4.0 or higher
  BCB11_UP     Defined when compiling with C++Builder Personality of RAD Studio 2007 or higher
  BCB12_UP     Defined when compiling with C++Builder Personality of RAD Studio 2009 or higher
  BCB14_UP     Defined when compiling with C++Builder Personality of RAD Studio 2010 or higher
  BCB15_UP     Defined when compiling with C++Builder Personality of RAD Studio XE or higher
  BCB16_UP     Defined when compiling with C++Builder Personality of RAD Studio XE2 or higher
  BCB17_UP     Defined when compiling with C++Builder Personality of RAD Studio XE3 or higher
  BCB18_UP     Defined when compiling with C++Builder Personality of RAD Studio XE4 or higher
  BCB19_UP     Defined when compiling with C++Builder Personality of RAD Studio XE5 or higher
  BCB20_UP     Defined when compiling with C++Builder Personality of RAD Studio XE6 or higher
  BCB21_UP     Defined when compiling with C++Builder Personality of RAD Studio XE7 or higher
  BCB22_UP     Defined when compiling with C++Builder Personality of RAD Studio XE8 or higher
  BCB23_UP     Defined when compiling with C++Builder Personality of RAD Studio 10 or higher


- RAD Studio / Borland Developer Studio Versions

  The following directives are direct mappings from the VERXXX directives to a
  friendly name of the associated IDE. These directives are only defined if
  the IDE is Borland Developer Studio Version 2 or above.

  Note: Borland Developer Studio 2006 is marketed as Delphi 2006 or C++Builder 2006,
  but those provide only different labels for identical content.

  Directive    Description
  ------------------------------------------------------------------------------
  BDS          Defined when compiling with BDS version of dcc32.exe (Codename SIDEWINDER)
  BDS2         Defined when compiling with BDS 2.0 (Delphi 8) (Codename OCTANE)
  BDS3         Defined when compiling with BDS 3.0 (Delphi 2005) (Codename DIAMONDBACK)
  BDS4         Defined when compiling with BDS 4.0 (Borland Developer Studio 2006) (Codename DEXTER)
  BDS5         Defined when compiling with BDS 5.0 (CodeGear RAD Studio 2007) (Codename HIGHLANDER)
  BDS6         Defined when compiling with BDS 6.0 (CodeGear RAD Studio 2009) (Codename TIBURON)
  BDS7         Defined when compiling with BDS 7.0 (Embarcadero RAD Studio 2010) (Codename WEAVER)
  BDS8         Defined when compiling with BDS 8.0 (Embarcadero RAD Studio XE) (Codename FULCRUM)
  BDS9         Defined when compiling with BDS 9.0 (Embarcadero RAD Studio XE2) (Codename PULSAR)
  BDS10        Defined when compiling with BDS 10.0 (Embarcadero RAD Studio XE3) (Codename WATERDRAGON)
  BDS11        Defined when compiling with BDS 11.0 (Embarcadero RAD Studio XE4) (Codename QUINTESSENCE)
  BDS12        Defined when compiling with BDS 12.0 (Embarcadero RAD Studio XE5) (Codename ZEPHYR)
  BDS14        Defined when compiling with BDS 14.0 (Embarcadero RAD Studio XE6) (Codename PROTEUS)
  BDS15        Defined when compiling with BDS 15.0 (Embarcadero RAD Studio XE7) (Codename CARPATHIA)
  BDS16        Defined when compiling with BDS 16.0 (Embarcadero RAD Studio XE8) (Codename ELBRUS)
  BDS17        Defined when compiling with BDS 17.0 (Embarcadero RAD Studio 10) (Codename AITANA)
  BDS2_UP      Defined when compiling with BDS 2.0 or higher
  BDS3_UP      Defined when compiling with BDS 3.0 or higher
  BDS4_UP      Defined when compiling with BDS 4.0 or higher
  BDS5_UP      Defined when compiling with BDS 5.0 or higher
  BDS6_UP      Defined when compiling with BDS 6.0 or higher
  BDS7_UP      Defined when compiling with BDS 7.0 or higher
  BDS8_UP      Defined when compiling with BDS 8.0 or higher
  BDS9_UP      Defined when compiling with BDS 9.0 or higher
  BDS10_UP     Defined when compiling with BDS 10.0 or higher
  BDS11_UP     Defined when compiling with BDS 11.0 or higher
  BDS12_UP     Defined when compiling with BDS 12.0 or higher
  BDS14_UP     Defined when compiling with BDS 14.0 or higher
  BDS15_UP     Defined when compiling with BDS 15.0 or higher
  BDS16_UP     Defined when compiling with BDS 16.0 or higher
  BDS17_UP     Defined when compiling with BDS 17.0 or higher

- Compiler Versions

  The following directives are direct mappings from the VERXXX directives to a
  friendly name of the associated compiler. Unlike the DELPHI_X and BCB_X
  directives, these directives are indepedent of the development environment.
  That is, they are defined regardless of whether compilation takes place using
  Delphi or C++Builder.

  Directive     Description
  ------------------------------------------------------------------------------
  COMPILER1      Defined when compiling with Delphi 1
  COMPILER2      Defined when compiling with Delphi 2 or C++Builder 1
  COMPILER3      Defined when compiling with Delphi 3
  COMPILER35     Defined when compiling with C++Builder 3
  COMPILER4      Defined when compiling with Delphi 4 or C++Builder 4
  COMPILER5      Defined when compiling with Delphi 5 or C++Builder 5
  COMPILER6      Defined when compiling with Delphi 6 or C++Builder 6
  COMPILER7      Defined when compiling with Delphi 7
  COMPILER8      Defined when compiling with Delphi 8
  COMPILER9      Defined when compiling with Delphi 9
  COMPILER10     Defined when compiling with Delphi or C++Builder Personalities of BDS 4.0
  COMPILER11     Defined when compiling with Delphi or C++Builder Personalities of BDS 5.0
  COMPILER12     Defined when compiling with Delphi or C++Builder Personalities of BDS 6.0
  COMPILER14     Defined when compiling with Delphi or C++Builder Personalities of BDS 7.0
  COMPILER15     Defined when compiling with Delphi or C++Builder Personalities of BDS 8.0
  COMPILER16     Defined when compiling with Delphi or C++Builder Personalities of BDS 9.0
  COMPILER17     Defined when compiling with Delphi or C++Builder Personalities of BDS 10.0
  COMPILER18     Defined when compiling with Delphi or C++Builder Personalities of BDS 11.0
  COMPILER19     Defined when compiling with Delphi or C++Builder Personalities of BDS 12.0
  COMPILER20     Defined when compiling with Delphi or C++Builder Personalities of BDS 14.0
  COMPILER21     Defined when compiling with Delphi or C++Builder Personalities of BDS 15.0
  COMPILER22     Defined when compiling with Delphi or C++Builder Personalities of BDS 16.0
  COMPILER23     Defined when compiling with Delphi or C++Builder Personalities of BDS 17.0
  COMPILER1_UP   Defined when compiling with Delphi 1 or higher
  COMPILER2_UP   Defined when compiling with Delphi 2 or C++Builder 1 or higher
  COMPILER3_UP   Defined when compiling with Delphi 3 or higher
  COMPILER35_UP  Defined when compiling with C++Builder 3 or higher
  COMPILER4_UP   Defined when compiling with Delphi 4 or C++Builder 4 or higher
  COMPILER5_UP   Defined when compiling with Delphi 5 or C++Builder 5 or higher
  COMPILER6_UP   Defined when compiling with Delphi 6 or C++Builder 6 or higher
  COMPILER7_UP   Defined when compiling with Delphi 7
  COMPILER8_UP   Defined when compiling with Delphi 8
  COMPILER9_UP   Defined when compiling with Delphi Personalities of BDS 3.0
  COMPILER10_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 4.0 or higher
  COMPILER11_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 5.0 or higher
  COMPILER12_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 6.0 or higher
  COMPILER14_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 7.0 or higher
  COMPILER15_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 8.0 or higher
  COMPILER16_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 9.0 or higher
  COMPILER17_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 10.0 or higher
  COMPILER18_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 11.0 or higher
  COMPILER19_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 12.0 or higher
  COMPILER20_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 14.0 or higher
  COMPILER21_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 15.0 or higher
  COMPILER22_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 16.0 or higher
  COMPILER23_UP  Defined when compiling with Delphi or C++Builder Personalities of BDS 17.0 or higher


- RTL Versions

  Use e.g. following to determine the exact RTL version since version 14.0:
    {$IFDEF CONDITIONALEXPRESSIONS}
      {$IF Declared(RTLVersion) and (RTLVersion >= 14.2)}
        // code for Delphi 6.02 or higher, Kylix 2 or higher, C++Builder 6 or higher
        ...
      {$IFEND}
    {$ENDIF}

  Directive     Description
  ------------------------------------------------------------------------------
  RTL80_UP      Defined when compiling with Delphi 1 or higher
  RTL90_UP      Defined when compiling with Delphi 2 or higher
  RTL93_UP      Defined when compiling with C++Builder 1 or higher
  RTL100_UP     Defined when compiling with Delphi 3 or higher
  RTL110_UP     Defined when compiling with C++Builder 3 or higher
  RTL120_UP     Defined when compiling with Delphi 4 or higher
  RTL125_UP     Defined when compiling with C++Builder 4 or higher
  RTL130_UP     Defined when compiling with Delphi 5 or C++Builder 5 or higher
  RTL140_UP     Defined when compiling with Delphi 6, Kylix 1, 2 or 3 or C++Builder 6 or higher
  RTL150_UP     Defined when compiling with Delphi 7 or higher
  RTL160_UP     Defined when compiling with Delphi 8 or higher
  RTL170_UP     Defined when compiling with Delphi Personalities of BDS 3.0 or higher
  RTL180_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 4.0 or higher
  RTL185_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 5.0 or higher
  RTL190_UP     Defined when compiling with Delphi.NET of BDS 5.0 or higher
  RTL200_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 6.0 or higher
  RTL210_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 7.0 or higher
  RTL220_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 8.0 or higher
  RTL230_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 9.0 or higher
  RTL240_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 10.0 or higher
  RTL250_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 11.0 or higher
  RTL260_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 12.0 or higher
  RTL270_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 14.0 or higher
  RTL280_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 15.0 or higher
  RTL290_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 16.0 or higher
  RTL300_UP     Defined when compiling with Delphi or C++Builder Personalities of BDS 17.0 or higher


- CLR Versions

  Directive     Description
  ------------------------------------------------------------------------------
  CLR            Defined when compiling for .NET
  CLR10          Defined when compiling for .NET 1.0 (may be overriden by FORCE_CLR10)
  CLR10_UP       Defined when compiling for .NET 1.0 or higher
  CLR11          Defined when compiling for .NET 1.1 (may be overriden by FORCE_CLR11)
  CLR11_UP       Defined when compiling for .NET 1.1 or higher
  CLR20          Defined when compiling for .NET 2.0 (may be overriden by FORCE_CLR20)
  CLR20_UP       Defined when compiling for .NET 2.0 or higher


- Feature Directives

  The features directives are used to test if the compiler supports specific
  features, such as method overloading, and adjust the sources accordingly. Use
  of these directives is preferred over the use of the DELPHI and COMPILER
  directives.

  Directive              Description
  ------------------------------------------------------------------------------
  SUPPORTS_CONSTPARAMS           Compiler supports const parameters (D1+)
  SUPPORTS_SINGLE                Compiler supports the Single type (D1+)
  SUPPORTS_DOUBLE                Compiler supports the Double type (D1+)
  SUPPORTS_EXTENDED              Compiler supports the Extended type (D1+)
  SUPPORTS_CURRENCY              Compiler supports the Currency type (D2+)
  SUPPORTS_THREADVAR             Compiler supports threadvar declarations (D2+)
  SUPPORTS_OUTPARAMS             Compiler supports out parameters (D3+)
  SUPPORTS_VARIANT               Compiler supports variant (D2+)
  SUPPORTS_WIDECHAR              Compiler supports the WideChar type (D2+)
  SUPPORTS_WIDESTRING            Compiler supports the WideString type (D3+/BCB3+)
  SUPPORTS_INTERFACE             Compiler supports interfaces (D3+/BCB3+)
  SUPPORTS_DISPINTERFACE         Compiler supports dispatch interfaces (D3+/BCB3+)
  SUPPORTS_DISPID                Compiler supports dispatch ids (D3+/BCB3+/FPC)
  SUPPORTS_EXTSYM                Compiler supports the $EXTERNALSYM directive (D4+/BCB3+)
  SUPPORTS_NODEFINE              Compiler supports the $NODEFINE directive (D4+/BCB3+)
  SUPPORTS_LONGWORD              Compiler supports the LongWord type (unsigned 32 bit) (D4+/BCB4+)
  SUPPORTS_INT64                 Compiler supports the Int64 type (D4+/BCB4+)
  SUPPORTS_UINT64                Compiler supports the UInt64 type (D7+)
  SUPPORTS_DYNAMICARRAYS         Compiler supports dynamic arrays (D4+/BCB4+)
  SUPPORTS_DEFAULTPARAMS         Compiler supports default parameters (D4+/BCB4+)
  SUPPORTS_OVERLOAD              Compiler supports overloading (D4+/BCB4+)
  SUPPORTS_IMPLEMENTS            Compiler supports implements (D4+/BCB4+)
  SUPPORTS_DEPRECATED            Compiler supports the deprecated directive (D6+/BCB6+)
  SUPPORTS_PLATFORM              Compiler supports the platform directive (D6+/BCB6+)
  SUPPORTS_LIBRARY               Compiler supports the library directive (D6+/BCB6+/FPC)
  SUPPORTS_LOCAL                 Compiler supports the local directive (D6+/BCB6+)
  SUPPORTS_SETPEFLAGS            Compiler supports the SetPEFlags directive (D6+/BCB6+)
  SUPPORTS_EXPERIMENTAL_WARNINGS Compiler supports the WARN SYMBOL_EXPERIMENTAL and WARN UNIT_EXPERIMENTAL directives (D6+/BCB6+)
  SUPPORTS_INLINE                Compiler supports the inline directive (D9+/FPC)
  SUPPORTS_FOR_IN                Compiler supports for in loops (D9+)
  SUPPORTS_NESTED_CONSTANTS      Compiler supports nested constants (D9+)
  SUPPORTS_NESTED_TYPES          Compiler supports nested types (D9+)
  SUPPORTS_REGION                Compiler supports the REGION and ENDREGION directives (D9+)
  SUPPORTS_ENHANCED_RECORDS      Compiler supports class [operator|function|procedure] for record types (D9.NET, D10+)
  SUPPORTS_CLASS_FIELDS          Compiler supports class fields (D9.NET, D10+)
  SUPPORTS_CLASS_HELPERS         Compiler supports class helpers (D9.NET, D10+)
  SUPPORTS_CLASS_OPERATORS       Compiler supports class operators (D9.NET, D10+)
  SUPPORTS_CLASS_CTORDTORS       Compiler supports class contructors/destructors (D14+)
  SUPPORTS_STRICT                Compiler supports strict keyword (D9.NET, D10+)
  SUPPORTS_STATIC                Compiler supports static keyword (D9.NET, D10+)
  SUPPORTS_FINAL                 Compiler supports final keyword (D9.NET, D10+)
  SUPPORTS_METHODINFO            Compiler supports the METHODINFO directives (D10+)
  SUPPORTS_GENERICS              Compiler supports generic implementations (D11.NET, D12+)
  SUPPORTS_DEPRECATED_DETAILS    Compiler supports additional text for the deprecated directive (D11.NET, D12+)
  ACCEPT_DEPRECATED              Compiler supports or ignores the deprecated directive (D6+/BCB6+/FPC)
  ACCEPT_PLATFORM                Compiler supports or ignores the platform directive (D6+/BCB6+/FPC)
  ACCEPT_LIBRARY                 Compiler supports or ignores the library directive (D6+/BCB6+)
  SUPPORTS_CUSTOMVARIANTS        Compiler supports custom variants (D6+/BCB6+)
  SUPPORTS_VARARGS               Compiler supports varargs (D6+/BCB6+)
  SUPPORTS_ENUMVALUE             Compiler supports assigning ordinalities to values of enums (D6+/BCB6+)
  SUPPORTS_DEPRECATED_WARNINGS   Compiler supports deprecated warnings (D6+/BCB6+)
  SUPPORTS_LIBRARY_WARNINGS      Compiler supports library warnings (D6+/BCB6+)
  SUPPORTS_PLATFORM_WARNINGS     Compiler supports platform warnings (D6+/BCB6+)
  SUPPORTS_UNSAFE_WARNINGS       Compiler supports unsafe warnings (D7)
  SUPPORTS_WEAKPACKAGEUNIT       Compiler supports the WEAKPACKAGEUNIT directive
  SUPPORTS_COMPILETIME_MESSAGES  Compiler supports the MESSAGE directive
  SUPPORTS_PACKAGES              Compiler supports Packages
  HAS_UNIT_LIBC                  Unit Libc exists (Kylix, FPC on Linux/x86)
  HAS_UNIT_RTLCONSTS             Unit RTLConsts exists (D6+/BCB6+/FPC)
  HAS_UNIT_TYPES                 Unit Types exists (D6+/BCB6+/FPC)
  HAS_UNIT_VARIANTS              Unit Variants exists (D6+/BCB6+/FPC)
  HAS_UNIT_STRUTILS              Unit StrUtils exists (D6+/BCB6+/FPC)
  HAS_UNIT_DATEUTILS             Unit DateUtils exists (D6+/BCB6+/FPC)
  HAS_UNIT_CONTNRS               Unit contnrs exists (D6+/BCB6+/FPC)
  HAS_UNIT_HTTPPROD              Unit HTTPProd exists (D9+)
  HAS_UNIT_GIFIMG                Unit GifImg exists (D11+)
  HAS_UNIT_ANSISTRINGS           Unit AnsiStrings exists (D12+)
  HAS_UNIT_PNGIMAGE              Unit PngImage exists (D12+)
  HAS_UNIT_CHARACTER             Unit Character exists (D12+)
  XPLATFORM_RTL                  The RTL supports crossplatform function names (e.g. RaiseLastOSError) (D6+/BCB6+/FPC)
  SUPPORTS_UNICODE               string type is aliased to an unicode string (WideString or UnicodeString) (DX.NET, D12+)
  SUPPORTS_UNICODE_STRING        Compiler supports UnicodeString (D12+)
  SUPPORTS_INT_ALIASES           Types Int8, Int16, Int32, UInt8, UInt16 and UInt32 are defined in the unit System (D12+)
  HAS_UNIT_RTTI                  Unit RTTI is available (D14+)
  SUPPORTS_CAST_INTERFACE_TO_OBJ The compiler supports casts from interfaces to objects (D14+)
  SUPPORTS_DELAYED_LOADING       The compiler generates stubs for delaying imported function loads (D14+)
  HAS_UNIT_REGULAREXPRESSIONSAPI Unit RegularExpressionsAPI is available (D15+)
  HAS_UNIT_SYSTEM_UITYPES        Unit System.UITypes is available (D16+)
  HAS_UNIT_SYSTEM_ACTIONS        Unit System.Actions is available (D17+)
  DEPRECATED_SYSUTILS_ANSISTRINGS  AnsiString functions from SysUtils are deprecated and moved to System.AnsiStrings (D18+)
  HAS_PROPERTY_STYLEELEMENTS     TControl has a StyleElements property (D17+)
  HAS_AUTOMATIC_DB_FIELDS        Database fields are automatically created/refreshed (D20+)
  HAS_EARGUMENTEXCEPTION         Exception class EArgumentException is available (D14+)
  HAS_ENOTIMPLEMENTED            Exception class ENotImplemented is available (D15+)
  HAS_UNIT_VCL_THEMES            Unit Vcl.Themes is available (D16+)
  HAS_UNIT_UXTHEME               Unit (Vcl.)UxTheme is available (D7+)
  HAS_EXCEPTION_STACKTRACE       Exception class has the StackTrace propery (D12+)


- Compiler Settings

  The compiler settings directives indicate whether a specific compiler setting
  is in effect. This facilitates changing compiler settings locally in a more
  compact and readible manner.

  Directive              Description
  ------------------------------------------------------------------------------
  ALIGN_ON               Compiling in the A+ state (no alignment)
  BOOLEVAL_ON            Compiling in the B+ state (complete boolean evaluation)
  ASSERTIONS_ON          Compiling in the C+ state (assertions on)
  DEBUGINFO_ON           Compiling in the D+ state (debug info generation on)
  IMPORTEDDATA_ON        Compiling in the G+ state (creation of imported data references)
  LONGSTRINGS_ON         Compiling in the H+ state (string defined as AnsiString)
  IOCHECKS_ON            Compiling in the I+ state (I/O checking enabled)
  WRITEABLECONST_ON      Compiling in the J+ state (typed constants can be modified)
  LOCALSYMBOLS           Compiling in the L+ state (local symbol generation)
  LOCALSYMBOLS_ON        Alias of LOCALSYMBOLS
  TYPEINFO_ON            Compiling in the M+ state (RTTI generation on)
  OPTIMIZATION_ON        Compiling in the O+ state (code optimization on)
  OPENSTRINGS_ON         Compiling in the P+ state (variable string parameters are openstrings)
  OVERFLOWCHECKS_ON      Compiling in the Q+ state (overflow checing on)
  RANGECHECKS_ON         Compiling in the R+ state (range checking on)
  TYPEDADDRESS_ON        Compiling in the T+ state (pointers obtained using the @ operator are typed)
  SAFEDIVIDE_ON          Compiling in the U+ state (save FDIV instruction through RTL emulation)
  VARSTRINGCHECKS_ON     Compiling in the V+ state (type checking of shortstrings)
  STACKFRAMES_ON         Compiling in the W+ state (generation of stack frames)
  EXTENDEDSYNTAX_ON      Compiling in the X+ state (Delphi extended syntax enabled)
*)

{$DEFINE BORLAND}

{ Set FreePascal to Delphi mode }
{$IFDEF FPC}
  {$MODE DELPHI}
  {$ASMMODE Intel}
  {$UNDEF BORLAND}
  {$DEFINE CPUASM}
   // FPC defines CPU32, CPU64 and Unix automatically
{$ENDIF}

{$IFDEF BORLAND}

  {$IFNDEF CLR}
    {$IFNDEF CPUX86}
      {$IFNDEF CPUX64}
        {$DEFINE CPU386}  // For Borland compilers select the x86 compat assembler by default
        {$DEFINE CPU32}   // Assume Borland compilers are 32-bit (rather than 64-bit)
        {$DEFINE CPUASM}
      {$ELSE ~CPUX64}
        {$DEFINE CPU64}
        {$DEFINE CPUASM}
        {$DEFINE DELPHI64_TEMPORARY}
      {$ENDIF ~CPUX64}
    {$ELSE ~CPUX86}
      {$DEFINE CPU386}
      {$DEFINE CPU32}
      {$DEFINE CPUASM}
    {$ENDIF ~CPUX86}
  {$ENDIF ~CLR}
{$ENDIF BORLAND}

{------------------------------------------------------------------------------}
{ VERXXX to COMPILERX, DELPHIX and BCBX mappings                               }
{------------------------------------------------------------------------------}

{$IFDEF BORLAND}
  
    {$DEFINE UNKNOWN_COMPILER_VERSION}

    {$IFDEF VER80}
      {$DEFINE COMPILER1}
      {$DEFINE DELPHI1}
      {$DEFINE DELPHICOMPILER1}
      {$DEFINE RTL80_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER90}
      {$DEFINE COMPILER2}
      {$DEFINE DELPHI2}
      {$DEFINE DELPHICOMPILER2}
      {$DEFINE RTL90_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER93}
      {$DEFINE COMPILER2}
      {$DEFINE BCB1}
      {$DEFINE BCB}
      {$DEFINE RTL93_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER100}
      {$DEFINE COMPILER3}
      {$DEFINE DELPHI3}
      {$DEFINE DELPHICOMPILER3}
      {$DEFINE RTL100_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER110}
      {$DEFINE COMPILER35}
      {$DEFINE BCB3}
      {$DEFINE BCB}
      {$DEFINE RTL110_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER120}
      {$DEFINE COMPILER4}
      {$DEFINE DELPHI4}
      {$DEFINE DELPHICOMPILER4}
      {$DEFINE RTL120_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER125}
      {$DEFINE COMPILER4}
      {$DEFINE BCB4}
      {$DEFINE BCB}
      {$DEFINE RTL125_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER130}
      {$DEFINE COMPILER5}
      {$IFDEF BCB}
        {$DEFINE BCB5}
      {$ELSE}
        {$DEFINE DELPHI5}
        {$DEFINE DELPHICOMPILER5}
      {$ENDIF}
      {$DEFINE RTL130_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER140}
      {$DEFINE COMPILER6}
      {$IFDEF BCB}
        {$DEFINE BCB6}
      {$ELSE}
        {$DEFINE DELPHI6}
        {$DEFINE DELPHICOMPILER6}
      {$ENDIF}
      {$DEFINE RTL140_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER150}
      {$DEFINE COMPILER7}
      {$DEFINE DELPHI7}
      {$DEFINE DELPHICOMPILER7}
      {$DEFINE RTL150_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER160}
      {$DEFINE BDS2}
      {$DEFINE BDS}
      {$IFDEF CLR}
        {$DEFINE CLR10}
      {$ENDIF CLR}
      {$DEFINE COMPILER8}
      {$DEFINE DELPHI8}
      {$DEFINE DELPHICOMPILER8}
      {$DEFINE RTL160_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER170}
      {$DEFINE BDS3}
      {$DEFINE BDS}
      {$IFDEF CLR}
        {$DEFINE CLR11}
      {$ENDIF CLR}
      {$DEFINE COMPILER9}
      {$DEFINE DELPHI9}
      {$DEFINE DELPHI2005} // synonym to DELPHI9
      {$DEFINE DELPHICOMPILER9}
      {$DEFINE RTL170_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER180}
      {$DEFINE BDS}
      {$IFDEF CLR}
        {$DEFINE CLR11}
      {$ENDIF CLR}
      {$IFDEF VER185}
        {$DEFINE BDS5}
        {$DEFINE COMPILER11}
        {$IFDEF BCB}
          {$DEFINE BCB11}
        {$ELSE}
          {$DEFINE DELPHI11}
          {$DEFINE DELPHI2007} // synonym to DELPHI11
          {$DEFINE DELPHICOMPILER11}
        {$ENDIF}
        {$DEFINE RTL185_UP}
      {$ELSE ~~VER185}
        {$DEFINE BDS4}
        {$DEFINE COMPILER10}
        {$IFDEF BCB}
          {$DEFINE BCB10}
        {$ELSE}
          {$DEFINE DELPHI10}
          {$DEFINE DELPHI2006} // synonym to DELPHI10
          {$DEFINE DELPHICOMPILER10}
        {$ENDIF}
        {$DEFINE RTL180_UP}
      {$ENDIF ~VER185}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

    {$IFDEF VER190} // Delphi 2007 for .NET
      {$DEFINE BDS}
      {$DEFINE BDS5}
      {$IFDEF CLR}
        {$DEFINE CLR20}
      {$ENDIF CLR}
      {$DEFINE COMPILER11}
      {$DEFINE DELPHI11}
      {$DEFINE DELPHI2007} // synonym to DELPHI11
      {$DEFINE DELPHICOMPILER11}
      {$DEFINE RTL190_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER190}

    {$IFDEF VER200} // RAD Studio 2009
      {$DEFINE BDS}
      {$DEFINE BDS6}
      {$IFDEF CLR}
        {$DEFINE CLR20}
      {$ENDIF CLR}
      {$DEFINE COMPILER12}
      {$IFDEF BCB}
        {$DEFINE BCB12}
      {$ELSE}
        {$DEFINE DELPHI12}
        {$DEFINE DELPHI2009} // synonym to DELPHI12
        {$DEFINE DELPHICOMPILER12}
      {$ENDIF BCB}
      {$IFDEF CLR}
        {$DEFINE RTL190_UP}
      {$ELSE}
        {$DEFINE RTL200_UP}
      {$ENDIF}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER200}

    {$IFDEF VER210} // RAD Studio 2010
      {$DEFINE BDS}
      {$DEFINE BDS7}
      {$DEFINE COMPILER14}
      {$IFDEF BCB}
        {$DEFINE BCB14}
      {$ELSE}
        {$DEFINE DELPHI14}
        {$DEFINE DELPHI2010} // synonym to DELPHI14
        {$DEFINE DELPHICOMPILER14}
      {$ENDIF BCB}
      {$DEFINE RTL210_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER210}

    {$IFDEF VER220} // RAD Studio XE
      {$DEFINE BDS}
      {$DEFINE BDS8}
      {$DEFINE COMPILER15}
      {$IFDEF BCB}
        {$DEFINE BCB15}
      {$ELSE}
        {$DEFINE DELPHI15}
        {$DEFINE DELPHIXE} // synonym to DELPHI15
        {$DEFINE DELPHICOMPILER15}
      {$ENDIF BCB}
      {$DEFINE RTL220_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER220}

    {$IFDEF VER230} // RAD Studio XE2
      {$DEFINE BDS}
      {$DEFINE BDS9}
      {$DEFINE COMPILER16}
      {$IFDEF BCB}
        {$DEFINE BCB16}
      {$ELSE}
        {$DEFINE DELPHI16}
        {$DEFINE DELPHIXE2} // synonym to DELPHI16
        {$DEFINE DELPHICOMPILER16}
      {$ENDIF BCB}
      {$DEFINE RTL230_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER230}

    {$IFDEF VER240} // RAD Studio XE3
      {$DEFINE BDS}
      {$DEFINE BDS10}
      {$DEFINE COMPILER17}
      {$IFDEF BCB}
        {$DEFINE BCB17}
      {$ELSE}
        {$DEFINE DELPHI17}
        {$DEFINE DELPHIXE3} // synonym to DELPHI17
        {$DEFINE DELPHICOMPILER17}
      {$ENDIF BCB}
      {$DEFINE RTL240_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER240}

    {$IFDEF VER250} // RAD Studio XE4
      {$DEFINE BDS}
      {$DEFINE BDS11}
      {$DEFINE COMPILER18}
      {$IFDEF BCB}
        {$DEFINE BCB18}
      {$ELSE}
        {$DEFINE DELPHI18}
        {$DEFINE DELPHIXE4} // synonym to DELPHI18
        {$DEFINE DELPHICOMPILER18}
      {$ENDIF BCB}
      {$DEFINE RTL250_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER250}

    {$IFDEF VER260} // RAD Studio XE5
      {$DEFINE BDS}
      {$DEFINE BDS12}
      {$DEFINE COMPILER19}
      {$IFDEF BCB}
        {$DEFINE BCB19}
      {$ELSE}
        {$DEFINE DELPHI19}
        {$DEFINE DELPHIXE5} // synonym to DELPHI19
        {$DEFINE DELPHICOMPILER19}
      {$ENDIF BCB}
      {$DEFINE RTL260_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER260}

    {$IFDEF VER270} // RAD Studio XE6
      {$DEFINE BDS}
      {$DEFINE BDS14}
      {$DEFINE COMPILER20}
      {$IFDEF BCB}
        {$DEFINE BCB20}
      {$ELSE}
        {$DEFINE DELPHI20}
        {$DEFINE DELPHIXE6} // synonym to DELPHI20
        {$DEFINE DELPHICOMPILER20}
      {$ENDIF BCB}
      {$DEFINE RTL270_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER270}

    {$IFDEF VER280} // RAD Studio XE7
      {$DEFINE BDS}
      {$DEFINE BDS15}
      {$DEFINE COMPILER21}
      {$IFDEF BCB}
        {$DEFINE BCB21}
      {$ELSE}
        {$DEFINE DELPHI21}
        {$DEFINE DELPHIXE7} // synonym to DELPHI21
        {$DEFINE DELPHICOMPILER21}
      {$ENDIF BCB}
      {$DEFINE RTL280_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER280}

    {$IFDEF VER290} // RAD Studio XE8
      {$DEFINE BDS}
      {$DEFINE BDS16}
      {$DEFINE COMPILER22}
      {$IFDEF BCB}
        {$DEFINE BCB22}
      {$ELSE}
        {$DEFINE DELPHI22}
        {$DEFINE DELPHIXE8} // synonym to DELPHI22
        {$DEFINE DELPHICOMPILER22}
      {$ENDIF BCB}
      {$DEFINE RTL290_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER290}

    {$IFDEF VER300} // RAD Studio 10
      {$DEFINE BDS}
      {$DEFINE BDS17}
      {$DEFINE COMPILER23}
      {$IFDEF BCB}
        {$DEFINE BCB23}
      {$ELSE}
        {$DEFINE DELPHI23}
        {$DEFINE DELPHIX_SEATTLE} // synonym to DELPHI23
        {$DEFINE DELPHICOMPILER23}
      {$ENDIF BCB}
      {$DEFINE RTL300_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF VER290}

    {$IFDEF UNKNOWN_COMPILER_VERSION} // adjust for newer version (always use latest version)
      {$DEFINE BDS}
      {$DEFINE BDS17}
      {$DEFINE COMPILER23}
      {$IFDEF BCB}
        {$DEFINE BCB23}
      {$ELSE}
        {$DEFINE DELPHI23}
        {$DEFINE DELPHIX_SEATTLE} // synonym to DELPHI23
        {$DEFINE DELPHICOMPILER23}
      {$ENDIF BCB}
      {$DEFINE RTL300_UP}
      {$UNDEF UNKNOWN_COMPILER_VERSION}
    {$ENDIF}

  {$ENDIF ~KYLIX}

  {$IFDEF BCB}
    {$DEFINE CPPBUILDER}
    {$DEFINE BCBCOMPILER}
  {$ELSE ~BCB}
    {$DEFINE DELPHI}
    {$DEFINE DELPHICOMPILER}
  {$ENDIF ~BCB}

{$ENDIF BORLAND}

{------------------------------------------------------------------------------}
{ DELPHIX_UP from DELPHIX mappings                                             }
{------------------------------------------------------------------------------}

{$IFDEF DELPHI23} {$DEFINE DELPHI23_UP} {$ENDIF}
{$IFDEF DELPHI22} {$DEFINE DELPHI22_UP} {$ENDIF}
{$IFDEF DELPHI21} {$DEFINE DELPHI21_UP} {$ENDIF}
{$IFDEF DELPHI20} {$DEFINE DELPHI20_UP} {$ENDIF}
{$IFDEF DELPHI19} {$DEFINE DELPHI19_UP} {$ENDIF}
{$IFDEF DELPHI18} {$DEFINE DELPHI18_UP} {$ENDIF}
{$IFDEF DELPHI17} {$DEFINE DELPHI17_UP} {$ENDIF}
{$IFDEF DELPHI16} {$DEFINE DELPHI16_UP} {$ENDIF}
{$IFDEF DELPHI15} {$DEFINE DELPHI15_UP} {$ENDIF}
{$IFDEF DELPHI14} {$DEFINE DELPHI14_UP} {$ENDIF}
{$IFDEF DELPHI12} {$DEFINE DELPHI12_UP} {$ENDIF}
{$IFDEF DELPHI11} {$DEFINE DELPHI11_UP} {$ENDIF}
{$IFDEF DELPHI10} {$DEFINE DELPHI10_UP} {$ENDIF}
{$IFDEF DELPHI9}  {$DEFINE DELPHI9_UP}  {$ENDIF}
{$IFDEF DELPHI8}  {$DEFINE DELPHI8_UP}  {$ENDIF}
{$IFDEF DELPHI7}  {$DEFINE DELPHI7_UP}  {$ENDIF}
{$IFDEF DELPHI6}  {$DEFINE DELPHI6_UP}  {$ENDIF}
{$IFDEF DELPHI5}  {$DEFINE DELPHI5_UP}  {$ENDIF}
{$IFDEF DELPHI4}  {$DEFINE DELPHI4_UP}  {$ENDIF}
{$IFDEF DELPHI3}  {$DEFINE DELPHI3_UP}  {$ENDIF}
{$IFDEF DELPHI2}  {$DEFINE DELPHI2_UP}  {$ENDIF}
{$IFDEF DELPHI1}  {$DEFINE DELPHI1_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ DELPHIX_UP from DELPHIX_UP mappings                                          }
{------------------------------------------------------------------------------}

{$IFDEF DELPHI23_UP}
  {$DEFINE DELPHIX_SEATTLE_UP} // synonym to DELPHI23_UP
  {$DEFINE DELPHI22_UP}
{$ENDIF}

{$IFDEF DELPHI22_UP}
  {$DEFINE DELPHIXE8_UP} // synonym to DELPHI22_UP
  {$DEFINE DELPHI21_UP}
{$ENDIF}

{$IFDEF DELPHI21_UP}
  {$DEFINE DELPHIXE7_UP} // synonym to DELPHI21_UP
  {$DEFINE DELPHI20_UP}
{$ENDIF}

{$IFDEF DELPHI20_UP}
  {$DEFINE DELPHIXE6_UP} // synonym to DELPHI20_UP
  {$DEFINE DELPHI19_UP}
{$ENDIF}

{$IFDEF DELPHI19_UP}
  {$DEFINE DELPHIXE5_UP} // synonym to DELPHI19_UP
  {$DEFINE DELPHI18_UP}
{$ENDIF}

{$IFDEF DELPHI18_UP}
  {$DEFINE DELPHIXE4_UP} // synonym to DELPHI18_UP
  {$DEFINE DELPHI17_UP}
{$ENDIF}

{$IFDEF DELPHI17_UP}
  {$DEFINE DELPHIXE3_UP} // synonym to DELPHI17_UP
  {$DEFINE DELPHI16_UP}
{$ENDIF}

{$IFDEF DELPHI16_UP}
  {$DEFINE DELPHIXE2_UP} // synonym to DELPHI16_UP
  {$DEFINE DELPHI15_UP}
{$ENDIF}

{$IFDEF DELPHI15_UP}
  {$DEFINE DELPHIXE_UP} // synonym to DELPHI15_UP
  {$DEFINE DELPHI14_UP}
{$ENDIF}

{$IFDEF DELPHI14_UP}
  {$DEFINE DELPHI2010_UP} // synonym to DELPHI14_UP
  {$DEFINE DELPHI12_UP}
{$ENDIF}

{$IFDEF DELPHI12_UP}
  {$DEFINE DELPHI2009_UP} // synonym to DELPHI12_UP
  {$DEFINE DELPHI11_UP}
{$ENDIF}

{$IFDEF DELPHI11_UP}
  {$DEFINE DELPHI2007_UP} // synonym to DELPHI11_UP
  {$DEFINE DELPHI10_UP}
{$ENDIF}

{$IFDEF DELPHI10_UP}
  {$DEFINE DELPHI2006_UP} // synonym to DELPHI10_UP
  {$DEFINE DELPHI9_UP}
{$ENDIF}

{$IFDEF DELPHI9_UP}
  {$DEFINE DELPHI2005_UP} // synonym to DELPHI9_UP
  {$DEFINE DELPHI8_UP}
{$ENDIF}

{$IFDEF DELPHI8_UP} {$DEFINE DELPHI7_UP} {$ENDIF}
{$IFDEF DELPHI7_UP} {$DEFINE DELPHI6_UP} {$ENDIF}
{$IFDEF DELPHI6_UP} {$DEFINE DELPHI5_UP} {$ENDIF}
{$IFDEF DELPHI5_UP} {$DEFINE DELPHI4_UP} {$ENDIF}
{$IFDEF DELPHI4_UP} {$DEFINE DELPHI3_UP} {$ENDIF}
{$IFDEF DELPHI3_UP} {$DEFINE DELPHI2_UP} {$ENDIF}
{$IFDEF DELPHI2_UP} {$DEFINE DELPHI1_UP} {$ENDIF}

{------------------------------------------------------------------------------}
{ BCBX_UP from BCBX mappings                                                   }
{------------------------------------------------------------------------------}

{$IFDEF BCB23} {$DEFINE BCB23_UP} {$ENDIF}
{$IFDEF BCB22} {$DEFINE BCB22_UP} {$ENDIF}
{$IFDEF BCB21} {$DEFINE BCB21_UP} {$ENDIF}
{$IFDEF BCB20} {$DEFINE BCB20_UP} {$ENDIF}
{$IFDEF BCB19} {$DEFINE BCB19_UP} {$ENDIF}
{$IFDEF BCB18} {$DEFINE BCB18_UP} {$ENDIF}
{$IFDEF BCB17} {$DEFINE BCB17_UP} {$ENDIF}
{$IFDEF BCB16} {$DEFINE BCB16_UP} {$ENDIF}
{$IFDEF BCB15} {$DEFINE BCB15_UP} {$ENDIF}
{$IFDEF BCB14} {$DEFINE BCB14_UP} {$ENDIF}
{$IFDEF BCB12} {$DEFINE BCB12_UP} {$ENDIF}
{$IFDEF BCB11} {$DEFINE BCB11_UP} {$ENDIF}
{$IFDEF BCB10} {$DEFINE BCB10_UP} {$ENDIF}
{$IFDEF BCB6}  {$DEFINE BCB6_UP}  {$ENDIF}
{$IFDEF BCB5}  {$DEFINE BCB5_UP}  {$ENDIF}
{$IFDEF BCB4}  {$DEFINE BCB4_UP}  {$ENDIF}
{$IFDEF BCB3}  {$DEFINE BCB3_UP}  {$ENDIF}
{$IFDEF BCB1}  {$DEFINE BCB1_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ BCBX_UP from BCBX_UP mappings                                                }
{------------------------------------------------------------------------------}

{$IFDEF BCB23_UP} {$DEFINE BCB22_UP} {$ENDIF}
{$IFDEF BCB22_UP} {$DEFINE BCB21_UP} {$ENDIF}
{$IFDEF BCB21_UP} {$DEFINE BCB20_UP} {$ENDIF}
{$IFDEF BCB20_UP} {$DEFINE BCB19_UP} {$ENDIF}
{$IFDEF BCB19_UP} {$DEFINE BCB18_UP} {$ENDIF}
{$IFDEF BCB18_UP} {$DEFINE BCB17_UP} {$ENDIF}
{$IFDEF BCB17_UP} {$DEFINE BCB16_UP} {$ENDIF}
{$IFDEF BCB16_UP} {$DEFINE BCB15_UP} {$ENDIF}
{$IFDEF BCB15_UP} {$DEFINE BCB14_UP} {$ENDIF}
{$IFDEF BCB14_UP} {$DEFINE BCB12_UP} {$ENDIF}
{$IFDEF BCB12_UP} {$DEFINE BCB11_UP} {$ENDIF}
{$IFDEF BCB11_UP} {$DEFINE BCB10_UP} {$ENDIF}
{$IFDEF BCB10_UP} {$DEFINE BCB6_UP}  {$ENDIF}
{$IFDEF BCB6_UP}  {$DEFINE BCB5_UP}  {$ENDIF}
{$IFDEF BCB5_UP}  {$DEFINE BCB4_UP}  {$ENDIF}
{$IFDEF BCB4_UP}  {$DEFINE BCB3_UP}  {$ENDIF}
{$IFDEF BCB3_UP}  {$DEFINE BCB1_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ BDSX_UP from BDSX mappings                                                   }
{------------------------------------------------------------------------------}

{$IFDEF BDS17} {$DEFINE BDS17_UP} {$ENDIF}
{$IFDEF BDS16} {$DEFINE BDS16_UP} {$ENDIF}
{$IFDEF BDS15} {$DEFINE BDS15_UP} {$ENDIF}
{$IFDEF BDS14} {$DEFINE BDS14_UP} {$ENDIF}
{$IFDEF BDS12} {$DEFINE BDS12_UP} {$ENDIF}
{$IFDEF BDS11} {$DEFINE BDS11_UP} {$ENDIF}
{$IFDEF BDS10} {$DEFINE BDS10_UP} {$ENDIF}
{$IFDEF BDS9} {$DEFINE BDS9_UP} {$ENDIF}
{$IFDEF BDS8} {$DEFINE BDS8_UP} {$ENDIF}
{$IFDEF BDS7} {$DEFINE BDS7_UP} {$ENDIF}
{$IFDEF BDS6} {$DEFINE BDS6_UP} {$ENDIF}
{$IFDEF BDS5} {$DEFINE BDS5_UP} {$ENDIF}
{$IFDEF BDS4} {$DEFINE BDS4_UP} {$ENDIF}
{$IFDEF BDS3} {$DEFINE BDS3_UP} {$ENDIF}
{$IFDEF BDS2} {$DEFINE BDS2_UP} {$ENDIF}

{------------------------------------------------------------------------------}
{ BDSX_UP from BDSX_UP mappings                                                }
{------------------------------------------------------------------------------}

{$IFDEF BDS17_UP} {$DEFINE BDS16_UP} {$ENDIF}
{$IFDEF BDS16_UP} {$DEFINE BDS15_UP} {$ENDIF}
{$IFDEF BDS15_UP} {$DEFINE BDS14_UP} {$ENDIF}
{$IFDEF BDS14_UP} {$DEFINE BDS12_UP} {$ENDIF}
{$IFDEF BDS12_UP} {$DEFINE BDS11_UP} {$ENDIF}
{$IFDEF BDS11_UP} {$DEFINE BDS10_UP} {$ENDIF}
{$IFDEF BDS10_UP} {$DEFINE BDS9_UP} {$ENDIF}
{$IFDEF BDS9_UP} {$DEFINE BDS8_UP} {$ENDIF}
{$IFDEF BDS8_UP} {$DEFINE BDS7_UP} {$ENDIF}
{$IFDEF BDS7_UP} {$DEFINE BDS6_UP} {$ENDIF}
{$IFDEF BDS6_UP} {$DEFINE BDS5_UP} {$ENDIF}
{$IFDEF BDS5_UP} {$DEFINE BDS4_UP} {$ENDIF}
{$IFDEF BDS4_UP} {$DEFINE BDS3_UP} {$ENDIF}
{$IFDEF BDS3_UP} {$DEFINE BDS2_UP} {$ENDIF}

{------------------------------------------------------------------------------}
{ DELPHICOMPILERX_UP from DELPHICOMPILERX mappings                             }
{------------------------------------------------------------------------------}

{$IFDEF DELPHICOMPILER23} {$DEFINE DELPHICOMPILER23_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER22} {$DEFINE DELPHICOMPILER22_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER21} {$DEFINE DELPHICOMPILER21_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER20} {$DEFINE DELPHICOMPILER20_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER19} {$DEFINE DELPHICOMPILER19_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER18} {$DEFINE DELPHICOMPILER18_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER17} {$DEFINE DELPHICOMPILER17_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER16} {$DEFINE DELPHICOMPILER16_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER15} {$DEFINE DELPHICOMPILER15_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER14} {$DEFINE DELPHICOMPILER14_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER12} {$DEFINE DELPHICOMPILER12_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER11} {$DEFINE DELPHICOMPILER11_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER10} {$DEFINE DELPHICOMPILER10_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER9}  {$DEFINE DELPHICOMPILER9_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER8}  {$DEFINE DELPHICOMPILER8_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER7}  {$DEFINE DELPHICOMPILER7_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER6}  {$DEFINE DELPHICOMPILER6_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER5}  {$DEFINE DELPHICOMPILER5_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER4}  {$DEFINE DELPHICOMPILER4_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER3}  {$DEFINE DELPHICOMPILER3_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER2}  {$DEFINE DELPHICOMPILER2_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER1}  {$DEFINE DELPHICOMPILER1_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ DELPHICOMPILERX_UP from DELPHICOMPILERX_UP mappings                          }
{------------------------------------------------------------------------------}

{$IFDEF DELPHICOMPILER23_UP} {$DEFINE DELPHICOMPILER22_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER22_UP} {$DEFINE DELPHICOMPILER21_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER21_UP} {$DEFINE DELPHICOMPILER20_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER20_UP} {$DEFINE DELPHICOMPILER19_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER19_UP} {$DEFINE DELPHICOMPILER18_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER18_UP} {$DEFINE DELPHICOMPILER17_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER17_UP} {$DEFINE DELPHICOMPILER16_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER16_UP} {$DEFINE DELPHICOMPILER15_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER15_UP} {$DEFINE DELPHICOMPILER14_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER14_UP} {$DEFINE DELPHICOMPILER12_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER12_UP} {$DEFINE DELPHICOMPILER11_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER11_UP} {$DEFINE DELPHICOMPILER10_UP} {$ENDIF}
{$IFDEF DELPHICOMPILER10_UP} {$DEFINE DELPHICOMPILER9_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER9_UP}  {$DEFINE DELPHICOMPILER8_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER8_UP}  {$DEFINE DELPHICOMPILER7_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER8_UP}  {$DEFINE DELPHICOMPILER7_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER7_UP}  {$DEFINE DELPHICOMPILER6_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER6_UP}  {$DEFINE DELPHICOMPILER5_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER5_UP}  {$DEFINE DELPHICOMPILER4_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER4_UP}  {$DEFINE DELPHICOMPILER3_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER3_UP}  {$DEFINE DELPHICOMPILER2_UP}  {$ENDIF}
{$IFDEF DELPHICOMPILER2_UP}  {$DEFINE DELPHICOMPILER1_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ COMPILERX_UP from COMPILERX mappings                                         }
{------------------------------------------------------------------------------}

{$IFDEF COMPILER23} {$DEFINE COMPILER23_UP} {$ENDIF}
{$IFDEF COMPILER22} {$DEFINE COMPILER22_UP} {$ENDIF}
{$IFDEF COMPILER21} {$DEFINE COMPILER21_UP} {$ENDIF}
{$IFDEF COMPILER20} {$DEFINE COMPILER20_UP} {$ENDIF}
{$IFDEF COMPILER19} {$DEFINE COMPILER19_UP} {$ENDIF}
{$IFDEF COMPILER18} {$DEFINE COMPILER18_UP} {$ENDIF}
{$IFDEF COMPILER17} {$DEFINE COMPILER17_UP} {$ENDIF}
{$IFDEF COMPILER16} {$DEFINE COMPILER16_UP} {$ENDIF}
{$IFDEF COMPILER15} {$DEFINE COMPILER15_UP} {$ENDIF}
{$IFDEF COMPILER14} {$DEFINE COMPILER14_UP} {$ENDIF}
{$IFDEF COMPILER12} {$DEFINE COMPILER12_UP} {$ENDIF}
{$IFDEF COMPILER11} {$DEFINE COMPILER11_UP} {$ENDIF}
{$IFDEF COMPILER10} {$DEFINE COMPILER10_UP} {$ENDIF}
{$IFDEF COMPILER9}  {$DEFINE COMPILER9_UP}  {$ENDIF}
{$IFDEF COMPILER8}  {$DEFINE COMPILER8_UP}  {$ENDIF}
{$IFDEF COMPILER7}  {$DEFINE COMPILER7_UP}  {$ENDIF}
{$IFDEF COMPILER6}  {$DEFINE COMPILER6_UP}  {$ENDIF}
{$IFDEF COMPILER5}  {$DEFINE COMPILER5_UP}  {$ENDIF}
{$IFDEF COMPILER4}  {$DEFINE COMPILER4_UP}  {$ENDIF}
{$IFDEF COMPILER35} {$DEFINE COMPILER35_UP} {$ENDIF}
{$IFDEF COMPILER3}  {$DEFINE COMPILER3_UP}  {$ENDIF}
{$IFDEF COMPILER2}  {$DEFINE COMPILER2_UP}  {$ENDIF}
{$IFDEF COMPILER1}  {$DEFINE COMPILER1_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ COMPILERX_UP from COMPILERX_UP mappings                                      }
{------------------------------------------------------------------------------}

{$IFDEF COMPILER23_UP} {$DEFINE COMPILER22_UP} {$ENDIF}
{$IFDEF COMPILER22_UP} {$DEFINE COMPILER21_UP} {$ENDIF}
{$IFDEF COMPILER21_UP} {$DEFINE COMPILER20_UP} {$ENDIF}
{$IFDEF COMPILER20_UP} {$DEFINE COMPILER19_UP} {$ENDIF}
{$IFDEF COMPILER19_UP} {$DEFINE COMPILER18_UP} {$ENDIF}
{$IFDEF COMPILER18_UP} {$DEFINE COMPILER17_UP} {$ENDIF}
{$IFDEF COMPILER17_UP} {$DEFINE COMPILER16_UP} {$ENDIF}
{$IFDEF COMPILER16_UP} {$DEFINE COMPILER15_UP} {$ENDIF}
{$IFDEF COMPILER15_UP} {$DEFINE COMPILER14_UP} {$ENDIF}
{$IFDEF COMPILER14_UP} {$DEFINE COMPILER12_UP} {$ENDIF}
{$IFDEF COMPILER12_UP} {$DEFINE COMPILER11_UP} {$ENDIF}
{$IFDEF COMPILER11_UP} {$DEFINE COMPILER10_UP} {$ENDIF}
{$IFDEF COMPILER10_UP} {$DEFINE COMPILER9_UP}  {$ENDIF}
{$IFDEF COMPILER9_UP}  {$DEFINE COMPILER8_UP}  {$ENDIF}
{$IFDEF COMPILER8_UP}  {$DEFINE COMPILER7_UP}  {$ENDIF}
{$IFDEF COMPILER7_UP}  {$DEFINE COMPILER6_UP}  {$ENDIF}
{$IFDEF COMPILER6_UP}  {$DEFINE COMPILER5_UP}  {$ENDIF}
{$IFDEF COMPILER5_UP}  {$DEFINE COMPILER4_UP}  {$ENDIF}
{$IFDEF COMPILER4_UP}  {$DEFINE COMPILER35_UP} {$ENDIF}
{$IFDEF COMPILER35_UP} {$DEFINE COMPILER3_UP}  {$ENDIF}
{$IFDEF COMPILER3_UP}  {$DEFINE COMPILER2_UP}  {$ENDIF}
{$IFDEF COMPILER2_UP}  {$DEFINE COMPILER1_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ RTLX_UP from RTLX_UP mappings                                                }
{------------------------------------------------------------------------------}

{$IFDEF RTL300_UP} {$DEFINE RTL290_UP} {$ENDIF}
{$IFDEF RTL290_UP} {$DEFINE RTL280_UP} {$ENDIF}
{$IFDEF RTL280_UP} {$DEFINE RTL270_UP} {$ENDIF}
{$IFDEF RTL270_UP} {$DEFINE RTL260_UP} {$ENDIF}
{$IFDEF RTL260_UP} {$DEFINE RTL250_UP} {$ENDIF}
{$IFDEF RTL250_UP} {$DEFINE RTL240_UP} {$ENDIF}
{$IFDEF RTL240_UP} {$DEFINE RTL230_UP} {$ENDIF}
{$IFDEF RTL230_UP} {$DEFINE RTL220_UP} {$ENDIF}
{$IFDEF RTL220_UP} {$DEFINE RTL210_UP} {$ENDIF}
{$IFDEF RTL210_UP} {$DEFINE RTL200_UP} {$ENDIF}
{$IFDEF RTL200_UP} {$DEFINE RTL190_UP} {$ENDIF}
{$IFDEF RTL190_UP} {$DEFINE RTL185_UP} {$ENDIF}
{$IFDEF RTL185_UP} {$DEFINE RTL180_UP} {$ENDIF}
{$IFDEF RTL180_UP} {$DEFINE RTL170_UP} {$ENDIF}
{$IFDEF RTL170_UP} {$DEFINE RTL160_UP} {$ENDIF}
{$IFDEF RTL160_UP} {$DEFINE RTL150_UP} {$ENDIF}
{$IFDEF RTL150_UP} {$DEFINE RTL145_UP} {$ENDIF}
{$IFDEF RTL145_UP} {$DEFINE RTL142_UP} {$ENDIF}
{$IFDEF RTL142_UP} {$DEFINE RTL140_UP} {$ENDIF}
{$IFDEF RTL140_UP} {$DEFINE RTL130_UP} {$ENDIF}
{$IFDEF RTL130_UP} {$DEFINE RTL125_UP} {$ENDIF}
{$IFDEF RTL125_UP} {$DEFINE RTL120_UP} {$ENDIF}
{$IFDEF RTL120_UP} {$DEFINE RTL110_UP} {$ENDIF}
{$IFDEF RTL110_UP} {$DEFINE RTL100_UP} {$ENDIF}
{$IFDEF RTL100_UP} {$DEFINE RTL93_UP}  {$ENDIF}
{$IFDEF RTL93_UP}  {$DEFINE RTL90_UP}  {$ENDIF}
{$IFDEF RTL90_UP}  {$DEFINE RTL80_UP}  {$ENDIF}

{------------------------------------------------------------------------------}
{ Check for CLR overrides of default detection                                 }
{------------------------------------------------------------------------------}

{$IFDEF CLR}
  {$IFDEF FORCE_CLR10}
    {$DEFINE CLR10}
    {$UNDEF CLR11}
    {$UNDEF CLR20}
  {$ENDIF FORCE_CLR10}

  {$IFDEF FORCE_CLR11}
    {$UNDEF CLR10}
    {$DEFINE CLR11}
    {$UNDEF CLR20}
  {$ENDIF FORCE_CLR11}

  {$IFDEF FORCE_CLR20}
    {$UNDEF CLR10}
    {$UNDEF CLR11}
    {$DEFINE CLR20}
  {$ENDIF FORCE_CLR20}
{$ENDIF CLR}

{------------------------------------------------------------------------------}
{ CLRX from CLRX_UP mappings                                                   }
{------------------------------------------------------------------------------}

{$IFDEF CLR10} {$DEFINE CLR10_UP} {$ENDIF}
{$IFDEF CLR11} {$DEFINE CLR11_UP} {$ENDIF}
{$IFDEF CLR20} {$DEFINE CLR20_UP} {$ENDIF}

{------------------------------------------------------------------------------}
{ CLRX_UP from CLRX_UP mappings                                                }
{------------------------------------------------------------------------------}

{$IFDEF CLR20_UP} {$DEFINE CLR11_UP} {$ENDIF}
{$IFDEF CLR11_UP} {$DEFINE CLR10_UP} {$ENDIF}

{------------------------------------------------------------------------------}

{$IFDEF DELPHICOMPILER}
  {$DEFINE DELPHILANGUAGE}
{$ENDIF}

{$IFDEF BCBCOMPILER}
  {$DEFINE DELPHILANGUAGE}
{$ENDIF}

{------------------------------------------------------------------------------}
{ KYLIXX_UP from KYLIXX mappings                                               }
{------------------------------------------------------------------------------}

{$IFDEF KYLIX3} {$DEFINE KYLIX3_UP} {$ENDIF}
{$IFDEF KYLIX2} {$DEFINE KYLIX2_UP} {$ENDIF}
{$IFDEF KYLIX1} {$DEFINE KYLIX1_UP} {$ENDIF}

{------------------------------------------------------------------------------}
{ KYLIXX_UP from KYLIXX_UP mappings                                            }
{------------------------------------------------------------------------------}

{$IFDEF KYLIX3_UP} {$DEFINE KYLIX2_UP} {$ENDIF}
{$IFDEF KYLIX2_UP} {$DEFINE KYLIX1_UP} {$ENDIF}

{------------------------------------------------------------------------------}
{ Map COMPILERX_UP to friendly feature names                                   }
{------------------------------------------------------------------------------}

{$IFDEF FPC}
  {$IFDEF  VER1_0}
     Please use FPC 2.0 or higher to compile this.
  {$ELSE}
    {$DEFINE SUPPORTS_OUTPARAMS}
    {$DEFINE SUPPORTS_WIDECHAR}
    {$DEFINE SUPPORTS_WIDESTRING}
    {$IFDEF HASINTF}
      {$DEFINE SUPPORTS_INTERFACE}
    {$ENDIF}
    {$IFDEF HASVARIANT}
      {$DEFINE SUPPORTS_VARIANT}
    {$ENDIF}
    {$IFDEF FPC_HAS_TYPE_SINGLE}
      {$DEFINE SUPPORTS_SINGLE}
    {$ENDIF}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
      {$DEFINE SUPPORTS_DOUBLE}
    {$ENDIF}
    {$IFDEF FPC_HAS_TYPE_EXTENDED}
      {$DEFINE SUPPORTS_EXTENDED}
    {$ENDIF}
    {$IFDEF HASCURRENCY}
      {$DEFINE SUPPORTS_CURRENCY}
    {$ENDIF}
    {$DEFINE SUPPORTS_THREADVAR}
    {$DEFINE SUPPORTS_CONSTPARAMS}
    {$DEFINE SUPPORTS_LONGWORD}
    {$DEFINE SUPPORTS_INT64}
    {$DEFINE SUPPORTS_DYNAMICARRAYS}
    {$DEFINE SUPPORTS_DEFAULTPARAMS}
    {$DEFINE SUPPORTS_OVERLOAD}
    {$DEFINE ACCEPT_DEPRECATED}  // 2.2 also gives warnings
    {$DEFINE ACCEPT_PLATFORM}    // 2.2 also gives warnings
    {$DEFINE ACCEPT_LIBRARY}
    {$DEFINE SUPPORTS_EXTSYM}
    {$DEFINE SUPPORTS_NODEFINE}

    {$DEFINE SUPPORTS_CUSTOMVARIANTS}
    {$DEFINE SUPPORTS_VARARGS}
    {$DEFINE SUPPORTS_ENUMVALUE}
    {$IFDEF LINUX}
      {$DEFINE HAS_UNIT_LIBC}
    {$ENDIF LINUX}
    {$DEFINE HAS_UNIT_CONTNRS}
    {$DEFINE HAS_UNIT_TYPES}
    {$DEFINE HAS_UNIT_VARIANTS}
    {$DEFINE HAS_UNIT_STRUTILS}
    {$DEFINE HAS_UNIT_DATEUTILS}
    {$DEFINE HAS_UNIT_RTLCONSTS}

    {$DEFINE XPLATFORM_RTL}

    {$IFDEF VER2_2}
      {$DEFINE SUPPORTS_DISPINTERFACE}
      {$DEFINE SUPPORTS_IMPLEMENTS}
      {$DEFINE SUPPORTS_DISPID}
    {$ELSE}
      {$UNDEF SUPPORTS_DISPINTERFACE}
      {$UNDEF SUPPORTS_IMPLEMENTS}
    {$endif}
    {$UNDEF SUPPORTS_UNSAFE_WARNINGS}
  {$ENDIF}
{$ENDIF FPC}

{$IFDEF CLR}
  {$DEFINE SUPPORTS_UNICODE}
{$ENDIF CLR}

{$IFDEF COMPILER1_UP}
  {$DEFINE SUPPORTS_CONSTPARAMS}
  {$DEFINE SUPPORTS_SINGLE}
  {$DEFINE SUPPORTS_DOUBLE}
  {$DEFINE SUPPORTS_EXTENDED}
  {$DEFINE SUPPORTS_PACKAGES} 
{$ENDIF COMPILER1_UP}

{$IFDEF COMPILER2_UP}
  {$DEFINE SUPPORTS_CURRENCY}
  {$DEFINE SUPPORTS_THREADVAR}
  {$DEFINE SUPPORTS_VARIANT}
  {$DEFINE SUPPORTS_WIDECHAR}
{$ENDIF COMPILER2_UP}

{$IFDEF COMPILER3_UP}
  {$DEFINE SUPPORTS_OUTPARAMS}
  {$DEFINE SUPPORTS_WIDESTRING}
  {$DEFINE SUPPORTS_INTERFACE}
  {$DEFINE SUPPORTS_DISPINTERFACE}
  {$DEFINE SUPPORTS_DISPID}
  {$DEFINE SUPPORTS_WEAKPACKAGEUNIT}
{$ENDIF COMPILER3_UP}

{$IFDEF COMPILER35_UP}
  {$DEFINE SUPPORTS_EXTSYM}
  {$DEFINE SUPPORTS_NODEFINE}
{$ENDIF COMPILER35_UP}

{$IFDEF COMPILER4_UP}
  {$DEFINE SUPPORTS_LONGWORD}
  {$DEFINE SUPPORTS_INT64}
  {$DEFINE SUPPORTS_DYNAMICARRAYS}
  {$DEFINE SUPPORTS_DEFAULTPARAMS}
  {$DEFINE SUPPORTS_OVERLOAD}
  {$DEFINE SUPPORTS_IMPLEMENTS}
{$ENDIF COMPILER4_UP}

{$IFDEF COMPILER6_UP}
  {$DEFINE SUPPORTS_DEPRECATED}
  {$DEFINE SUPPORTS_LIBRARY}
  {$DEFINE SUPPORTS_PLATFORM}
  {$DEFINE SUPPORTS_LOCAL}
  {$DEFINE SUPPORTS_SETPEFLAGS}
  {$DEFINE SUPPORTS_EXPERIMENTAL_WARNINGS}
  {$DEFINE ACCEPT_DEPRECATED}
  {$DEFINE ACCEPT_PLATFORM}
  {$DEFINE ACCEPT_LIBRARY}
  {$DEFINE SUPPORTS_DEPRECATED_WARNINGS}
  {$DEFINE SUPPORTS_LIBRARY_WARNINGS}
  {$DEFINE SUPPORTS_PLATFORM_WARNINGS}
  {$DEFINE SUPPORTS_CUSTOMVARIANTS}
  {$DEFINE SUPPORTS_VARARGS}
  {$DEFINE SUPPORTS_ENUMVALUE}
  {$DEFINE SUPPORTS_COMPILETIME_MESSAGES}
{$ENDIF COMPILER6_UP}

{$IFDEF COMPILER7_UP}
  {$DEFINE SUPPORTS_UNSAFE_WARNINGS}
  {$DEFINE SUPPORTS_UINT64}
{$ENDIF COMPILER7_UP}

{$IFDEF COMPILER9_UP}
  {$DEFINE SUPPORTS_FOR_IN}
  {$DEFINE SUPPORTS_INLINE}
  {$DEFINE SUPPORTS_NESTED_CONSTANTS}
  {$DEFINE SUPPORTS_NESTED_TYPES}
  {$DEFINE SUPPORTS_REGION}
  {$IFDEF CLR}
    {$DEFINE SUPPORTS_ENHANCED_RECORDS}
    {$DEFINE SUPPORTS_CLASS_FIELDS}
    {$DEFINE SUPPORTS_CLASS_HELPERS}
    {$DEFINE SUPPORTS_CLASS_OPERATORS}
    {$DEFINE SUPPORTS_STRICT}
    {$DEFINE SUPPORTS_STATIC}
    {$DEFINE SUPPORTS_FINAL}
  {$ENDIF CLR}
{$ENDIF COMPILER9_UP}

{$IFDEF COMPILER10_UP}
  {$DEFINE SUPPORTS_ENHANCED_RECORDS}
  {$DEFINE SUPPORTS_CLASS_FIELDS}
  {$DEFINE SUPPORTS_CLASS_HELPERS}
  {$DEFINE SUPPORTS_CLASS_OPERATORS}
  {$DEFINE SUPPORTS_STRICT}
  {$DEFINE SUPPORTS_STATIC}
  {$DEFINE SUPPORTS_FINAL}
  {$DEFINE SUPPORTS_METHODINFO}
{$ENDIF COMPILER10_UP}

{$IFDEF COMPILER11_UP}
  {$IFDEF CLR}
    {$DEFINE SUPPORTS_GENERICS}
    {$DEFINE SUPPORTS_DEPRECATED_DETAILS}
  {$ENDIF CLR}
{$ENDIF COMPILER11_UP}

{$IFDEF COMPILER12_UP}
  {$DEFINE SUPPORTS_GENERICS}
  {$DEFINE SUPPORTS_DEPRECATED_DETAILS}
  {$DEFINE SUPPORTS_INT_ALIASES}
  {$IFNDEF CLR}
    {$DEFINE SUPPORTS_UNICODE}
    {$DEFINE SUPPORTS_UNICODE_STRING}
  {$ENDIF  CLR}
{$ENDIF COMPILER12_UP}

{$IFDEF COMPILER14_UP}
  {$DEFINE SUPPORTS_CLASS_CTORDTORS}
  {$DEFINE HAS_UNIT_RTTI}
  {$DEFINE SUPPORTS_CAST_INTERFACE_TO_OBJ}
  {$DEFINE SUPPORTS_DELAYED_LOADING}
{$ENDIF COMPILER14_UP}

{$IFDEF COMPILER16_UP}
  {$DEFINE USE_64BIT_TYPES}
{$ENDIF COMPILER16_UP}

{$IFDEF RTL130_UP}
  {$DEFINE HAS_UNIT_CONTNRS}
{$ENDIF RTL130_UP}

{$IFDEF RTL140_UP}
  {$IFDEF LINUX}
    {$DEFINE HAS_UNIT_LIBC}
  {$ENDIF LINUX}
  {$DEFINE HAS_UNIT_RTLCONSTS}
  {$DEFINE HAS_UNIT_TYPES}
  {$DEFINE HAS_UNIT_VARIANTS}
  {$DEFINE HAS_UNIT_STRUTILS}
  {$DEFINE HAS_UNIT_DATEUTILS}
  {$DEFINE XPLATFORM_RTL}
{$ENDIF RTL140_UP}

{$IFDEF RTL150_UP}
  {$DEFINE HAS_UNIT_UXTHEME}
{$ENDIF RTL150_UP}

{$IFDEF RTL170_UP}
  {$DEFINE HAS_UNIT_HTTPPROD}
{$ENDIF RTL170_UP}

{$IFDEF RTL185_UP}
  {$DEFINE HAS_UNIT_GIFIMG}
{$ENDIF RTL185_UP}

{$IFDEF RTL200_UP}
  {$DEFINE HAS_UNIT_ANSISTRINGS}
  {$DEFINE HAS_UNIT_PNGIMAGE}
  {$DEFINE HAS_UNIT_CHARACTER}
  {$DEFINE HAS_EXCEPTION_STACKTRACE}
{$ENDIF RTL200_UP}

{$IFDEF RTL210_UP}
  {$DEFINE HAS_EARGUMENTEXCEPTION}
{$ENDIF RTL210_UP} 

{$IFDEF RTL220_UP}
  {$DEFINE HAS_UNIT_REGULAREXPRESSIONSAPI}
  {$DEFINE HAS_ENOTIMPLEMENTED}
{$ENDIF RTL220_UP}

{$IFDEF RTL230_UP}
  {$DEFINE HAS_UNITSCOPE}
  {$DEFINE HAS_UNIT_SYSTEM_UITYPES}
  {$DEFINE HAS_UNIT_VCL_THEMES}
{$ENDIF RTL230_UP}

{$IFDEF RTL240_UP}
  {$DEFINE HAS_UNIT_SYSTEM_ACTIONS}
  {$DEFINE HAS_PROPERTY_STYLEELEMENTS}
{$ENDIF RTL240_UP}

{$IFDEF RTL250_UP}
  {$DEFINE DEPRECATED_SYSUTILS_ANSISTRINGS}
{$ENDIF RTL250_UP}

{$IFDEF RTL270_UP}
  {$DEFINE HAS_AUTOMATIC_DB_FIELDS}
{$ENDIF RTL270_UP}

{------------------------------------------------------------------------------}
{ Cross-platform related defines                                               }
{------------------------------------------------------------------------------}

{$IFNDEF CPUASM}
  {$DEFINE PUREPASCAL}
{$ENDIF ~CPUASM}

{$IFDEF WIN32}
  {$DEFINE MSWINDOWS} // predefined for D6+/BCB6+
  {$DEFINE Win32API}
{$ENDIF}

{$IFDEF DELPHILANGUAGE}
  {$IFDEF LINUX}
    {$DEFINE UNIX}
  {$ENDIF}

{$ENDIF DELPHILANGUAGE}

{------------------------------------------------------------------------------}
{ Compiler settings                                                            }
{------------------------------------------------------------------------------}

{$IFOPT A+} {$DEFINE ALIGN_ON} {$ENDIF}
{$IFOPT B+} {$DEFINE BOOLEVAL_ON} {$ENDIF}
{$IFDEF COMPILER2_UP}
  {$IFOPT C+} {$DEFINE ASSERTIONS_ON} {$ENDIF}
{$ENDIF}
{$IFOPT D+} {$DEFINE DEBUGINFO_ON} {$ENDIF}
{$IFOPT G+} {$DEFINE IMPORTEDDATA_ON} {$ENDIF}
{$IFDEF COMPILER2_UP}
  {$IFOPT H+} {$DEFINE LONGSTRINGS_ON} {$ENDIF}
{$ENDIF}

// Hints
{$IFOPT I+} {$DEFINE IOCHECKS_ON} {$ENDIF}
{$IFDEF COMPILER2_UP}
  {$IFOPT J+} {$DEFINE WRITEABLECONST_ON} {$ENDIF}
{$ENDIF}
{$IFOPT L+} {$DEFINE LOCALSYMBOLS} {$DEFINE LOCALSYMBOLS_ON} {$ENDIF}
{$IFOPT M+} {$DEFINE TYPEINFO_ON} {$ENDIF}
{$IFOPT O+} {$DEFINE OPTIMIZATION_ON} {$ENDIF}
{$IFOPT P+} {$DEFINE OPENSTRINGS_ON} {$ENDIF}
{$IFOPT Q+} {$DEFINE OVERFLOWCHECKS_ON} {$ENDIF}
{$IFOPT R+} {$DEFINE RANGECHECKS_ON} {$ENDIF}

// Real compatibility
{$IFOPT T+} {$DEFINE TYPEDADDRESS_ON} {$ENDIF}
{$IFOPT U+} {$DEFINE SAFEDIVIDE_ON} {$ENDIF}
{$IFOPT V+} {$DEFINE VARSTRINGCHECKS_ON} {$ENDIF}
{$IFOPT W+} {$DEFINE STACKFRAMES_ON} {$ENDIF}

// Warnings
{$IFOPT X+} {$DEFINE EXTENDEDSYNTAX_ON} {$ENDIF}

// for Delphi/BCB trial versions remove the point from the line below
{.$UNDEF SUPPORTS_WEAKPACKAGEUNIT}

{$ENDIF ~JEDI_INC}


{$IFDEF MSWINDOWS}
  {$DEFINE WINDOWS}
{$ENDIF}

{$IFDEF FPC}
  {$DEFINE HAS_TYPES}
{$ENDIF}

interface

uses
{$IFDEF HAS_TYPES}
  Types,
{$ENDIF}

{$IFDEF WINDOWS}
  Windows;
{$ENDIF}

{$IFDEF UNIX}
  {$IFDEF FPC}
  {$IFNDEF SKYOS}
  pthreads,
  {$ENDIF}
  baseunix,
  {$IFNDEF GP2X}
  {$IFNDEF DARWIN}
  {$IFNDEF SKYOS}
  unix,
  {$ELSE}
  unix;
  {$ENDIF}
  {$ELSE}
  unix;
  {$ENDIF}
  {$ELSE}
  unix;
  {$ENDIF}
  {$IFNDEF GP2X}
  {$IFNDEF DARWIN}
  {$IFNDEF SKYOS}
  x,
  xlib;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ELSE}
  Libc,
  Xlib;
  {$ENDIF}
{$ENDIF}

const
{$IFDEF WINDOWS}
  {$IF Defined (CPUX86_64) or Defined(CPUX64)}
    SDLLibName = 'SDL64.dll';
  {$ELSE}
    SDLLibName = 'SDL.dll';
  {$IFEND}
{$ENDIF}

{$IFDEF UNIX}
{$IFDEF DARWIN}
  SDLLibName = 'libSDL-1.2.0.dylib';
{$ELSE}
  {$IFDEF FPC}
  SDLLibName = 'libSDL.so';
  {$ELSE}
  SDLLibName = 'libSDL-1.2.so.0';
  {$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFDEF MACOS}
  SDLLibName = 'SDL';
  {$linklib libSDL}
{$ENDIF}

  // SDL_verion.h constants
  // Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL
  SDL_MAJOR_VERSION = 1;
{$EXTERNALSYM SDL_MAJOR_VERSION}
  SDL_MINOR_VERSION = 2;
{$EXTERNALSYM SDL_MINOR_VERSION}
  SDL_PATCHLEVEL    = 13;
{$EXTERNALSYM SDL_PATCHLEVEL}

  // SDL.h constants
  SDL_INIT_TIMER = $00000001;
{$EXTERNALSYM SDL_INIT_TIMER}
  SDL_INIT_AUDIO = $00000010;
{$EXTERNALSYM SDL_INIT_AUDIO}
  SDL_INIT_VIDEO = $00000020;
{$EXTERNALSYM SDL_INIT_VIDEO}
  SDL_INIT_CDROM = $00000100;
{$EXTERNALSYM SDL_INIT_CDROM}
  SDL_INIT_JOYSTICK = $00000200;
{$EXTERNALSYM SDL_INIT_JOYSTICK}
  SDL_INIT_NOPARACHUTE = $00100000; // Don't catch fatal signals
{$EXTERNALSYM SDL_INIT_NOPARACHUTE}
  SDL_INIT_EVENTTHREAD = $01000000; // Not supported on all OS's
{$EXTERNALSYM SDL_INIT_EVENTTHREAD}
  SDL_INIT_EVERYTHING = $0000FFFF;
{$EXTERNALSYM SDL_INIT_EVERYTHING}

  // SDL_error.h constants
  ERR_MAX_STRLEN = 128;
{$EXTERNALSYM ERR_MAX_STRLEN}
  ERR_MAX_ARGS = 5;
{$EXTERNALSYM ERR_MAX_ARGS}

  // SDL_types.h constants
  SDL_PRESSED = $01;
{$EXTERNALSYM SDL_PRESSED}
  SDL_RELEASED = $00;
{$EXTERNALSYM SDL_RELEASED}

  // SDL_timer.h constants
  // This is the OS scheduler timeslice, in milliseconds
  SDL_TIMESLICE = 10;
{$EXTERNALSYM SDL_TIMESLICE}
  // This is the maximum resolution of the SDL timer on all platforms
  TIMER_RESOLUTION = 10; // Experimentally determined
{$EXTERNALSYM TIMER_RESOLUTION}

  // SDL_audio.h constants
  AUDIO_U8 = $0008; // Unsigned 8-bit samples
{$EXTERNALSYM AUDIO_U8}
  AUDIO_S8 = $8008; // Signed 8-bit samples
{$EXTERNALSYM AUDIO_S8}
  AUDIO_U16LSB = $0010; // Unsigned 16-bit samples
{$EXTERNALSYM AUDIO_U16LSB}
  AUDIO_S16LSB = $8010; // Signed 16-bit samples
{$EXTERNALSYM AUDIO_S16LSB}
  AUDIO_U16MSB = $1010; // As above, but big-endian byte order
{$EXTERNALSYM AUDIO_U16MSB}
  AUDIO_S16MSB = $9010; // As above, but big-endian byte order
{$EXTERNALSYM AUDIO_S16MSB}
  AUDIO_U16 = AUDIO_U16LSB;
{$EXTERNALSYM AUDIO_U16}
  AUDIO_S16 = AUDIO_S16LSB;
{$EXTERNALSYM AUDIO_S16}


  // SDL_cdrom.h constants
  // The maximum number of CD-ROM tracks on a disk
  SDL_MAX_TRACKS = 99;
{$EXTERNALSYM SDL_MAX_TRACKS}
  // The types of CD-ROM track possible
  SDL_AUDIO_TRACK = $00;
{$EXTERNALSYM SDL_AUDIO_TRACK}
  SDL_DATA_TRACK = $04;
{$EXTERNALSYM SDL_DATA_TRACK}

  // Conversion functions from frames to Minute/Second/Frames and vice versa
  CD_FPS = 75;
{$EXTERNALSYM CD_FPS}
  // SDL_byteorder.h constants
  // The two types of endianness
  SDL_LIL_ENDIAN = 1234;
{$EXTERNALSYM SDL_LIL_ENDIAN}
  SDL_BIG_ENDIAN = 4321;
{$EXTERNALSYM SDL_BIG_ENDIAN}

{$IFDEF IA32}

  SDL_BYTEORDER = SDL_LIL_ENDIAN;
{$EXTERNALSYM SDL_BYTEORDER}
  // Native audio byte ordering
  AUDIO_U16SYS = AUDIO_U16LSB;
{$EXTERNALSYM AUDIO_U16SYS}
  AUDIO_S16SYS = AUDIO_S16LSB;
{$EXTERNALSYM AUDIO_S16SYS}

{$ELSE}

  SDL_BYTEORDER = SDL_BIG_ENDIAN;
{$EXTERNALSYM SDL_BYTEORDER}
  // Native audio byte ordering
  AUDIO_U16SYS = AUDIO_U16MSB;
{$EXTERNALSYM AUDIO_U16SYS}
  AUDIO_S16SYS = AUDIO_S16MSB;
{$EXTERNALSYM AUDIO_S16SYS}

{$ENDIF}


  SDL_MIX_MAXVOLUME = 128;
{$EXTERNALSYM SDL_MIX_MAXVOLUME}

  // SDL_joystick.h constants
  MAX_JOYSTICKS = 2; // only 2 are supported in the multimedia API
{$EXTERNALSYM MAX_JOYSTICKS}
  MAX_AXES = 6; // each joystick can have up to 6 axes
{$EXTERNALSYM MAX_AXES}
  MAX_BUTTONS = 32; // and 32 buttons
{$EXTERNALSYM MAX_BUTTONS}
  AXIS_MIN = -32768; // minimum value for axis coordinate
{$EXTERNALSYM AXIS_MIN}
  AXIS_MAX = 32767; // maximum value for axis coordinate
{$EXTERNALSYM AXIS_MAX}
  JOY_AXIS_THRESHOLD = (((AXIS_MAX) - (AXIS_MIN)) / 100); // 1% motion
{$EXTERNALSYM JOY_AXIS_THRESHOLD}
  //JOY_BUTTON_FLAG(n)        (1 shl n)
  // array to hold joystick ID values
  //SYS_JoystickID: array [0..MAX_JOYSTICKS] of UINT;
  //SYS_Joystick:array [0..MAX_JOYSTICKS] of Joycaps;

  { Get the current state of a POV hat on a joystick
    The return value is one of the following positions: }
  SDL_HAT_CENTERED = $00;
{$EXTERNALSYM SDL_HAT_CENTERED}
  SDL_HAT_UP = $01;
{$EXTERNALSYM SDL_HAT_UP}
  SDL_HAT_RIGHT = $02;
{$EXTERNALSYM SDL_HAT_RIGHT}
  SDL_HAT_DOWN = $04;
{$EXTERNALSYM SDL_HAT_DOWN}
  SDL_HAT_LEFT = $08;
{$EXTERNALSYM SDL_HAT_LEFT}
  SDL_HAT_RIGHTUP = SDL_HAT_RIGHT or SDL_HAT_UP;
{$EXTERNALSYM SDL_HAT_RIGHTUP}
  SDL_HAT_RIGHTDOWN = SDL_HAT_RIGHT or SDL_HAT_DOWN;
{$EXTERNALSYM SDL_HAT_RIGHTDOWN}
  SDL_HAT_LEFTUP = SDL_HAT_LEFT or SDL_HAT_UP;
{$EXTERNALSYM SDL_HAT_LEFTUP}
  SDL_HAT_LEFTDOWN = SDL_HAT_LEFT or SDL_HAT_DOWN;
{$EXTERNALSYM SDL_HAT_LEFTDOWN}

  // SDL_events.h constants
  SDL_NOEVENT = 0; // Unused (do not remove)
{$EXTERNALSYM SDL_NOEVENT}
  SDL_ACTIVEEVENT = 1; // Application loses/gains visibility
{$EXTERNALSYM SDL_ACTIVEEVENT}
  SDL_KEYDOWN = 2; // Keys pressed
{$EXTERNALSYM SDL_KEYDOWN}
  SDL_KEYUP = 3; // Keys released
{$EXTERNALSYM SDL_KEYUP}
  SDL_MOUSEMOTION = 4; // Mouse moved
{$EXTERNALSYM SDL_MOUSEMOTION}
  SDL_MOUSEBUTTONDOWN = 5; // Mouse button pressed
{$EXTERNALSYM SDL_MOUSEBUTTONDOWN}
  SDL_MOUSEBUTTONUP = 6; // Mouse button released
{$EXTERNALSYM SDL_MOUSEBUTTONUP}
  SDL_JOYAXISMOTION = 7; // Joystick axis motion
{$EXTERNALSYM SDL_JOYAXISMOTION}
  SDL_JOYBALLMOTION = 8; // Joystick trackball motion
{$EXTERNALSYM SDL_JOYBALLMOTION}
  SDL_JOYHATMOTION = 9; // Joystick hat position change
{$EXTERNALSYM SDL_JOYHATMOTION}
  SDL_JOYBUTTONDOWN = 10; // Joystick button pressed
{$EXTERNALSYM SDL_JOYBUTTONDOWN}
  SDL_JOYBUTTONUP = 11; // Joystick button released
{$EXTERNALSYM SDL_JOYBUTTONUP}
  SDL_QUITEV = 12; // User-requested quit ( Changed due to procedure conflict )
{$EXTERNALSYM SDL_QUIT}
  SDL_SYSWMEVENT = 13; // System specific event
{$EXTERNALSYM SDL_SYSWMEVENT}
  SDL_EVENT_RESERVEDA = 14; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVEDA}
  SDL_EVENT_RESERVED = 15; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVED}
  SDL_VIDEORESIZE = 16; // User resized video mode
{$EXTERNALSYM SDL_VIDEORESIZE}
  SDL_VIDEOEXPOSE = 17; // Screen needs to be redrawn
{$EXTERNALSYM SDL_VIDEOEXPOSE}
  SDL_EVENT_RESERVED2 = 18; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVED2}
  SDL_EVENT_RESERVED3 = 19; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVED3}
  SDL_EVENT_RESERVED4 = 20; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVED4}
  SDL_EVENT_RESERVED5 = 21; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVED5}
  SDL_EVENT_RESERVED6 = 22; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVED6}
  SDL_EVENT_RESERVED7 = 23; // Reserved for future use..
{$EXTERNALSYM SDL_EVENT_RESERVED7}
  // Events SDL_USEREVENT through SDL_MAXEVENTS-1 are for your use
  SDL_USEREVENT = 24;
{$EXTERNALSYM SDL_USEREVENT}
  // This last event is only for bounding internal arrays
  // It is the number of bits in the event mask datatype -- UInt32
  SDL_NUMEVENTS = 32;
{$EXTERNALSYM SDL_NUMEVENTS}

  SDL_ALLEVENTS = $FFFFFFFF;
{$EXTERNALSYM SDL_ALLEVENTS}

  SDL_ACTIVEEVENTMASK = 1 shl SDL_ACTIVEEVENT;
{$EXTERNALSYM SDL_ACTIVEEVENTMASK}
  SDL_KEYDOWNMASK = 1 shl SDL_KEYDOWN;
{$EXTERNALSYM SDL_KEYDOWNMASK}
  SDL_KEYUPMASK = 1 shl SDL_KEYUP;
{$EXTERNALSYM SDL_KEYUPMASK}
  SDL_MOUSEMOTIONMASK = 1 shl SDL_MOUSEMOTION;
{$EXTERNALSYM SDL_MOUSEMOTIONMASK}
  SDL_MOUSEBUTTONDOWNMASK = 1 shl SDL_MOUSEBUTTONDOWN;
{$EXTERNALSYM SDL_MOUSEBUTTONDOWNMASK}
  SDL_MOUSEBUTTONUPMASK = 1 shl SDL_MOUSEBUTTONUP;
{$EXTERNALSYM SDL_MOUSEBUTTONUPMASK}
  SDL_MOUSEEVENTMASK = 1 shl SDL_MOUSEMOTION or
    1 shl SDL_MOUSEBUTTONDOWN or
    1 shl SDL_MOUSEBUTTONUP;
{$EXTERNALSYM SDL_MOUSEEVENTMASK}
  SDL_JOYAXISMOTIONMASK = 1 shl SDL_JOYAXISMOTION;
{$EXTERNALSYM SDL_JOYAXISMOTIONMASK}
  SDL_JOYBALLMOTIONMASK = 1 shl SDL_JOYBALLMOTION;
{$EXTERNALSYM SDL_JOYBALLMOTIONMASK}
  SDL_JOYHATMOTIONMASK = 1 shl SDL_JOYHATMOTION;
{$EXTERNALSYM SDL_JOYHATMOTIONMASK}
  SDL_JOYBUTTONDOWNMASK = 1 shl SDL_JOYBUTTONDOWN;
{$EXTERNALSYM SDL_JOYBUTTONDOWNMASK}
  SDL_JOYBUTTONUPMASK = 1 shl SDL_JOYBUTTONUP;
{$EXTERNALSYM SDL_JOYBUTTONUPMASK}
  SDL_JOYEVENTMASK = 1 shl SDL_JOYAXISMOTION or
    1 shl SDL_JOYBALLMOTION or
    1 shl SDL_JOYHATMOTION or
    1 shl SDL_JOYBUTTONDOWN or
    1 shl SDL_JOYBUTTONUP;
{$EXTERNALSYM SDL_JOYEVENTMASK}
  SDL_VIDEORESIZEMASK = 1 shl SDL_VIDEORESIZE;
{$EXTERNALSYM SDL_VIDEORESIZEMASK}
  SDL_QUITMASK = 1 shl SDL_QUITEV;
{$EXTERNALSYM SDL_QUITMASK}
  SDL_SYSWMEVENTMASK = 1 shl SDL_SYSWMEVENT;
{$EXTERNALSYM SDL_SYSWMEVENTMASK}

  { This function allows you to set the state of processing certain events.
    If 'state' is set to SDL_IGNORE, that event will be automatically dropped
    from the event queue and will not event be filtered.
    If 'state' is set to SDL_ENABLE, that event will be processed normally.
    If 'state' is set to SDL_QUERY, SDL_EventState() will return the
    current processing state of the specified event. }

  SDL_QUERY = -1;
{$EXTERNALSYM SDL_QUERY}
  SDL_IGNORE = 0;
{$EXTERNALSYM SDL_IGNORE}
  SDL_DISABLE = 0;
{$EXTERNALSYM SDL_DISABLE}
  SDL_ENABLE = 1;
{$EXTERNALSYM SDL_ENABLE}

  //SDL_keyboard.h constants
  // This is the mask which refers to all hotkey bindings
  SDL_ALL_HOTKEYS = $FFFFFFFF;
{$EXTERNALSYM SDL_ALL_HOTKEYS}

{ Enable/Disable keyboard repeat.  Keyboard repeat defaults to off.
  'delay' is the initial delay in ms between the time when a key is
  pressed, and keyboard repeat begins.
  'interval' is the time in ms between keyboard repeat events. }

  SDL_DEFAULT_REPEAT_DELAY = 500;
{$EXTERNALSYM SDL_DEFAULT_REPEAT_DELAY}
  SDL_DEFAULT_REPEAT_INTERVAL = 30;
{$EXTERNALSYM SDL_DEFAULT_REPEAT_INTERVAL}

  // The keyboard syms have been cleverly chosen to map to ASCII
  SDLK_UNKNOWN = 0;
{$EXTERNALSYM SDLK_UNKNOWN}
  SDLK_FIRST = 0;
{$EXTERNALSYM SDLK_FIRST}
  SDLK_BACKSPACE = 8;
{$EXTERNALSYM SDLK_BACKSPACE}
  SDLK_TAB = 9;
{$EXTERNALSYM SDLK_TAB}
  SDLK_CLEAR = 12;
{$EXTERNALSYM SDLK_CLEAR}
  SDLK_RETURN = 13;
{$EXTERNALSYM SDLK_RETURN}
  SDLK_PAUSE = 19;
{$EXTERNALSYM SDLK_PAUSE}
  SDLK_ESCAPE = 27;
{$EXTERNALSYM SDLK_ESCAPE}
  SDLK_SPACE = 32;
{$EXTERNALSYM SDLK_SPACE}
  SDLK_EXCLAIM = 33;
{$EXTERNALSYM SDLK_EXCLAIM}
  SDLK_QUOTEDBL = 34;
{$EXTERNALSYM SDLK_QUOTEDBL}
  SDLK_HASH = 35;
{$EXTERNALSYM SDLK_HASH}
  SDLK_DOLLAR = 36;
{$EXTERNALSYM SDLK_DOLLAR}
  SDLK_AMPERSAND = 38;
{$EXTERNALSYM SDLK_AMPERSAND}
  SDLK_QUOTE = 39;
{$EXTERNALSYM SDLK_QUOTE}
  SDLK_LEFTPAREN = 40;
{$EXTERNALSYM SDLK_LEFTPAREN}
  SDLK_RIGHTPAREN = 41;
{$EXTERNALSYM SDLK_RIGHTPAREN}
  SDLK_ASTERISK = 42;
{$EXTERNALSYM SDLK_ASTERISK}
  SDLK_PLUS = 43;
{$EXTERNALSYM SDLK_PLUS}
  SDLK_COMMA = 44;
{$EXTERNALSYM SDLK_COMMA}
  SDLK_MINUS = 45;
{$EXTERNALSYM SDLK_MINUS}
  SDLK_PERIOD = 46;
{$EXTERNALSYM SDLK_PERIOD}
  SDLK_SLASH = 47;
{$EXTERNALSYM SDLK_SLASH}
  SDLK_0 = 48;
{$EXTERNALSYM SDLK_0}
  SDLK_1 = 49;
{$EXTERNALSYM SDLK_1}
  SDLK_2 = 50;
{$EXTERNALSYM SDLK_2}
  SDLK_3 = 51;
{$EXTERNALSYM SDLK_3}
  SDLK_4 = 52;
{$EXTERNALSYM SDLK_4}
  SDLK_5 = 53;
{$EXTERNALSYM SDLK_5}
  SDLK_6 = 54;
{$EXTERNALSYM SDLK_6}
  SDLK_7 = 55;
{$EXTERNALSYM SDLK_7}
  SDLK_8 = 56;
{$EXTERNALSYM SDLK_8}
  SDLK_9 = 57;
{$EXTERNALSYM SDLK_9}
  SDLK_COLON = 58;
{$EXTERNALSYM SDLK_COLON}
  SDLK_SEMICOLON = 59;
{$EXTERNALSYM SDLK_SEMICOLON}
  SDLK_LESS = 60;
{$EXTERNALSYM SDLK_LESS}
  SDLK_EQUALS = 61;
{$EXTERNALSYM SDLK_EQUALS}
  SDLK_GREATER = 62;
{$EXTERNALSYM SDLK_GREATER}
  SDLK_QUESTION = 63;
{$EXTERNALSYM SDLK_QUESTION}
  SDLK_AT = 64;
{$EXTERNALSYM SDLK_AT}

  { Skip uppercase letters }

  SDLK_LEFTBRACKET = 91;
{$EXTERNALSYM SDLK_LEFTBRACKET}
  SDLK_BACKSLASH = 92;
{$EXTERNALSYM SDLK_BACKSLASH}
  SDLK_RIGHTBRACKET = 93;
{$EXTERNALSYM SDLK_RIGHTBRACKET}
  SDLK_CARET = 94;
{$EXTERNALSYM SDLK_CARET}
  SDLK_UNDERSCORE = 95;
{$EXTERNALSYM SDLK_UNDERSCORE}
  SDLK_BACKQUOTE = 96;
{$EXTERNALSYM SDLK_BACKQUOTE}
  SDLK_a = 97;
{$EXTERNALSYM SDLK_a}
  SDLK_b = 98;
{$EXTERNALSYM SDLK_b}
  SDLK_c = 99;
{$EXTERNALSYM SDLK_c}
  SDLK_d = 100;
{$EXTERNALSYM SDLK_d}
  SDLK_e = 101;
{$EXTERNALSYM SDLK_e}
  SDLK_f = 102;
{$EXTERNALSYM SDLK_f}
  SDLK_g = 103;
{$EXTERNALSYM SDLK_g}
  SDLK_h = 104;
{$EXTERNALSYM SDLK_h}
  SDLK_i = 105;
{$EXTERNALSYM SDLK_i}
  SDLK_j = 106;
{$EXTERNALSYM SDLK_j}
  SDLK_k = 107;
{$EXTERNALSYM SDLK_k}
  SDLK_l = 108;
{$EXTERNALSYM SDLK_l}
  SDLK_m = 109;
{$EXTERNALSYM SDLK_m}
  SDLK_n = 110;
{$EXTERNALSYM SDLK_n}
  SDLK_o = 111;
{$EXTERNALSYM SDLK_o}
  SDLK_p = 112;
{$EXTERNALSYM SDLK_p}
  SDLK_q = 113;
{$EXTERNALSYM SDLK_q}
  SDLK_r = 114;
{$EXTERNALSYM SDLK_r}
  SDLK_s = 115;
{$EXTERNALSYM SDLK_s}
  SDLK_t = 116;
{$EXTERNALSYM SDLK_t}
  SDLK_u = 117;
{$EXTERNALSYM SDLK_u}
  SDLK_v = 118;
{$EXTERNALSYM SDLK_v}
  SDLK_w = 119;
{$EXTERNALSYM SDLK_w}
  SDLK_x = 120;
{$EXTERNALSYM SDLK_x}
  SDLK_y = 121;
{$EXTERNALSYM SDLK_y}
  SDLK_z = 122;
{$EXTERNALSYM SDLK_z}
  SDLK_DELETE = 127;
{$EXTERNALSYM SDLK_DELETE}
  // End of ASCII mapped keysyms

  // International keyboard syms
  SDLK_WORLD_0 = 160; // 0xA0
{$EXTERNALSYM SDLK_WORLD_0}
  SDLK_WORLD_1 = 161;
{$EXTERNALSYM SDLK_WORLD_1}
  SDLK_WORLD_2 = 162;
{$EXTERNALSYM SDLK_WORLD_2}
  SDLK_WORLD_3 = 163;
{$EXTERNALSYM SDLK_WORLD_3}
  SDLK_WORLD_4 = 164;
{$EXTERNALSYM SDLK_WORLD_4}
  SDLK_WORLD_5 = 165;
{$EXTERNALSYM SDLK_WORLD_5}
  SDLK_WORLD_6 = 166;
{$EXTERNALSYM SDLK_WORLD_6}
  SDLK_WORLD_7 = 167;
{$EXTERNALSYM SDLK_WORLD_7}
  SDLK_WORLD_8 = 168;
{$EXTERNALSYM SDLK_WORLD_8}
  SDLK_WORLD_9 = 169;
{$EXTERNALSYM SDLK_WORLD_9}
  SDLK_WORLD_10 = 170;
{$EXTERNALSYM SDLK_WORLD_10}
  SDLK_WORLD_11 = 171;
{$EXTERNALSYM SDLK_WORLD_11}
  SDLK_WORLD_12 = 172;
{$EXTERNALSYM SDLK_WORLD_12}
  SDLK_WORLD_13 = 173;
{$EXTERNALSYM SDLK_WORLD_13}
  SDLK_WORLD_14 = 174;
{$EXTERNALSYM SDLK_WORLD_14}
  SDLK_WORLD_15 = 175;
{$EXTERNALSYM SDLK_WORLD_15}
  SDLK_WORLD_16 = 176;
{$EXTERNALSYM SDLK_WORLD_16}
  SDLK_WORLD_17 = 177;
{$EXTERNALSYM SDLK_WORLD_17}
  SDLK_WORLD_18 = 178;
{$EXTERNALSYM SDLK_WORLD_18}
  SDLK_WORLD_19 = 179;
{$EXTERNALSYM SDLK_WORLD_19}
  SDLK_WORLD_20 = 180;
{$EXTERNALSYM SDLK_WORLD_20}
  SDLK_WORLD_21 = 181;
{$EXTERNALSYM SDLK_WORLD_21}
  SDLK_WORLD_22 = 182;
{$EXTERNALSYM SDLK_WORLD_22}
  SDLK_WORLD_23 = 183;
{$EXTERNALSYM SDLK_WORLD_23}
  SDLK_WORLD_24 = 184;
{$EXTERNALSYM SDLK_WORLD_24}
  SDLK_WORLD_25 = 185;
{$EXTERNALSYM SDLK_WORLD_25}
  SDLK_WORLD_26 = 186;
{$EXTERNALSYM SDLK_WORLD_26}
  SDLK_WORLD_27 = 187;
{$EXTERNALSYM SDLK_WORLD_27}
  SDLK_WORLD_28 = 188;
{$EXTERNALSYM SDLK_WORLD_28}
  SDLK_WORLD_29 = 189;
{$EXTERNALSYM SDLK_WORLD_29}
  SDLK_WORLD_30 = 190;
{$EXTERNALSYM SDLK_WORLD_30}
  SDLK_WORLD_31 = 191;
{$EXTERNALSYM SDLK_WORLD_31}
  SDLK_WORLD_32 = 192;
{$EXTERNALSYM SDLK_WORLD_32}
  SDLK_WORLD_33 = 193;
{$EXTERNALSYM SDLK_WORLD_33}
  SDLK_WORLD_34 = 194;
{$EXTERNALSYM SDLK_WORLD_34}
  SDLK_WORLD_35 = 195;
{$EXTERNALSYM SDLK_WORLD_35}
  SDLK_WORLD_36 = 196;
{$EXTERNALSYM SDLK_WORLD_36}
  SDLK_WORLD_37 = 197;
{$EXTERNALSYM SDLK_WORLD_37}
  SDLK_WORLD_38 = 198;
{$EXTERNALSYM SDLK_WORLD_38}
  SDLK_WORLD_39 = 199;
{$EXTERNALSYM SDLK_WORLD_39}
  SDLK_WORLD_40 = 200;
{$EXTERNALSYM SDLK_WORLD_40}
  SDLK_WORLD_41 = 201;
{$EXTERNALSYM SDLK_WORLD_41}
  SDLK_WORLD_42 = 202;
{$EXTERNALSYM SDLK_WORLD_42}
  SDLK_WORLD_43 = 203;
{$EXTERNALSYM SDLK_WORLD_43}
  SDLK_WORLD_44 = 204;
{$EXTERNALSYM SDLK_WORLD_44}
  SDLK_WORLD_45 = 205;
{$EXTERNALSYM SDLK_WORLD_45}
  SDLK_WORLD_46 = 206;
{$EXTERNALSYM SDLK_WORLD_46}
  SDLK_WORLD_47 = 207;
{$EXTERNALSYM SDLK_WORLD_47}
  SDLK_WORLD_48 = 208;
{$EXTERNALSYM SDLK_WORLD_48}
  SDLK_WORLD_49 = 209;
{$EXTERNALSYM SDLK_WORLD_49}
  SDLK_WORLD_50 = 210;
{$EXTERNALSYM SDLK_WORLD_50}
  SDLK_WORLD_51 = 211;
{$EXTERNALSYM SDLK_WORLD_51}
  SDLK_WORLD_52 = 212;
{$EXTERNALSYM SDLK_WORLD_52}
  SDLK_WORLD_53 = 213;
{$EXTERNALSYM SDLK_WORLD_53}
  SDLK_WORLD_54 = 214;
{$EXTERNALSYM SDLK_WORLD_54}
  SDLK_WORLD_55 = 215;
{$EXTERNALSYM SDLK_WORLD_55}
  SDLK_WORLD_56 = 216;
{$EXTERNALSYM SDLK_WORLD_56}
  SDLK_WORLD_57 = 217;
{$EXTERNALSYM SDLK_WORLD_57}
  SDLK_WORLD_58 = 218;
{$EXTERNALSYM SDLK_WORLD_58}
  SDLK_WORLD_59 = 219;
{$EXTERNALSYM SDLK_WORLD_59}
  SDLK_WORLD_60 = 220;
{$EXTERNALSYM SDLK_WORLD_60}
  SDLK_WORLD_61 = 221;
{$EXTERNALSYM SDLK_WORLD_61}
  SDLK_WORLD_62 = 222;
{$EXTERNALSYM SDLK_WORLD_62}
  SDLK_WORLD_63 = 223;
{$EXTERNALSYM SDLK_WORLD_63}
  SDLK_WORLD_64 = 224;
{$EXTERNALSYM SDLK_WORLD_64}
  SDLK_WORLD_65 = 225;
{$EXTERNALSYM SDLK_WORLD_65}
  SDLK_WORLD_66 = 226;
{$EXTERNALSYM SDLK_WORLD_66}
  SDLK_WORLD_67 = 227;
{$EXTERNALSYM SDLK_WORLD_67}
  SDLK_WORLD_68 = 228;
{$EXTERNALSYM SDLK_WORLD_68}
  SDLK_WORLD_69 = 229;
{$EXTERNALSYM SDLK_WORLD_69}
  SDLK_WORLD_70 = 230;
{$EXTERNALSYM SDLK_WORLD_70}
  SDLK_WORLD_71 = 231;
{$EXTERNALSYM SDLK_WORLD_71}
  SDLK_WORLD_72 = 232;
{$EXTERNALSYM SDLK_WORLD_72}
  SDLK_WORLD_73 = 233;
{$EXTERNALSYM SDLK_WORLD_73}
  SDLK_WORLD_74 = 234;
{$EXTERNALSYM SDLK_WORLD_74}
  SDLK_WORLD_75 = 235;
{$EXTERNALSYM SDLK_WORLD_75}
  SDLK_WORLD_76 = 236;
{$EXTERNALSYM SDLK_WORLD_76}
  SDLK_WORLD_77 = 237;
{$EXTERNALSYM SDLK_WORLD_77}
  SDLK_WORLD_78 = 238;
{$EXTERNALSYM SDLK_WORLD_78}
  SDLK_WORLD_79 = 239;
{$EXTERNALSYM SDLK_WORLD_79}
  SDLK_WORLD_80 = 240;
{$EXTERNALSYM SDLK_WORLD_80}
  SDLK_WORLD_81 = 241;
{$EXTERNALSYM SDLK_WORLD_81}
  SDLK_WORLD_82 = 242;
{$EXTERNALSYM SDLK_WORLD_82}
  SDLK_WORLD_83 = 243;
{$EXTERNALSYM SDLK_WORLD_83}
  SDLK_WORLD_84 = 244;
{$EXTERNALSYM SDLK_WORLD_84}
  SDLK_WORLD_85 = 245;
{$EXTERNALSYM SDLK_WORLD_85}
  SDLK_WORLD_86 = 246;
{$EXTERNALSYM SDLK_WORLD_86}
  SDLK_WORLD_87 = 247;
{$EXTERNALSYM SDLK_WORLD_87}
  SDLK_WORLD_88 = 248;
{$EXTERNALSYM SDLK_WORLD_88}
  SDLK_WORLD_89 = 249;
{$EXTERNALSYM SDLK_WORLD_89}
  SDLK_WORLD_90 = 250;
{$EXTERNALSYM SDLK_WORLD_90}
  SDLK_WORLD_91 = 251;
{$EXTERNALSYM SDLK_WORLD_91}
  SDLK_WORLD_92 = 252;
{$EXTERNALSYM SDLK_WORLD_92}
  SDLK_WORLD_93 = 253;
{$EXTERNALSYM SDLK_WORLD_93}
  SDLK_WORLD_94 = 254;
{$EXTERNALSYM SDLK_WORLD_94}
  SDLK_WORLD_95 = 255; // 0xFF
{$EXTERNALSYM SDLK_WORLD_95}

  // Numeric keypad
  SDLK_KP0 = 256;
{$EXTERNALSYM SDLK_KP0}
  SDLK_KP1 = 257;
{$EXTERNALSYM SDLK_KP1}
  SDLK_KP2 = 258;
{$EXTERNALSYM SDLK_KP2}
  SDLK_KP3 = 259;
{$EXTERNALSYM SDLK_KP3}
  SDLK_KP4 = 260;
{$EXTERNALSYM SDLK_KP4}
  SDLK_KP5 = 261;
{$EXTERNALSYM SDLK_KP5}
  SDLK_KP6 = 262;
{$EXTERNALSYM SDLK_KP6}
  SDLK_KP7 = 263;
{$EXTERNALSYM SDLK_KP7}
  SDLK_KP8 = 264;
{$EXTERNALSYM SDLK_KP8}
  SDLK_KP9 = 265;
{$EXTERNALSYM SDLK_KP9}
  SDLK_KP_PERIOD = 266;
{$EXTERNALSYM SDLK_KP_PERIOD}
  SDLK_KP_DIVIDE = 267;
{$EXTERNALSYM SDLK_KP_DIVIDE}
  SDLK_KP_MULTIPLY = 268;
{$EXTERNALSYM SDLK_KP_MULTIPLY}
  SDLK_KP_MINUS = 269;
{$EXTERNALSYM SDLK_KP_MINUS}
  SDLK_KP_PLUS = 270;
{$EXTERNALSYM SDLK_KP_PLUS}
  SDLK_KP_ENTER = 271;
{$EXTERNALSYM SDLK_KP_ENTER}
  SDLK_KP_EQUALS = 272;
{$EXTERNALSYM SDLK_KP_EQUALS}

  // Arrows + Home/End pad
  SDLK_UP = 273;
{$EXTERNALSYM SDLK_UP}
  SDLK_DOWN = 274;
{$EXTERNALSYM SDLK_DOWN}
  SDLK_RIGHT = 275;
{$EXTERNALSYM SDLK_RIGHT}
  SDLK_LEFT = 276;
{$EXTERNALSYM SDLK_LEFT}
  SDLK_INSERT = 277;
{$EXTERNALSYM SDLK_INSERT}
  SDLK_HOME = 278;
{$EXTERNALSYM SDLK_HOME}
  SDLK_END = 279;
{$EXTERNALSYM SDLK_END}
  SDLK_PAGEUP = 280;
{$EXTERNALSYM SDLK_PAGEUP}
  SDLK_PAGEDOWN = 281;
{$EXTERNALSYM SDLK_PAGEDOWN}

  // Function keys
  SDLK_F1 = 282;
{$EXTERNALSYM SDLK_F1}
  SDLK_F2 = 283;
{$EXTERNALSYM SDLK_F2}
  SDLK_F3 = 284;
{$EXTERNALSYM SDLK_F3}
  SDLK_F4 = 285;
{$EXTERNALSYM SDLK_F4}
  SDLK_F5 = 286;
{$EXTERNALSYM SDLK_F5}
  SDLK_F6 = 287;
{$EXTERNALSYM SDLK_F6}
  SDLK_F7 = 288;
{$EXTERNALSYM SDLK_F7}
  SDLK_F8 = 289;
{$EXTERNALSYM SDLK_F8}
  SDLK_F9 = 290;
{$EXTERNALSYM SDLK_F9}
  SDLK_F10 = 291;
{$EXTERNALSYM SDLK_F10}
  SDLK_F11 = 292;
{$EXTERNALSYM SDLK_F11}
  SDLK_F12 = 293;
{$EXTERNALSYM SDLK_F12}
  SDLK_F13 = 294;
{$EXTERNALSYM SDLK_F13}
  SDLK_F14 = 295;
{$EXTERNALSYM SDLK_F14}
  SDLK_F15 = 296;
{$EXTERNALSYM SDLK_F15}

  // Key state modifier keys
  SDLK_NUMLOCK = 300;
{$EXTERNALSYM SDLK_NUMLOCK}
  SDLK_CAPSLOCK = 301;
{$EXTERNALSYM SDLK_CAPSLOCK}
  SDLK_SCROLLOCK = 302;
{$EXTERNALSYM SDLK_SCROLLOCK}
  SDLK_RSHIFT = 303;
{$EXTERNALSYM SDLK_RSHIFT}
  SDLK_LSHIFT = 304;
{$EXTERNALSYM SDLK_LSHIFT}
  SDLK_RCTRL = 305;
{$EXTERNALSYM SDLK_RCTRL}
  SDLK_LCTRL = 306;
{$EXTERNALSYM SDLK_LCTRL}
  SDLK_RALT = 307;
{$EXTERNALSYM SDLK_RALT}
  SDLK_LALT = 308;
{$EXTERNALSYM SDLK_LALT}
  SDLK_RMETA = 309;
{$EXTERNALSYM SDLK_RMETA}
  SDLK_LMETA = 310;
{$EXTERNALSYM SDLK_LMETA}
  SDLK_LSUPER = 311; // Left "Windows" key
{$EXTERNALSYM SDLK_LSUPER}
  SDLK_RSUPER = 312; // Right "Windows" key
{$EXTERNALSYM SDLK_RSUPER}
  SDLK_MODE = 313; // "Alt Gr" key
{$EXTERNALSYM SDLK_MODE}
  SDLK_COMPOSE = 314; // Multi-key compose key
{$EXTERNALSYM SDLK_COMPOSE}

  // Miscellaneous function keys
  SDLK_HELP = 315;
{$EXTERNALSYM SDLK_HELP}
  SDLK_PRINT = 316;
{$EXTERNALSYM SDLK_PRINT}
  SDLK_SYSREQ = 317;
{$EXTERNALSYM SDLK_SYSREQ}
  SDLK_BREAK = 318;
{$EXTERNALSYM SDLK_BREAK}
  SDLK_MENU = 319;
{$EXTERNALSYM SDLK_MENU}
  SDLK_POWER = 320; // Power Macintosh power key
{$EXTERNALSYM SDLK_POWER}
  SDLK_EURO = 321; // Some european keyboards
{$EXTERNALSYM SDLK_EURO}

{$IFDEF GP2X}
SDLK_GP2X_UP = 0;
{$EXTERNALSYM SDLK_GP2X_UP}
SDLK_GP2X_UPLEFT = 1;
{$EXTERNALSYM SDLK_GP2X_UPLEFT}
SDLK_GP2X_LEFT = 2;
{$EXTERNALSYM SDLK_GP2X_LEFT}
SDLK_GP2X_DOWNLEFT = 3;
{$EXTERNALSYM SDLK_GP2X_DOWNLEFT}
SDLK_GP2X_DOWN = 4;
{$EXTERNALSYM SDLK_GP2X_DOWN}
SDLK_GP2X_DOWNRIGHT = 5;
{$EXTERNALSYM SDLK_GP2X_DOWNRIGHT}
SDLK_GP2X_RIGHT = 6;
{$EXTERNALSYM SDLK_GP2X_RIGHT}
SDLK_GP2X_UPRIGHT = 7;
{$EXTERNALSYM SDLK_GP2X_UPRIGHT}
SDLK_GP2X_START = 8;
{$EXTERNALSYM SDLK_GP2X_START}
SDLK_GP2X_SELECT = 9;
{$EXTERNALSYM SDLK_GP2X_SELECT}
SDLK_GP2X_L = 10;
{$EXTERNALSYM SDLK_GP2X_L}
SDLK_GP2X_R = 11;
{$EXTERNALSYM SDLK_GP2X_R}
SDLK_GP2X_A = 12;
{$EXTERNALSYM SDLK_GP2X_A}
SDLK_GP2X_B = 13;
{$EXTERNALSYM SDLK_GP2X_B}
SDLK_GP2X_Y = 14;
{$EXTERNALSYM SDLK_GP2X_Y}
SDLK_GP2X_X = 15;
{$EXTERNALSYM SDLK_GP2X_X}
SDLK_GP2X_VOLUP = 16;
{$EXTERNALSYM SDLK_GP2X_VOLUP}
SDLK_GP2X_VOLDOWN = 17;
{$EXTERNALSYM SDLK_GP2X_VOLDOWN}
SDLK_GP2X_CLICK = 18;
{$EXTERNALSYM SDLK_GP2X_CLICK}
{$ENDIF}

  // Enumeration of valid key mods (possibly OR'd together)
  KMOD_NONE = $0000;
{$EXTERNALSYM KMOD_NONE}
  KMOD_LSHIFT = $0001;
{$EXTERNALSYM KMOD_LSHIFT}
  KMOD_RSHIFT = $0002;
{$EXTERNALSYM KMOD_RSHIFT}
  KMOD_LCTRL = $0040;
{$EXTERNALSYM KMOD_LCTRL}
  KMOD_RCTRL = $0080;
{$EXTERNALSYM KMOD_RCTRL}
  KMOD_LALT = $0100;
{$EXTERNALSYM KMOD_LALT}
  KMOD_RALT = $0200;
{$EXTERNALSYM KMOD_RALT}
  KMOD_LMETA = $0400;
{$EXTERNALSYM KMOD_LMETA}
  KMOD_RMETA = $0800;
{$EXTERNALSYM KMOD_RMETA}
  KMOD_NUM = $1000;
{$EXTERNALSYM KMOD_NUM}
  KMOD_CAPS = $2000;
{$EXTERNALSYM KMOD_CAPS}
  KMOD_MODE = 44000;
{$EXTERNALSYM KMOD_MODE}
  KMOD_RESERVED = $8000;
{$EXTERNALSYM KMOD_RESERVED}

  KMOD_CTRL = (KMOD_LCTRL or KMOD_RCTRL);
{$EXTERNALSYM KMOD_CTRL}
  KMOD_SHIFT = (KMOD_LSHIFT or KMOD_RSHIFT);
{$EXTERNALSYM KMOD_SHIFT}
  KMOD_ALT = (KMOD_LALT or KMOD_RALT);
{$EXTERNALSYM KMOD_ALT}
  KMOD_META = (KMOD_LMETA or KMOD_RMETA);
{$EXTERNALSYM KMOD_META}

  //SDL_video.h constants
  // Transparency definitions: These define alpha as the opacity of a surface */
  SDL_ALPHA_OPAQUE = 255;
{$EXTERNALSYM SDL_ALPHA_OPAQUE}
  SDL_ALPHA_TRANSPARENT = 0;
{$EXTERNALSYM SDL_ALPHA_TRANSPARENT}

  // These are the currently supported flags for the SDL_surface
  // Available for SDL_CreateRGBSurface() or SDL_SetVideoMode()
  SDL_SWSURFACE = $00000000; // Surface is in system memory
{$EXTERNALSYM SDL_SWSURFACE}
  SDL_HWSURFACE = $00000001; // Surface is in video memory
{$EXTERNALSYM SDL_HWSURFACE}
  SDL_ASYNCBLIT = $00000004; // Use asynchronous blits if possible
{$EXTERNALSYM SDL_ASYNCBLIT}
  // Available for SDL_SetVideoMode()
  SDL_ANYFORMAT = $10000000; // Allow any video depth/pixel-format
{$EXTERNALSYM SDL_ANYFORMAT}
  SDL_HWPALETTE = $20000000; // Surface has exclusive palette
{$EXTERNALSYM SDL_HWPALETTE}
  SDL_DOUBLEBUF = $40000000; // Set up double-buffered video mode
{$EXTERNALSYM SDL_DOUBLEBUF}
  SDL_FULLSCREEN = $80000000; // Surface is a full screen display
{$EXTERNALSYM SDL_FULLSCREEN}
  SDL_OPENGL = $00000002; // Create an OpenGL rendering context
{$EXTERNALSYM SDL_OPENGL}
  SDL_OPENGLBLIT = $00000002; // Create an OpenGL rendering context
{$EXTERNALSYM SDL_OPENGLBLIT}
  SDL_RESIZABLE = $00000010; // This video mode may be resized
{$EXTERNALSYM SDL_RESIZABLE}
  SDL_NOFRAME = $00000020; // No window caption or edge frame
{$EXTERNALSYM SDL_NOFRAME}
  // Used internally (read-only)
  SDL_HWACCEL = $00000100; // Blit uses hardware acceleration
{$EXTERNALSYM SDL_HWACCEL}
  SDL_SRCCOLORKEY = $00001000; // Blit uses a source color key
{$EXTERNALSYM SDL_SRCCOLORKEY}
  SDL_RLEACCELOK = $00002000; // Private flag
{$EXTERNALSYM SDL_RLEACCELOK}
  SDL_RLEACCEL = $00004000; // Colorkey blit is RLE accelerated
{$EXTERNALSYM SDL_RLEACCEL}
  SDL_SRCALPHA = $00010000; // Blit uses source alpha blending
{$EXTERNALSYM SDL_SRCALPHA}
  SDL_SRCCLIPPING = $00100000; // Blit uses source clipping
{$EXTERNALSYM SDL_SRCCLIPPING}
  SDL_PREALLOC = $01000000; // Surface uses preallocated memory
{$EXTERNALSYM SDL_PREALLOC}

  { The most common video overlay formats.
    For an explanation of these pixel formats, see:
    http://www.webartz.com/fourcc/indexyuv.htm

   For information on the relationship between color spaces, see:
   http://www.neuro.sfc.keio.ac.jp/~aly/polygon/info/color-space-faq.html }

  SDL_YV12_OVERLAY = $32315659; // Planar mode: Y + V + U  (3 planes)
{$EXTERNALSYM SDL_YV12_OVERLAY}
  SDL_IYUV_OVERLAY = $56555949; // Planar mode: Y + U + V  (3 planes)
{$EXTERNALSYM SDL_IYUV_OVERLAY}
  SDL_YUY2_OVERLAY = $32595559; // Packed mode: Y0+U0+Y1+V0 (1 plane)
{$EXTERNALSYM SDL_YUY2_OVERLAY}
  SDL_UYVY_OVERLAY = $59565955; // Packed mode: U0+Y0+V0+Y1 (1 plane)
{$EXTERNALSYM SDL_UYVY_OVERLAY}
  SDL_YVYU_OVERLAY = $55595659; // Packed mode: Y0+V0+Y1+U0 (1 plane)
{$EXTERNALSYM SDL_YVYU_OVERLAY}

  // flags for SDL_SetPalette()
  SDL_LOGPAL = $01;
{$EXTERNALSYM SDL_LOGPAL}
  SDL_PHYSPAL = $02;
{$EXTERNALSYM SDL_PHYSPAL}

  //SDL_mouse.h constants
  { Used as a mask when testing buttons in buttonstate
    Button 1:	Left mouse button
    Button 2:	Middle mouse button
    Button 3:	Right mouse button
    Button 4:	Mouse Wheel Up (may also be a real button)
    Button 5:	Mouse Wheel Down (may also be a real button)
    Button 6:	Mouse X1 (may also be a real button)
    Button 7:	Mouse X2 (may also be a real button)
  }
  SDL_BUTTON_LEFT      = 1;
{$EXTERNALSYM SDL_BUTTON_LEFT}
  SDL_BUTTON_MIDDLE    = 2;
{$EXTERNALSYM SDL_BUTTON_MIDDLE}
  SDL_BUTTON_RIGHT     = 3;
{$EXTERNALSYM SDL_BUTTON_RIGHT}
  SDL_BUTTON_WHEELUP   = 4;
{$EXTERNALSYM SDL_BUTTON_WHEELUP}
  SDL_BUTTON_WHEELDOWN = 5;
{$EXTERNALSYM SDL_BUTTON_WHEELDOWN}
  SDL_BUTTON_X1        = 6;
{$EXTERNALSYM SDL_BUTTON_X1}
  SDL_BUTTON_X2        = 7;
{$EXTERNALSYM SDL_BUTTON_X2}

  SDL_BUTTON_LMASK = SDL_PRESSED shl (SDL_BUTTON_LEFT - 1);
{$EXTERNALSYM SDL_BUTTON_LMASK}
  SDL_BUTTON_MMASK = SDL_PRESSED shl (SDL_BUTTON_MIDDLE - 1);
{$EXTERNALSYM SDL_BUTTON_MMASK}
  SDL_BUTTON_RMASK = SDL_PRESSED shl (SDL_BUTTON_RIGHT - 1);
{$EXTERNALSYM SDL_BUTTON_RMASK}
  SDL_BUTTON_X1MASK = SDL_PRESSED shl (SDL_BUTTON_X1 - 1);
{$EXTERNALSYM SDL_BUTTON_X1MASK}
  SDL_BUTTON_X2MASK = SDL_PRESSED shl (SDL_BUTTON_X2 - 1);
{$EXTERNALSYM SDL_BUTTON_X2MASK}

  // SDL_active.h constants
  // The available application states
  SDL_APPMOUSEFOCUS = $01; // The app has mouse coverage
{$EXTERNALSYM SDL_APPMOUSEFOCUS}
  SDL_APPINPUTFOCUS = $02; // The app has input focus
{$EXTERNALSYM SDL_APPINPUTFOCUS}
  SDL_APPACTIVE = $04; // The application is active
{$EXTERNALSYM SDL_APPACTIVE}

  // SDL_mutex.h constants
  // Synchronization functions which can time out return this value
  //  they time out.

  SDL_MUTEX_TIMEDOUT = 1;
{$EXTERNALSYM SDL_MUTEX_TIMEDOUT}

  // This is the timeout value which corresponds to never time out
  SDL_MUTEX_MAXWAIT = not Cardinal(0);
{$EXTERNALSYM SDL_MUTEX_MAXWAIT}

  {TSDL_GrabMode = (
    SDL_GRAB_QUERY,
    SDL_GRAB_OFF,
    SDL_GRAB_ON,
    SDL_GRAB_FULLSCREEN	); // Used internally}
  SDL_GRAB_QUERY = -1;
  SDL_GRAB_OFF   = 0;
  SDL_GRAB_ON    = 1;
  //SDL_GRAB_FULLSCREEN // Used internally

type
  THandle = Cardinal;
  //SDL_types.h types
  // Basic data types

  SDL_Bool  = (SDL_FALSE, SDL_TRUE);
  TSDL_Bool = SDL_Bool;

  PUInt8Array = ^TUInt8Array;
  PUInt8 = ^UInt8;
  PPUInt8 = ^PUInt8;
  UInt8 = Byte;
{$EXTERNALSYM UInt8}
  TUInt8Array = array [0..MAXINT shr 1] of UInt8;

  PUInt16 = ^UInt16;
  UInt16 = word;
{$EXTERNALSYM UInt16}

  PSInt8 = ^SInt8;
  SInt8 = Shortint;
{$EXTERNALSYM SInt8}

  PSInt16 = ^SInt16;
  SInt16 = smallint;
{$EXTERNALSYM SInt16}

  PUInt32 = ^UInt32;
  UInt32 = Cardinal;
{$EXTERNALSYM UInt32}

  SInt32 = Integer;
{$EXTERNALSYM SInt32}

  PInt = ^Integer;

  PShortInt = ^ShortInt;

  PUInt64 = ^UInt64;
  UInt64 = record
    hi: UInt32;
    lo: UInt32;
  end;
{$EXTERNALSYM UInt64}

  PSInt64 = ^SInt64;
  SInt64 = record
    hi: UInt32;
    lo: UInt32;
  end;
{$EXTERNALSYM SInt64}

  TSDL_GrabMode = Integer;

  // SDL_error.h types
  TSDL_errorcode = (
    SDL_ENOMEM,
    SDL_EFREAD,
    SDL_EFWRITE,
    SDL_EFSEEK,
    SDL_LASTERROR);

  SDL_errorcode = TSDL_errorcode;
{$EXTERNALSYM SDL_errorcode}

  TArg = record
    case Byte of
      0: (value_ptr: Pointer);
      (* #if 0 means: never
      1 :  ( value_c : Byte );
      *)
      2: (value_i: Integer);
      3: (value_f: double);
      4: (buf: array[0..ERR_MAX_STRLEN - 1] of Byte);
  end;

  PSDL_error = ^TSDL_error;
  TSDL_error = record
    { This is a numeric value corresponding to the current error }
    error: Integer;

    { This is a key used to index into a language hashtable containing
       internationalized versions of the SDL error messages.  If the key
       is not in the hashtable, or no hashtable is available, the key is
       used directly as an error message format string. }
    key: array[0..ERR_MAX_STRLEN - 1] of Byte;

    { These are the arguments for the error functions }
    argc: Integer;
    args: array[0..ERR_MAX_ARGS - 1] of TArg;
  end;

  // SDL_rwops.h types
  // This is the read/write operation structure -- very basic
  // some helper types to handle the unions
  // "packed" is only guessed

  TStdio = record
    autoclose: Integer;
   // FILE * is only defined in Kylix so we use a simple Pointer
    fp: Pointer;
  end;

  TMem = record
    base: PUInt8;
    here: PUInt8;
    stop: PUInt8;
  end;

  TUnknown = record
    data1: Pointer;
  end;

  // first declare the pointer type
  PSDL_RWops = ^TSDL_RWops;
  // now the pointer to function types
  {$IFNDEF __GPC__}
  TSeek = function( context: PSDL_RWops; offset: Integer; whence: Integer ): Integer; cdecl;
  TRead = function( context: PSDL_RWops; Ptr: Pointer; size: Integer; maxnum : Integer ): Integer;  cdecl;
  TWrite = function( context: PSDL_RWops; Ptr: Pointer; size: Integer; num: Integer ): Integer; cdecl;
  TClose = function( context: PSDL_RWops ): Integer; cdecl;
  {$ELSE}
  TSeek = function( context: PSDL_RWops; offset: Integer; whence: Integer ): Integer;
  TRead = function( context: PSDL_RWops; Ptr: Pointer; size: Integer; maxnum : Integer ): Integer;
  TWrite = function( context: PSDL_RWops; Ptr: Pointer; size: Integer; num: Integer ): Integer;
  TClose = function( context: PSDL_RWops ): Integer;
  {$ENDIF}
  // the variant record itself
  TSDL_RWops = record
    seek: TSeek;
    read: TRead;
    write: TWrite;
    close: TClose;
    // a keyword as name is not allowed
    type_: UInt32;
    // be warned! structure alignment may arise at this point
    case Integer of
      0: (stdio: TStdio);
      1: (mem: TMem);
      2: (unknown: TUnknown);
  end;

  SDL_RWops = TSDL_RWops;
{$EXTERNALSYM SDL_RWops}


  // SDL_timer.h types
  // Function prototype for the timer callback function
  {$IFNDEF __GPC__}
  TSDL_TimerCallback = function( interval: UInt32 ): UInt32; cdecl;
  {$ELSE}
  TSDL_TimerCallback = function( interval: UInt32 ): UInt32;
  {$ENDIF}

 { New timer API, supports multiple timers
   Written by Stephane Peter <megastep@lokigames.com> }

 { Function prototype for the new timer callback function.
   The callback function is passed the current timer interval and returns
   the next timer interval.  If the returned value is the same as the one
   passed in, the periodic alarm continues, otherwise a new alarm is
   scheduled.  If the callback returns 0, the periodic alarm is cancelled. }
  {$IFNDEF __GPC__}
  TSDL_NewTimerCallback = function( interval: UInt32; param: Pointer ): UInt32; cdecl;
  {$ELSE}
  TSDL_NewTimerCallback = function( interval: UInt32; param: Pointer ): UInt32;
  {$ENDIF}
  
  // Definition of the timer ID type
  PSDL_TimerID = ^TSDL_TimerID;
  TSDL_TimerID = record
    interval: UInt32;
    callback: TSDL_NewTimerCallback;
    param: Pointer;
    last_alarm: UInt32;
    next: PSDL_TimerID;
  end;

  {$IFNDEF __GPC__}
  TSDL_AudioSpecCallback = procedure( userdata: Pointer; stream: PUInt8; len: Integer ); cdecl;
  {$ELSE}
  TSDL_AudioSpecCallback = procedure( userdata: Pointer; stream: PUInt8; len: Integer );
  {$ENDIF}

  // SDL_audio.h types
  // The calculated values in this structure are calculated by SDL_OpenAudio()
  PSDL_AudioSpec = ^TSDL_AudioSpec;
  TSDL_AudioSpec = record
    freq: Integer; // DSP frequency -- samples per second
    format: UInt16; // Audio data format
    channels: UInt8; // Number of channels: 1 mono, 2 stereo
    silence: UInt8; // Audio buffer silence value (calculated)
    samples: UInt16; // Audio buffer size in samples
    padding: UInt16; // Necessary for some compile environments
    size: UInt32; // Audio buffer size in bytes (calculated)
    { This function is called when the audio device needs more data.
      'stream' is a pointer to the audio data buffer
      'len' is the length of that buffer in bytes.
      Once the callback returns, the buffer will no longer be valid.
      Stereo samples are stored in a LRLRLR ordering.}
    callback: TSDL_AudioSpecCallback;
    userdata: Pointer;
  end;

  // A structure to hold a set of audio conversion filters and buffers
  PSDL_AudioCVT = ^TSDL_AudioCVT;

  PSDL_AudioCVTFilter = ^TSDL_AudioCVTFilter;
  TSDL_AudioCVTFilter = record
    cvt: PSDL_AudioCVT;
    format: UInt16;
  end;

  PSDL_AudioCVTFilterArray = ^TSDL_AudioCVTFilterArray;
  TSDL_AudioCVTFilterArray = array[0..9] of PSDL_AudioCVTFilter;

  TSDL_AudioCVT = record
    needed: Integer; // Set to 1 if conversion possible
    src_format: UInt16; // Source audio format
    dst_format: UInt16; // Target audio format
    rate_incr: double; // Rate conversion increment
    buf: PUInt8; // Buffer to hold entire audio data
    len: Integer; // Length of original audio buffer
    len_cvt: Integer; // Length of converted audio buffer
    len_mult: Integer; // buffer must be len*len_mult big
    len_ratio: double; // Given len, final size is len*len_ratio
    filters: TSDL_AudioCVTFilterArray;
    filter_index: Integer; // Current audio conversion function
  end;

  TSDL_Audiostatus = (
    SDL_AUDIO_STOPPED,
    SDL_AUDIO_PLAYING,
    SDL_AUDIO_PAUSED
    );

  // SDL_cdrom.h types
  TSDL_CDStatus = (
    CD_ERROR,
    CD_TRAYEMPTY,
    CD_STOPPED,
    CD_PLAYING,
    CD_PAUSED );

  PSDL_CDTrack = ^TSDL_CDTrack;
  TSDL_CDTrack = record
    id: UInt8; // Track number
    type_: UInt8; // Data or audio track
    unused: UInt16;
    length: UInt32; // Length, in frames, of this track
    offset: UInt32; // Offset, in frames, from start of disk
  end;

  // This structure is only current as of the last call to SDL_CDStatus()
  PSDL_CD = ^TSDL_CD;
  TSDL_CD = record
    id: Integer; // Private drive identifier
    status: TSDL_CDStatus; // Current drive status

    // The rest of this structure is only valid if there's a CD in drive
    numtracks: Integer; // Number of tracks on disk
    cur_track: Integer; // Current track position
    cur_frame: Integer; // Current frame offset within current track
    track: array[0..SDL_MAX_TRACKS] of TSDL_CDTrack;
  end;

  //SDL_joystick.h types
  PTransAxis = ^TTransAxis;
  TTransAxis = record
    offset: Integer;
    scale: single;
  end;

  // The private structure used to keep track of a joystick
  PJoystick_hwdata = ^TJoystick_hwdata;
  TJoystick_hwdata = record
    // joystick ID
    id: Integer;
    // values used to translate device-specific coordinates into  SDL-standard ranges
    transaxis: array[0..5] of TTransAxis;
  end;

  PBallDelta = ^TBallDelta;
  TBallDelta = record
    dx: Integer;
    dy: Integer;
  end; // Current ball motion deltas

  // The SDL joystick structure
  PSDL_Joystick = ^TSDL_Joystick;
  TSDL_Joystick = record
    index: UInt8; // Device index
    name: PAnsiChar; // Joystick name - system dependent

    naxes: Integer; // Number of axis controls on the joystick
    axes: PUInt16; // Current axis states

    nhats: Integer; // Number of hats on the joystick
    hats: PUInt8; // Current hat states

    nballs: Integer; // Number of trackballs on the joystick
    balls: PBallDelta; // Current ball motion deltas

    nbuttons: Integer; // Number of buttons on the joystick
    buttons: PUInt8; // Current button states

    hwdata: PJoystick_hwdata; // Driver dependent information

    ref_count: Integer; // Reference count for multiple opens
  end;

  // SDL_verion.h types
  PSDL_version = ^TSDL_version;
  TSDL_version = record
    major: UInt8;
    minor: UInt8;
    patch: UInt8;
  end;

  // SDL_keyboard.h types
  TSDLKey = LongWord;

  TSDLMod = LongWord;

  PSDL_KeySym = ^TSDL_KeySym;
  TSDL_KeySym = record
    scancode: UInt8; // hardware specific scancode
    sym: TSDLKey; // SDL virtual keysym
    modifier: TSDLMod; // current key modifiers
    unicode: UInt16; // translated character
  end;

  // SDL_events.h types
  {Checks the event queue for messages and optionally returns them.
   If 'action' is SDL_ADDEVENT, up to 'numevents' events will be added to
   the back of the event queue.
   If 'action' is SDL_PEEKEVENT, up to 'numevents' events at the front
   of the event queue, matching 'mask', will be returned and will not
   be removed from the queue.
   If 'action' is SDL_GETEVENT, up to 'numevents' events at the front
   of the event queue, matching 'mask', will be returned and will be
   removed from the queue.
   This function returns the number of events actually stored, or -1
   if there was an error.  This function is thread-safe. }

  TSDL_EventAction = (SDL_ADDEVENT, SDL_PEEKEVENT, SDL_GETEVENT);

  // Application visibility event structure
  TSDL_ActiveEvent = record
    type_: UInt8; // SDL_ACTIVEEVENT
    gain: UInt8; // Whether given states were gained or lost (1/0)
    state: UInt8; // A mask of the focus states
  end;

  // Keyboard event structure
  TSDL_KeyboardEvent = record
    type_: UInt8; // SDL_KEYDOWN or SDL_KEYUP
    which: UInt8; // The keyboard device index
    state: UInt8; // SDL_PRESSED or SDL_RELEASED
    keysym: TSDL_KeySym;
  end;

  // Mouse motion event structure
  TSDL_MouseMotionEvent = record
    type_: UInt8; // SDL_MOUSEMOTION
    which: UInt8; // The mouse device index
    state: UInt8; // The current button state
    x, y: UInt16; // The X/Y coordinates of the mouse
    xrel: SInt16; // The relative motion in the X direction
    yrel: SInt16; // The relative motion in the Y direction
  end;

  // Mouse button event structure
  TSDL_MouseButtonEvent = record
    type_: UInt8;  // SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP
    which: UInt8;  // The mouse device index
    button: UInt8; // The mouse button index
    state: UInt8;  // SDL_PRESSED or SDL_RELEASED
    x: UInt16;     // The X coordinates of the mouse at press time
    y: UInt16;     // The Y coordinates of the mouse at press time
  end;

  // Joystick axis motion event structure
  TSDL_JoyAxisEvent = record
    type_: UInt8; // SDL_JOYAXISMOTION
    which: UInt8; // The joystick device index
    axis: UInt8; // The joystick axis index
    value: SInt16; // The axis value (range: -32768 to 32767)
  end;

  // Joystick trackball motion event structure
  TSDL_JoyBallEvent = record
    type_: UInt8; // SDL_JOYAVBALLMOTION
    which: UInt8; // The joystick device index
    ball: UInt8; // The joystick trackball index
    xrel: SInt16; // The relative motion in the X direction
    yrel: SInt16; // The relative motion in the Y direction
  end;

  // Joystick hat position change event structure
  TSDL_JoyHatEvent = record
    type_: UInt8; // SDL_JOYHATMOTION */
    which: UInt8; // The joystick device index */
    hat: UInt8; // The joystick hat index */
    value: UInt8; { The hat position value:
                    8   1   2
                    7   0   3
                    6   5   4

                    Note that zero means the POV is centered. }

  end;

  // Joystick button event structure
  TSDL_JoyButtonEvent = record
    type_: UInt8; // SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP
    which: UInt8; // The joystick device index
    button: UInt8; // The joystick button index
    state: UInt8; // SDL_PRESSED or SDL_RELEASED
  end;

  { The "window resized" event
    When you get this event, you are responsible for setting a new video
    mode with the new width and height. }
  TSDL_ResizeEvent = record
    type_: UInt8; // SDL_VIDEORESIZE
    w: Integer; // New width
    h: Integer; // New height
  end;

  // The "quit requested" event
  PSDL_QuitEvent = ^TSDL_QuitEvent;
  TSDL_QuitEvent = record
    type_: UInt8;
  end;

  // A user-defined event type
  PSDL_UserEvent = ^TSDL_UserEvent;
  TSDL_UserEvent = record
    type_: UInt8; // SDL_USEREVENT through SDL_NUMEVENTS-1
    code: Integer; // User defined event code */
    data1: Pointer; // User defined data pointer */
    data2: Pointer; // User defined data pointer */
  end;

  // The "screen redraw" event
  PSDL_ExposeEvent = ^TSDL_ExposeEvent;
  TSDL_ExposeEvent = record
    type_ : Uint8;        // SDL_VIDEOEXPOSE
  end;

 {$IFDEF Unix}
 //These are the various supported subsystems under UNIX
  TSDL_SysWm = ( SDL_SYSWM_X11 ) ;
 {$ENDIF}

// The windows custom event structure
{$IFDEF WINDOWS}
  PSDL_SysWMmsg = ^TSDL_SysWMmsg;
  TSDL_SysWMmsg = record
    version: TSDL_version;
    h_wnd: HWND; // The window for the message
    msg: UInt; // The type of message
    w_Param: WPARAM; // WORD message parameter
    lParam: LPARAM; // LONG message parameter
  end;
{$ELSE}

{$IFDEF Unix}
{ The Linux custom event structure }
  PSDL_SysWMmsg = ^TSDL_SysWMmsg;
  TSDL_SysWMmsg = record
    version : TSDL_version;
    subsystem : TSDL_SysWm;
    {$IFDEF FPC}
    {$IFNDEF GP2X}
    {$IFNDEF DARWIN}
    {$IFNDEF SKYOS}
    event : TXEvent;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ELSE}
    event : XEvent;
    {$ENDIF}
  end;
{$ELSE}
{ The generic custom event structure }
  PSDL_SysWMmsg = ^TSDL_SysWMmsg;
  TSDL_SysWMmsg = record
    version: TSDL_version;
    data: Integer;
  end;
{$ENDIF}

{$ENDIF}

// The Windows custom window manager information structure
{$IFDEF WINDOWS}
  PSDL_SysWMinfo = ^TSDL_SysWMinfo;
  TSDL_SysWMinfo = record
    version : TSDL_version;
    window : HWnd;	// The display window
  end;
{$ELSE}

// The Linux custom window manager information structure
{$IFDEF Unix}
  {$IFNDEF GP2X}
  {$IFNDEF DARWIN}
  {$IFNDEF SKYOS}
  TX11 = record
    display : PDisplay;	// The X11 display
    window : TWindow ;		// The X11 display window */
    {* These locking functions should be called around
       any X11 functions using the display variable.
       They lock the event thread, so should not be
       called around event functions or from event filters.
     *}
    lock_func : Pointer;
    unlock_func : Pointer;

    // Introduced in SDL 1.0.2
    fswindow : TWindow ;	// The X11 fullscreen window */
    wmwindow : TWindow ;	// The X11 managed input window */
  end;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  
  PSDL_SysWMinfo = ^TSDL_SysWMinfo;
  TSDL_SysWMinfo = record
     version : TSDL_version ;
     subsystem : TSDL_SysWm;
     {$IFNDEF GP2X}
     {$IFNDEF DARWIN}
     {$IFNDEF SKYOS}
     X11 : TX11;
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
  end;
{$ELSE}
  // The generic custom window manager information structure
  PSDL_SysWMinfo = ^TSDL_SysWMinfo;
  TSDL_SysWMinfo = record
    version : TSDL_version ;
    data : integer;
  end;
{$ENDIF}

{$ENDIF}

  PSDL_SysWMEvent = ^TSDL_SysWMEvent;
  TSDL_SysWMEvent = record
    type_: UInt8;
    msg: PSDL_SysWMmsg;
  end;

  PSDL_Event = ^TSDL_Event;
  TSDL_Event = record
    case UInt8 of
      SDL_NOEVENT: (type_: byte);
      SDL_ACTIVEEVENT: (active: TSDL_ActiveEvent);
      SDL_KEYDOWN, SDL_KEYUP: (key: TSDL_KeyboardEvent);
      SDL_MOUSEMOTION: (motion: TSDL_MouseMotionEvent);
      SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP: (button: TSDL_MouseButtonEvent );
      SDL_JOYAXISMOTION: (jaxis: TSDL_JoyAxisEvent );
      SDL_JOYBALLMOTION: (jball: TSDL_JoyBallEvent );
      SDL_JOYHATMOTION: (jhat: TSDL_JoyHatEvent );
      SDL_JOYBUTTONDOWN, SDL_JOYBUTTONUP: (jbutton: TSDL_JoyButtonEvent );
      SDL_VIDEORESIZE: (resize: TSDL_ResizeEvent );
      SDL_QUITEV: (quit: TSDL_QuitEvent );
      SDL_USEREVENT : ( user : TSDL_UserEvent );
      SDL_SYSWMEVENT: (syswm: TSDL_SysWMEvent );
  end;


{ This function sets up a filter to process all events before they
  change internal state and are posted to the internal event queue.

  The filter is protypted as: }
  {$IFNDEF __GPC__}
  TSDL_EventFilter = function( event : PSDL_Event ): Integer; cdecl;
  {$ELSE}
  TSDL_EventFilter = function( event : PSDL_Event ): Integer;
  {$ENDIF}

  // SDL_video.h types
  // Useful data types
  PPSDL_Rect = ^PSDL_Rect;
  PSDL_Rect = ^TSDL_Rect;
  TSDL_Rect = record
    x, y: SInt16;
    w, h: UInt16;
  end;

  SDL_Rect = TSDL_Rect;
{$EXTERNALSYM SDL_Rect}

  PSDL_Color = ^TSDL_Color;
  TSDL_Color = record
    r: UInt8;
    g: UInt8;
    b: UInt8;
    unused: UInt8;
  end;

  PSDL_ColorArray = ^TSDL_ColorArray;
  TSDL_ColorArray = array[0..65000] of TSDL_Color;

  PSDL_Palette = ^TSDL_Palette;
  TSDL_Palette = record
    ncolors: Integer;
    colors: PSDL_ColorArray;
  end;

  // Everything in the pixel format structure is read-only
  PSDL_PixelFormat = ^TSDL_PixelFormat;
  TSDL_PixelFormat = record
    palette: PSDL_Palette;
    BitsPerPixel: UInt8;
    BytesPerPixel: UInt8;
    Rloss: UInt8;
    Gloss: UInt8;
    Bloss: UInt8;
    Aloss: UInt8;
    Rshift: UInt8;
    Gshift: UInt8;
    Bshift: UInt8;
    Ashift: UInt8;
    RMask: UInt32;
    GMask: UInt32;
    BMask: UInt32;
    AMask: UInt32;
    colorkey: UInt32; // RGB color key information
    alpha: UInt8; // Alpha value information (per-surface alpha)
  end;

{$IFDEF WINDOWS}
  {PPrivate_hwdata = ^TPrivate_hwdata;
  TPrivate_hwdata = record
    dd_surface : IDIRECTDRAWSURFACE3;
    dd_writebuf : IDIRECTDRAWSURFACE3;
  end;}
  {ELSE}
{$ENDIF}

  // The structure passed to the low level blit functions
  PSDL_BlitInfo = ^TSDL_BlitInfo;
  TSDL_BlitInfo = record
    s_pixels: PUInt8;
    s_width: Integer;
    s_height: Integer;
    s_skip: Integer;
    d_pixels: PUInt8;
    d_width: Integer;
    d_height: Integer;
    d_skip: Integer;
    aux_data: Pointer;
    src: PSDL_PixelFormat;
    table: PUInt8;
    dst: PSDL_PixelFormat;
  end;

  // typedef for private surface blitting functions
  PSDL_Surface = ^TSDL_Surface;

  {$IFNDEF __GPC__}
  TSDL_Blit = function( src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect ): Integer; cdecl;
  {$ELSE}
  TSDL_Blit = function( src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect ): Integer;
  {$ENDIF}

  // The type definition for the low level blit functions
  //TSDL_LoBlit = procedure( info : PSDL_BlitInfo ); cdecl;

  // This is the private info structure for software accelerated blits
  {PPrivate_swaccel = ^TPrivate_swaccel;
  TPrivate_swaccel = record
    blit : TSDL_LoBlit;
    aux_data : Pointer;
  end;}

  // Blit mapping definition
  {PSDL_BlitMap = ^TSDL_BlitMap;
  TSDL_BlitMap = record
    dst : PSDL_Surface;
    identity : Integer;
    table : PUInt8;
    hw_blit : TSDL_Blit;
    sw_blit : TSDL_Blit;
    hw_data : PPrivate_hwaccel;
    sw_data : PPrivate_swaccel;

    // the version count matches the destination; mismatch indicates an invalid mapping
    format_version : Cardinal;
  end;}

  TSDL_Surface = record
    flags: UInt32; // Read-only
    format: PSDL_PixelFormat; // Read-only
    w, h: Integer; // Read-only
    pitch: UInt16; // Read-only
    pixels: Pointer; // Read-write
    offset: Integer; // Private
    hwdata: Pointer; //TPrivate_hwdata;  Hardware-specific surface info

    // clipping information:
    clip_rect: TSDL_Rect; // Read-only
    unused1: UInt32; // for binary compatibility
    // Allow recursive locks
    locked: UInt32; // Private
    // info for fast blit mapping to other surfaces
    Blitmap: Pointer; // PSDL_BlitMap; //   Private
    // format version, bumped at every change to invalidate blit maps
    format_version: Cardinal; // Private
    refcount: Integer;
  end;

  // Useful for determining the video hardware capabilities
  PSDL_VideoInfo = ^TSDL_VideoInfo;
  TSDL_VideoInfo = record
    hw_available: UInt8; // Hardware and WindowManager flags in first 2 bits ( see below )
    {hw_available: 1; // Can you create hardware surfaces
    wm_available: 1; // Can you talk to a window manager?
    UnusedBits1: 6;}
    blit_hw: UInt8; // Blit Hardware flags. See below for which bits do what
    {UnusedBits2: 1;
    blit_hw: 1; // Flag:UInt32  Accelerated blits HW --> HW
    blit_hw_CC: 1; // Flag:UInt32  Accelerated blits with Colorkey
    blit_hw_A: 1; // Flag:UInt32  Accelerated blits with Alpha
    blit_sw: 1; // Flag:UInt32  Accelerated blits SW --> HW
    blit_sw_CC: 1; // Flag:UInt32  Accelerated blits with Colorkey
    blit_sw_A: 1; // Flag:UInt32  Accelerated blits with Alpha
    blit_fill: 1; // Flag:UInt32  Accelerated color fill}
    UnusedBits3: UInt8; // Unused at this point
    video_mem: UInt32; // The total amount of video memory (in K)
    vfmt: PSDL_PixelFormat; // Value: The format of the video surface
    current_w : SInt32;	// Value: The current video mode width
	  current_h : SInt32;	// Value: The current video mode height
  end;

  // The YUV hardware video overlay
  PSDL_Overlay = ^TSDL_Overlay;
  TSDL_Overlay = record
    format: UInt32; // Overlay format
    w, h: Integer; // Width and height of overlay
    planes: Integer; // Number of planes in the overlay. Usually either 1 or 3
    pitches: PUInt16;
      // An array of pitches, one for each plane. Pitch is the length of a row in bytes.
    pixels: PPUInt8;
      // An array of pointers to the data of each plane. The overlay should be locked before these pointers are used.
    hw_overlay: UInt32;
      // This will be set to 1 if the overlay is hardware accelerated.
  end;

  // Public enumeration for setting the OpenGL window attributes.
  TSDL_GLAttr = (
    SDL_GL_RED_SIZE,
    SDL_GL_GREEN_SIZE,
    SDL_GL_BLUE_SIZE,
    SDL_GL_ALPHA_SIZE,
    SDL_GL_BUFFER_SIZE,
    SDL_GL_DOUBLEBUFFER,
    SDL_GL_DEPTH_SIZE,
    SDL_GL_STENCIL_SIZE,
    SDL_GL_ACCUM_RED_SIZE,
    SDL_GL_ACCUM_GREEN_SIZE,
    SDL_GL_ACCUM_BLUE_SIZE,
    SDL_GL_ACCUM_ALPHA_SIZE,
    SDL_GL_STEREO,
    SDL_GL_MULTISAMPLEBUFFERS,
    SDL_GL_MULTISAMPLESAMPLES,
    SDL_GL_ACCELERATED_VISUAL,
    SDL_GL_SWAP_CONTROL);



  PSDL_Cursor = ^TSDL_Cursor;
  TSDL_Cursor = record
    area: TSDL_Rect; // The area of the mouse cursor
    hot_x, hot_y: SInt16; // The "tip" of the cursor
    data: PUInt8; // B/W cursor data
    mask: PUInt8; // B/W cursor mask
    save: array[1..2] of PUInt8; // Place to save cursor area
    wm_cursor: Pointer; // Window-manager cursor
  end;

// SDL_mutex.h types

{$IFDEF WINDOWS}
  PSDL_Mutex = ^TSDL_Mutex;
  TSDL_Mutex = record
    id: THANDLE;
  end;
{$ENDIF}

{$IFDEF Unix}
  PSDL_Mutex = ^TSDL_Mutex;
  TSDL_mutex = record
    id: pthread_mutex_t;
{$IFDEF PTHREAD_NO_RECURSIVE_MUTEX}
    recursive: Integer;
    owner: pthread_t;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF NDS}
  PSDL_mutex = ^TSDL_Mutex;
  TSDL_Mutex = record
    recursive: Integer;
    Owner: UInt32;
    sem: PSDL_sem;
  end;
{$ENDIF}

{$IFDEF __MACH__}
  {$define USE_NAMED_SEMAPHORES}
  // Broken sem_getvalue() in MacOS X Public Beta */
  {$define BROKEN_SEMGETVALUE}
{$ENDIF}

PSDL_semaphore = ^TSDL_semaphore;
{$IFDEF WINDOWS}
  // WINDOWS or Machintosh
  TSDL_semaphore = record
    id: THANDLE;
    count: UInt32;
  end;
{$ELSE}
  {$IFDEF FPC}
  // This should be semaphore.h 
  __sem_lock_t = {packed} record { Not in header file - anonymous }
    status: Longint;
    spinlock: Integer;
  end;

  sem_t = {packed} record
    __sem_lock: __sem_lock_t;
    __sem_value: Integer;
    __sem_waiting: longint ; {_pthread_queue;}
  end;
  {$ENDIF}
  
  TSDL_semaphore = record
    sem: Pointer; //PSem_t;
  {$IFNDEF USE_NAMED_SEMAPHORES}
    sem_data: Sem_t;
  {$ENDIF}

  {$IFDEF BROKEN_SEMGETVALUE}
    { This is a little hack for MacOS X -
      It's not thread-safe, but it's better than nothing }
    sem_value: Integer;
  {$ENDIF}
  end;
{$ENDIF}

  PSDL_Sem = ^TSDL_Sem;
  TSDL_Sem = TSDL_Semaphore;

  PSDL_Cond = ^TSDL_Cond;
  TSDL_Cond = record
{$IFDEF Unix}
    cond: pthread_cond_t;
{$ELSE}
    // Generic Cond structure
    lock: PSDL_mutex;
    waiting: Integer;
    signals: Integer;
    wait_sem: PSDL_Sem;
    wait_done: PSDL_Sem;
{$ENDIF}
  end;

  // SDL_thread.h types
{$IFDEF WINDOWS}
  TSYS_ThreadHandle = THandle;
{$ENDIF}

{$IFDEF Unix}
  TSYS_ThreadHandle = pthread_t;
{$ENDIF}

{$IFDEF NDS}
  TSYS_ThreadHandle = Integer;
{$ENDIF}

  { This is the system-independent thread info structure }
  PSDL_Thread = ^TSDL_Thread;
  TSDL_Thread = record
    threadid: UInt32;
    handle: TSYS_ThreadHandle;
    status: Integer;
    errbuf: TSDL_Error;
    data: Pointer;
  end;

  // Helper Types

  // Keyboard  State Array ( See demos for how to use )
  PKeyStateArr = ^TKeyStateArr;
  TKeyStateArr = array[0..65000] of UInt8;

  // Types required so we don't need to use Windows.pas
  PInteger = ^Integer;
  PByte = ^Byte;
  PWord = ^Word;
  PLongWord = ^Longword;

  // General arrays
  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of Byte;

  PWordArray = ^TWordArray;
  TWordArray = array[0..16383] of Word;

  PPoint = ^TPoint;
  {$IFDEF HAS_TYPES}
  TPoint = Types.TPoint;
  {$ELSE}
    {$IFDEF WINDOWS}
      {$IFDEF __GPC__}
      TPoint = wintypes.TPoint;
      {$ELSE}
      TPoint = Windows.TPoint;
      {$ENDIF}
    {$ELSE}
      //Can't define TPoint : neither Types nor Windows unit available.
    {$ENDIF}
  {$ENDIF}

  PRect = ^TRect;
  {$IFDEF HAS_TYPES}
  TRect = Types.TRect;
  {$ELSE}
    {$IFDEF WINDOWS}
      {$IFDEF __GPC__}
      TRect = wintypes.TRect;
      {$ELSE}
      TRect = Windows.TRect;
      {$ENDIF}
    {$ELSE}
      //Can't define TRect: neither Types nor Windows unit available.
    {$ENDIF}
  {$ENDIF}

  { Generic procedure pointer }
  TProcedure = procedure;

{------------------------------------------------------------------------------}
{ initialization                                                               }
{------------------------------------------------------------------------------}

{ This function loads the SDL dynamically linked library and initializes
  the subsystems specified by 'flags' (and those satisfying dependencies)
  Unless the SDL_INIT_NOPARACHUTE flag is set, it will install cleanup
  signal handlers for some commonly ignored fatal signals (like SIGSEGV) }

function SDL_Init( flags : UInt32 ) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Init'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_Init}

// This function initializes specific SDL subsystems
function SDL_InitSubSystem( flags : UInt32 ) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_InitSubSystem'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_InitSubSystem}

// This function cleans up specific SDL subsystems
procedure SDL_QuitSubSystem( flags : UInt32 );
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_QuitSubSystem'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_QuitSubSystem}

{ This function returns mask of the specified subsystems which have
  been initialized.
  If 'flags' is 0, it returns a mask of all initialized subsystems. }

function SDL_WasInit( flags : UInt32 ): UInt32;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WasInit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WasInit}

{ This function cleans up all initialized subsystems and unloads the
  dynamically linked library.  You should call it upon all exit conditions. }
procedure SDL_Quit;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Quit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_Quit}

{$IFDEF WINDOWS}
// This should be called from your WinMain() function, if any
function SDL_RegisterApp(name: PAnsiChar; style: UInt32; h_Inst: Pointer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_RegisterApp'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_RegisterApp}
{$ENDIF}

{$IFDEF __MACH__}
// This should be called from your main() function, if any
procedure SDL_InitQuickDraw( the_qd: QDGlobals );
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_InitQuickDraw'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_InitQuickDraw}
{$ENDIF}


{------------------------------------------------------------------------------}
{ types }
{------------------------------------------------------------------------------}
// The number of elements in a table
function SDL_TableSize( table: PAnsiChar ): Integer;
{$EXTERNALSYM SDL_TABLESIZE}


{------------------------------------------------------------------------------}
{ error-handling }
{------------------------------------------------------------------------------}
// Public functions
function SDL_GetError: PAnsiChar;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetError'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetError}
procedure SDL_SetError(fmt: PAnsiChar);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetError'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetError}
procedure SDL_ClearError;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_ClearError'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_ClearError}

{$IFNDEF WINDOWS}
procedure SDL_Error(Code: TSDL_errorcode);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Error'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_Error}
{$ENDIF}

// Private error message function - used internally
procedure SDL_OutOfMemory;

{------------------------------------------------------------------------------}
{ io handling                                                                  }
{------------------------------------------------------------------------------}
// Functions to create SDL_RWops structures from various data sources

function SDL_RWFromFile(filename, mode: PAnsiChar): PSDL_RWops;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_RWFromFile'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_RWFromFile}
procedure SDL_FreeRW(area: PSDL_RWops);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_FreeRW'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_FreeRW}

//fp:^FILE 
function SDL_RWFromFP(fp: Pointer; autoclose: Integer): PSDL_RWops;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_RWFromFP'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_RWFromFP}
function SDL_RWFromMem(mem: Pointer; size: Integer): PSDL_RWops;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_RWFromMem'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_RWFromMem}
function SDL_RWFromConstMem(const mem: Pointer; size: Integer) : PSDL_RWops;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_RWFromConstMem'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_RWFromConstMem}
function SDL_AllocRW: PSDL_RWops;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_AllocRW'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_AllocRW}

function SDL_RWSeek(context: PSDL_RWops; offset: Integer; whence: Integer) : Integer;
{$EXTERNALSYM SDL_RWSeek}
function SDL_RWTell(context: PSDL_RWops): Integer;
{$EXTERNALSYM SDL_RWTell}
function SDL_RWRead(context: PSDL_RWops; ptr: Pointer; size: Integer; n : Integer): Integer;
{$EXTERNALSYM SDL_RWRead}
function SDL_RWWrite(context: PSDL_RWops; ptr: Pointer; size: Integer; n : Integer): Integer;
{$EXTERNALSYM SDL_RWWrite}
function SDL_RWClose(context: PSDL_RWops): Integer;
{$EXTERNALSYM SDL_RWClose}

{------------------------------------------------------------------------------}
{ time-handling                                                                }
{------------------------------------------------------------------------------}

{ Get the number of milliseconds since the SDL library initialization. }
{ Note that this value wraps if the program runs for more than ~49 days. }
function SDL_GetTicks: UInt32;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetTicks'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetTicks}

// Wait a specified number of milliseconds before returning
procedure SDL_Delay(msec: UInt32);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Delay'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_Delay}

{ Add a new timer to the pool of timers already running. }
{ Returns a timer ID, or NULL when an error occurs.      }
function SDL_AddTimer(interval: UInt32; callback: TSDL_NewTimerCallback; param : Pointer): PSDL_TimerID;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_AddTimer'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_AddTimer}

{ Remove one of the multiple timers knowing its ID. }
{ Returns a boolean value indicating success. }
function SDL_RemoveTimer(t: PSDL_TimerID): TSDL_Bool;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_RemoveTimer'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_RemoveTimer}

function SDL_SetTimer(interval: UInt32; callback: TSDL_TimerCallback): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetTimer'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetTimer}

{------------------------------------------------------------------------------}
{ audio-routines                                                               }
{------------------------------------------------------------------------------}

{ These functions are used internally, and should not be used unless you
  have a specific need to specify the audio driver you want to use.
  You should normally use SDL_Init() or SDL_InitSubSystem(). }

function SDL_AudioInit(driver_name: PAnsiChar): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_AudioInit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_AudioInit}
procedure SDL_AudioQuit;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_AudioQuit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_AudioQuit}

{ This function fills the given character buffer with the name of the
  current audio driver, and returns a Pointer to it if the audio driver has
  been initialized.  It returns NULL if no driver has been initialized. }

function SDL_AudioDriverName(namebuf: PAnsiChar; maxlen: Integer): PAnsiChar;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_AudioDriverName'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_AudioDriverName}

{ This function opens the audio device with the desired parameters, and
  returns 0 if successful, placing the actual hardware parameters in the
  structure pointed to by 'obtained'.  If 'obtained' is NULL, the audio
  data passed to the callback function will be guaranteed to be in the
  requested format, and will be automatically converted to the hardware
  audio format if necessary.  This function returns -1 if it failed
  to open the audio device, or couldn't set up the audio thread.

  When filling in the desired audio spec structure,
   'desired->freq' should be the desired audio frequency in samples-per-second.
   'desired->format' should be the desired audio format.
   'desired->samples' is the desired size of the audio buffer, in samples.
      This number should be a power of two, and may be adjusted by the audio
      driver to a value more suitable for the hardware.  Good values seem to
      range between 512 and 8096 inclusive, depending on the application and
      CPU speed.  Smaller values yield faster response time, but can lead
      to underflow if the application is doing heavy processing and cannot
      fill the audio buffer in time.  A stereo sample consists of both right
      and left channels in LR ordering.
      Note that the number of samples is directly related to time by the
      following formula:  ms = (samples*1000)/freq
   'desired->size' is the size in bytes of the audio buffer, and is
      calculated by SDL_OpenAudio().
   'desired->silence' is the value used to set the buffer to silence,
      and is calculated by SDL_OpenAudio().
   'desired->callback' should be set to a function that will be called
      when the audio device is ready for more data.  It is passed a pointer
      to the audio buffer, and the length in bytes of the audio buffer.
      This function usually runs in a separate thread, and so you should
      protect data structures that it accesses by calling SDL_LockAudio()
      and SDL_UnlockAudio() in your code.
   'desired->userdata' is passed as the first parameter to your callback
      function.

  The audio device starts out playing silence when it's opened, and should
  be enabled for playing by calling SDL_PauseAudio(0) when you are ready
  for your audio callback function to be called.  Since the audio driver
  may modify the requested size of the audio buffer, you should allocate
  any local mixing buffers after you open the audio device. }

function SDL_OpenAudio(desired, obtained: PSDL_AudioSpec): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_OpenAudio'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_OpenAudio}

{ Get the current audio state: }
function SDL_GetAudioStatus: TSDL_Audiostatus;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetAudioStatus'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetAudioStatus}

{ This function pauses and unpauses the audio callback processing.
  It should be called with a parameter of 0 after opening the audio
  device to start playing sound.  This is so you can safely initialize
  data for your callback function after opening the audio device.
  Silence will be written to the audio device during the pause. }

procedure SDL_PauseAudio(pause_on: Integer);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_PauseAudio'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_PauseAudio}

{ This function loads a WAVE from the data source, automatically freeing
  that source if 'freesrc' is non-zero.  For example, to load a WAVE file,
  you could do:
  SDL_LoadWAV_RW(SDL_RWFromFile("sample.wav", "rb"), 1, ...);

  If this function succeeds, it returns the given SDL_AudioSpec,
  filled with the audio data format of the wave data, and sets
  'audio_buf' to a malloc()'d buffer containing the audio data,
  and sets 'audio_len' to the length of that audio buffer, in bytes.
  You need to free the audio buffer with SDL_FreeWAV() when you are
  done with it.

  This function returns NULL and sets the SDL error message if the
  wave file cannot be opened, uses an unknown data format, or is
  corrupt.  Currently raw and MS-ADPCM WAVE files are supported. }

function SDL_LoadWAV_RW(src: PSDL_RWops; freesrc: Integer; spec:
  PSDL_AudioSpec; audio_buf: PUInt8; audiolen: PUInt32): PSDL_AudioSpec;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LoadWAV_RW'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LoadWAV_RW}

// Compatibility convenience function -- loads a WAV from a file
function SDL_LoadWAV(filename: PAnsiChar; spec: PSDL_AudioSpec; audio_buf:
  PUInt8; audiolen: PUInt32): PSDL_AudioSpec;
{$EXTERNALSYM SDL_LoadWAV}

{ This function frees data previously allocated with SDL_LoadWAV_RW() }

procedure SDL_FreeWAV(audio_buf: PUInt8);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_FreeWAV'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_FreeWAV}

{ This function takes a source format and rate and a destination format
  and rate, and initializes the 'cvt' structure with information needed
  by SDL_ConvertAudio() to convert a buffer of audio data from one format
  to the other.
  This function returns 0, or -1 if there was an error. }
function SDL_BuildAudioCVT(cvt: PSDL_AudioCVT; src_format: UInt16;
  src_channels: UInt8; src_rate: Integer; dst_format: UInt16; dst_channels: UInt8;
  dst_rate: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_BuildAudioCVT'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_BuildAudioCVT}

{ Once you have initialized the 'cvt' structure using SDL_BuildAudioCVT(),
  created an audio buffer cvt->buf, and filled it with cvt->len bytes of
  audio data in the source format, this function will convert it in-place
  to the desired format.
  The data conversion may expand the size of the audio data, so the buffer
  cvt->buf should be allocated after the cvt structure is initialized by
  SDL_BuildAudioCVT(), and should be cvt->len*cvt->len_mult bytes long. }
function SDL_ConvertAudio(cvt: PSDL_AudioCVT): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_ConvertAudio'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_ConvertAudio}

{ This takes two audio buffers of the playing audio format and mixes
  them, performing addition, volume adjustment, and overflow clipping.
  The volume ranges from 0 - 128, and should be set to SDL_MIX_MAXVOLUME
  for full audio volume.  Note this does not change hardware volume.
  This is provided for convenience -- you can mix your own audio data. }

procedure SDL_MixAudio(dst, src: PUInt8; len: UInt32; volume: Integer);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_MixAudio'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_MixAudio}

{ The lock manipulated by these functions protects the callback function.
  During a LockAudio/UnlockAudio pair, you can be guaranteed that the
  callback function is not running.  Do not call these from the callback
  function or you will cause deadlock. }
procedure SDL_LockAudio;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LockAudio'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LockAudio}
procedure SDL_UnlockAudio;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_UnlockAudio'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_UnlockAudio}

{ This function shuts down audio processing and closes the audio device. }

procedure SDL_CloseAudio;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CloseAudio'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CloseAudio}

{------------------------------------------------------------------------------}
{ CD-routines }
{------------------------------------------------------------------------------}

{ Returns the number of CD-ROM drives on the system, or -1 if
  SDL_Init() has not been called with the SDL_INIT_CDROM flag. }

function SDL_CDNumDrives: Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDNumDrives'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDNumDrives}

{ Returns a human-readable, system-dependent identifier for the CD-ROM.
   Example:
   "/dev/cdrom"
   "E:"
   "/dev/disk/ide/1/master" }

function SDL_CDName(drive: Integer): PAnsiChar;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDName'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDName}

{ Opens a CD-ROM drive for access.  It returns a drive handle on success,
  or NULL if the drive was invalid or busy.  This newly opened CD-ROM
  becomes the default CD used when other CD functions are passed a NULL
  CD-ROM handle.
  Drives are numbered starting with 0.  Drive 0 is the system default CD-ROM. }

function SDL_CDOpen(drive: Integer): PSDL_CD;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDOpen'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDOpen}

{ This function returns the current status of the given drive.
  If the drive has a CD in it, the table of contents of the CD and current
  play position of the CD will be stored in the SDL_CD structure. }

function SDL_CDStatus(cdrom: PSDL_CD): TSDL_CDStatus;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDStatus'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDStatus}

{  Play the given CD starting at 'start_track' and 'start_frame' for 'ntracks'
   tracks and 'nframes' frames.  If both 'ntrack' and 'nframe' are 0, play
   until the end of the CD.  This function will skip data tracks.
   This function should only be called after calling SDL_CDStatus() to
   get track information about the CD.

   For example:
   // Play entire CD:
  if ( CD_INDRIVE(SDL_CDStatus(cdrom)) ) then
    SDL_CDPlayTracks(cdrom, 0, 0, 0, 0);
   // Play last track:
   if ( CD_INDRIVE(SDL_CDStatus(cdrom)) ) then
   begin
    SDL_CDPlayTracks(cdrom, cdrom->numtracks-1, 0, 0, 0);
   end;

   // Play first and second track and 10 seconds of third track:
   if ( CD_INDRIVE(SDL_CDStatus(cdrom)) )
    SDL_CDPlayTracks(cdrom, 0, 0, 2, 10);

   This function returns 0, or -1 if there was an error. }

function SDL_CDPlayTracks(cdrom: PSDL_CD; start_track: Integer; start_frame:
  Integer; ntracks: Integer; nframes: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDPlayTracks'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDPlayTracks}


{  Play the given CD starting at 'start' frame for 'length' frames.
   It returns 0, or -1 if there was an error. }

function SDL_CDPlay(cdrom: PSDL_CD; start: Integer; length: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDPlay'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDPlay}

// Pause play -- returns 0, or -1 on error
function SDL_CDPause(cdrom: PSDL_CD): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDPause'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDPause}

// Resume play -- returns 0, or -1 on error
function SDL_CDResume(cdrom: PSDL_CD): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDResume'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDResume}

// Stop play -- returns 0, or -1 on error
function SDL_CDStop(cdrom: PSDL_CD): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDStop'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDStop}

// Eject CD-ROM -- returns 0, or -1 on error
function SDL_CDEject(cdrom: PSDL_CD): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDEject'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDEject}

// Closes the handle for the CD-ROM drive
procedure SDL_CDClose(cdrom: PSDL_CD);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CDClose'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CDClose}

// Given a status, returns true if there's a disk in the drive
function SDL_CDInDrive( status : TSDL_CDStatus ) : LongBool;
{$EXTERNALSYM SDL_CDInDrive}

// Conversion functions from frames to Minute/Second/Frames and vice versa
procedure FRAMES_TO_MSF(frames: Integer; var M: Integer; var S: Integer; var
  F: Integer);
{$EXTERNALSYM FRAMES_TO_MSF}
function MSF_TO_FRAMES(M: Integer; S: Integer; F: Integer): Integer;
{$EXTERNALSYM MSF_TO_FRAMES}

{------------------------------------------------------------------------------}
{ JoyStick-routines                                                            }
{------------------------------------------------------------------------------}

{ Count the number of joysticks attached to the system }
function SDL_NumJoysticks: Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_NumJoysticks'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_NumJoysticks}

{ Get the implementation dependent name of a joystick.
  This can be called before any joysticks are opened.
  If no name can be found, this function returns NULL. }
function SDL_JoystickName(index: Integer): PAnsiChar;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickName'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickName}

{ Open a joystick for use - the index passed as an argument refers to
  the N'th joystick on the system.  This index is the value which will
  identify this joystick in future joystick events.

  This function returns a joystick identifier, or NULL if an error occurred. }
function SDL_JoystickOpen(index: Integer): PSDL_Joystick;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickOpen'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickOpen}

{ Returns 1 if the joystick has been opened, or 0 if it has not. }
function SDL_JoystickOpened(index: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickOpened'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickOpened}

{ Get the device index of an opened joystick. }
function SDL_JoystickIndex(joystick: PSDL_Joystick): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickIndex'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickIndex}

{ Get the number of general axis controls on a joystick }
function SDL_JoystickNumAxes(joystick: PSDL_Joystick): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickNumAxes'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickNumAxes}

{ Get the number of trackballs on a joystick
  Joystick trackballs have only relative motion events associated
  with them and their state cannot be polled. }
function SDL_JoystickNumBalls(joystick: PSDL_Joystick): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickNumBalls'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickNumBalls}


{ Get the number of POV hats on a joystick }
function SDL_JoystickNumHats(joystick: PSDL_Joystick): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickNumHats'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickNumHats}

{ Get the number of buttons on a joystick }
function SDL_JoystickNumButtons(joystick: PSDL_Joystick): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickNumButtons'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickNumButtons}

{ Update the current state of the open joysticks.
  This is called automatically by the event loop if any joystick
  events are enabled. }

procedure SDL_JoystickUpdate;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickUpdate'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickUpdate;}

{ Enable/disable joystick event polling.
  If joystick events are disabled, you must call SDL_JoystickUpdate()
  yourself and check the state of the joystick when you want joystick
  information.
  The state can be one of SDL_QUERY, SDL_ENABLE or SDL_IGNORE. }

function SDL_JoystickEventState(state: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickEventState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickEventState}

{ Get the current state of an axis control on a joystick
  The state is a value ranging from -32768 to 32767.
  The axis indices start at index 0. }

function SDL_JoystickGetAxis(joystick: PSDL_Joystick; axis: Integer) : SInt16;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickGetAxis'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickGetAxis}

{ The hat indices start at index 0. }

function SDL_JoystickGetHat(joystick: PSDL_Joystick; hat: Integer): UInt8;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickGetHat'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickGetHat}

{ Get the ball axis change since the last poll
  This returns 0, or -1 if you passed it invalid parameters.
  The ball indices start at index 0. }

function SDL_JoystickGetBall(joystick: PSDL_Joystick; ball: Integer; var dx: Integer; var dy: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickGetBall'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickGetBall}

{ Get the current state of a button on a joystick
  The button indices start at index 0. }
function SDL_JoystickGetButton( joystick: PSDL_Joystick; Button: Integer): UInt8;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickGetButton'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickGetButton}

{ Close a joystick previously opened with SDL_JoystickOpen() }
procedure SDL_JoystickClose(joystick: PSDL_Joystick);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_JoystickClose'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_JoystickClose}

{------------------------------------------------------------------------------}
{ event-handling }
{------------------------------------------------------------------------------}

{ Pumps the event loop, gathering events from the input devices.
  This function updates the event queue and internal input device state.
  This should only be run in the thread that sets the video mode. }

procedure SDL_PumpEvents;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_PumpEvents'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_PumpEvents;}

{ Checks the event queue for messages and optionally returns them.
  If 'action' is SDL_ADDEVENT, up to 'numevents' events will be added to
  the back of the event queue.
  If 'action' is SDL_PEEKEVENT, up to 'numevents' events at the front
  of the event queue, matching 'mask', will be returned and will not
  be removed from the queue.
  If 'action' is SDL_GETEVENT, up to 'numevents' events at the front
  of the event queue, matching 'mask', will be returned and will be
  removed from the queue.
  This function returns the number of events actually stored, or -1
  if there was an error.  This function is thread-safe. }

function SDL_PeepEvents(events: PSDL_Event; numevents: Integer; action: TSDL_eventaction; mask: UInt32): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_PeepEvents'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_PeepEvents}

{ Polls for currently pending events, and returns 1 if there are any pending
   events, or 0 if there are none available.  If 'event' is not NULL, the next
   event is removed from the queue and stored in that area. }

function SDL_PollEvent(event: PSDL_Event): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_PollEvent'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_PollEvent}

{  Waits indefinitely for the next available event, returning 1, or 0 if there
   was an error while waiting for events.  If 'event' is not NULL, the next
   event is removed from the queue and stored in that area. }

function SDL_WaitEvent(event: PSDL_Event): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WaitEvent'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WaitEvent}

function SDL_PushEvent( event : PSDL_Event ) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_PushEvent'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_PushEvent}

{ If the filter returns 1, then the event will be added to the internal queue.
  If it returns 0, then the event will be dropped from the queue, but the
  internal state will still be updated.  This allows selective filtering of
  dynamically arriving events.

  WARNING:  Be very careful of what you do in the event filter function, as
            it may run in a different thread!

  There is one caveat when dealing with the SDL_QUITEVENT event type.  The
  event filter is only called when the window manager desires to close the
  application window.  If the event filter returns 1, then the window will
  be closed, otherwise the window will remain open if possible.
  If the quit event is generated by an interrupt signal, it will bypass the
  internal queue and be delivered to the application at the next event poll. }
procedure SDL_SetEventFilter( filter : TSDL_EventFilter );
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetEventFilter'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetEventFilter}

{ Return the current event filter - can be used to "chain" filters.
  If there is no event filter set, this function returns NULL. }

function SDL_GetEventFilter: TSDL_EventFilter;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetEventFilter'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetEventFilter}

{ This function allows you to set the state of processing certain events.
  If 'state' is set to SDL_IGNORE, that event will be automatically dropped
  from the event queue and will not event be filtered.
  If 'state' is set to SDL_ENABLE, that event will be processed normally.
  If 'state' is set to SDL_QUERY, SDL_EventState() will return the
  current processing state of the specified event. }

function SDL_EventState(type_: UInt8; state: Integer): UInt8;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_EventState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_EventState}

{------------------------------------------------------------------------------}
{ Version Routines }
{------------------------------------------------------------------------------}

{ This macro can be used to fill a version structure with the compile-time
  version of the SDL library. }
procedure SDL_VERSION(var X: TSDL_Version);
{$EXTERNALSYM SDL_VERSION}

{ This macro turns the version numbers into a numeric value:
   (1,2,3) -> (1203)
   This assumes that there will never be more than 100 patchlevels }

function SDL_VERSIONNUM(X, Y, Z: Integer): Integer;
{$EXTERNALSYM SDL_VERSIONNUM}

// This is the version number macro for the current SDL version
function SDL_COMPILEDVERSION: Integer;
{$EXTERNALSYM SDL_COMPILEDVERSION}

// This macro will evaluate to true if compiled with SDL at least X.Y.Z
function SDL_VERSION_ATLEAST(X: Integer; Y: Integer; Z: Integer) : LongBool;
{$EXTERNALSYM SDL_VERSION_ATLEAST}

{ This function gets the version of the dynamically linked SDL library.
  it should NOT be used to fill a version structure, instead you should
  use the SDL_Version() macro. }

function SDL_Linked_Version: PSDL_version;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Linked_Version'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_Linked_Version}

{------------------------------------------------------------------------------}
{ video                                                                        }
{------------------------------------------------------------------------------}

{ These functions are used internally, and should not be used unless you
  have a specific need to specify the video driver you want to use.
  You should normally use SDL_Init() or SDL_InitSubSystem().

  SDL_VideoInit() initializes the video subsystem -- sets up a connection
  to the window manager, etc, and determines the current video mode and
  pixel format, but does not initialize a window or graphics mode.
  Note that event handling is activated by this routine.

  If you use both sound and video in your application, you need to call
  SDL_Init() before opening the sound device, otherwise under Win32 DirectX,
  you won't be able to set full-screen display modes. }

function SDL_VideoInit(driver_name: PAnsiChar; flags: UInt32): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_VideoInit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_VideoInit}
procedure SDL_VideoQuit;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_VideoQuit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_VideoQuit}

{ This function fills the given character buffer with the name of the
  video driver, and returns a pointer to it if the video driver has
  been initialized.  It returns NULL if no driver has been initialized. }

function SDL_VideoDriverName(namebuf: PAnsiChar; maxlen: Integer): PAnsiChar;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_VideoDriverName'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_VideoDriverName}

{ This function returns a pointer to the current display surface.
  If SDL is doing format conversion on the display surface, this
  function returns the publicly visible surface, not the real video
  surface. }

function SDL_GetVideoSurface: PSDL_Surface;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetVideoSurface'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetVideoSurface}

{ This function returns a read-only pointer to information about the
  video hardware.  If this is called before SDL_SetVideoMode(), the 'vfmt'
  member of the returned structure will contain the pixel format of the
  "best" video mode. }
function SDL_GetVideoInfo: PSDL_VideoInfo;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetVideoInfo'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetVideoInfo}

{ Check to see if a particular video mode is supported.
  It returns 0 if the requested mode is not supported under any bit depth,
  or returns the bits-per-pixel of the closest available mode with the
  given width and height.  If this bits-per-pixel is different from the
  one used when setting the video mode, SDL_SetVideoMode() will succeed,
  but will emulate the requested bits-per-pixel with a shadow surface.

  The arguments to SDL_VideoModeOK() are the same ones you would pass to
  SDL_SetVideoMode() }

function SDL_VideoModeOK(width, height, bpp: Integer; flags: UInt32): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_VideoModeOK'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_VideoModeOK}

{ Return a pointer to an array of available screen dimensions for the
  given format and video flags, sorted largest to smallest.  Returns
  NULL if there are no dimensions available for a particular format,
  or (SDL_Rect **)-1 if any dimension is okay for the given format.

  if 'format' is NULL, the mode list will be for the format given
  by SDL_GetVideoInfo( ) - > vfmt }

function SDL_ListModes(format: PSDL_PixelFormat; flags: UInt32): PPSDL_Rect;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_ListModes'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_ListModes}


{ Set up a video mode with the specified width, height and bits-per-pixel.

  If 'bpp' is 0, it is treated as the current display bits per pixel.

  If SDL_ANYFORMAT is set in 'flags', the SDL library will try to set the
  requested bits-per-pixel, but will return whatever video pixel format is
  available.  The default is to emulate the requested pixel format if it
  is not natively available.

  If SDL_HWSURFACE is set in 'flags', the video surface will be placed in
  video memory, if possible, and you may have to call SDL_LockSurface()
  in order to access the raw framebuffer.  Otherwise, the video surface
  will be created in system memory.

  If SDL_ASYNCBLIT is set in 'flags', SDL will try to perform rectangle
  updates asynchronously, but you must always lock before accessing pixels.
  SDL will wait for updates to complete before returning from the lock.

  If SDL_HWPALETTE is set in 'flags', the SDL library will guarantee
  that the colors set by SDL_SetColors() will be the colors you get.
  Otherwise, in 8-bit mode, SDL_SetColors() may not be able to set all
  of the colors exactly the way they are requested, and you should look
  at the video surface structure to determine the actual palette.
  If SDL cannot guarantee that the colors you request can be set,
  i.e. if the colormap is shared, then the video surface may be created
  under emulation in system memory, overriding the SDL_HWSURFACE flag.

  If SDL_FULLSCREEN is set in 'flags', the SDL library will try to set
  a fullscreen video mode.  The default is to create a windowed mode
  if the current graphics system has a window manager.
  If the SDL library is able to set a fullscreen video mode, this flag
  will be set in the surface that is returned.

  If SDL_DOUBLEBUF is set in 'flags', the SDL library will try to set up
  two surfaces in video memory and swap between them when you call
  SDL_Flip().  This is usually slower than the normal single-buffering
  scheme, but prevents "tearing" artifacts caused by modifying video
  memory while the monitor is refreshing.  It should only be used by
  applications that redraw the entire screen on every update.

  This function returns the video framebuffer surface, or NULL if it fails. }

function SDL_SetVideoMode(width, height, bpp: Integer; flags: UInt32): PSDL_Surface;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetVideoMode'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetVideoMode}


{ Makes sure the given list of rectangles is updated on the given screen.
  If 'x', 'y', 'w' and 'h' are all 0, SDL_UpdateRect will update the entire
  screen.
  These functions should not be called while 'screen' is locked. }

procedure SDL_UpdateRects(screen: PSDL_Surface; numrects: Integer; rects: PSDL_Rect);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_UpdateRects'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_UpdateRects}
procedure SDL_UpdateRect(screen: PSDL_Surface; x, y: SInt32; w, h: UInt32);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_UpdateRect'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_UpdateRect}


{ On hardware that supports double-buffering, this function sets up a flip
  and returns.  The hardware will wait for vertical retrace, and then swap
  video buffers before the next video surface blit or lock will return.
  On hardware that doesn not support double-buffering, this is equivalent
  to calling SDL_UpdateRect(screen, 0, 0, 0, 0);
  The SDL_DOUBLEBUF flag must have been passed to SDL_SetVideoMode() when
  setting the video mode for this function to perform hardware flipping.
  This function returns 0 if successful, or -1 if there was an error.}

function SDL_Flip(screen: PSDL_Surface): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Flip'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_Flip}

{ Set the gamma correction for each of the color channels.
  The gamma values range (approximately) between 0.1 and 10.0

  If this function isn't supported directly by the hardware, it will
  be emulated using gamma ramps, if available.  If successful, this
  function returns 0, otherwise it returns -1. }

function SDL_SetGamma(redgamma: single; greengamma: single; bluegamma: single ): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetGamma'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetGamma}

{ Set the gamma translation table for the red, green, and blue channels
  of the video hardware.  Each table is an array of 256 16-bit quantities,
  representing a mapping between the input and output for that channel.
  The input is the index into the array, and the output is the 16-bit
  gamma value at that index, scaled to the output color precision.

  You may pass NULL for any of the channels to leave it unchanged.
  If the call succeeds, it will return 0.  If the display driver or
  hardware does not support gamma translation, or otherwise fails,
  this function will return -1. }

function SDL_SetGammaRamp( redtable: PUInt16; greentable: PUInt16; bluetable: PUInt16): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetGammaRamp'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetGammaRamp}

{ Retrieve the current values of the gamma translation tables.

  You must pass in valid pointers to arrays of 256 16-bit quantities.
  Any of the pointers may be NULL to ignore that channel.
  If the call succeeds, it will return 0.  If the display driver or
  hardware does not support gamma translation, or otherwise fails,
  this function will return -1. }

function SDL_GetGammaRamp( redtable: PUInt16; greentable: PUInt16; bluetable: PUInt16): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetGammaRamp'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetGammaRamp}

{ Sets a portion of the colormap for the given 8-bit surface.  If 'surface'
  is not a palettized surface, this function does nothing, returning 0.
  If all of the colors were set as passed to SDL_SetColors(), it will
  return 1.  If not all the color entries were set exactly as given,
  it will return 0, and you should look at the surface palette to
  determine the actual color palette.

  When 'surface' is the surface associated with the current display, the
  display colormap will be updated with the requested colors.  If
  SDL_HWPALETTE was set in SDL_SetVideoMode() flags, SDL_SetColors()
  will always return 1, and the palette is guaranteed to be set the way
  you desire, even if the window colormap has to be warped or run under
  emulation. }


function SDL_SetColors(surface: PSDL_Surface; colors: PSDL_Color; firstcolor : Integer; ncolors: Integer) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetColors'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetColors}

{ Sets a portion of the colormap for a given 8-bit surface.
  'flags' is one or both of:
  SDL_LOGPAL  -- set logical palette, which controls how blits are mapped
                 to/from the surface,
  SDL_PHYSPAL -- set physical palette, which controls how pixels look on
                 the screen
  Only screens have physical palettes. Separate change of physical/logical
  palettes is only possible if the screen has SDL_HWPALETTE set.

  The return value is 1 if all colours could be set as requested, and 0
  otherwise.

  SDL_SetColors() is equivalent to calling this function with
  flags = (SDL_LOGPAL or SDL_PHYSPAL). }

function SDL_SetPalette(surface: PSDL_Surface; flags: Integer; colors: PSDL_Color; firstcolor: Integer; ncolors: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetPalette'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetPalette}

{ Maps an RGB triple to an opaque pixel value for a given pixel format }
function SDL_MapRGB(format: PSDL_PixelFormat; r: UInt8; g: UInt8; b: UInt8) : UInt32;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_MapRGB'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_MapRGB}

{ Maps an RGBA quadruple to a pixel value for a given pixel format }
function SDL_MapRGBA(format: PSDL_PixelFormat; r: UInt8; g: UInt8; b: UInt8; a: UInt8): UInt32;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_MapRGBA'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_MapRGBA}

{ Maps a pixel value into the RGB components for a given pixel format }
procedure SDL_GetRGB(pixel: UInt32; fmt: PSDL_PixelFormat; r: PUInt8; g: PUInt8; b: PUInt8);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetRGB'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetRGB}

{ Maps a pixel value into the RGBA components for a given pixel format }
procedure SDL_GetRGBA(pixel: UInt32; fmt: PSDL_PixelFormat; r: PUInt8; g: PUInt8; b: PUInt8; a: PUInt8);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetRGBA'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetRGBA}

{ Allocate and free an RGB surface (must be called after SDL_SetVideoMode)
  If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
  If the depth is greater than 8 bits, the pixel format is set using the
  flags '[RGB]mask'.
  If the function runs out of memory, it will return NULL.

  The 'flags' tell what kind of surface to create.
  SDL_SWSURFACE means that the surface should be created in system memory.
  SDL_HWSURFACE means that the surface should be created in video memory,
  with the same format as the display surface.  This is useful for surfaces
  that will not change much, to take advantage of hardware acceleration
  when being blitted to the display surface.
  SDL_ASYNCBLIT means that SDL will try to perform asynchronous blits with
  this surface, but you must always lock it before accessing the pixels.
  SDL will wait for current blits to finish before returning from the lock.
  SDL_SRCCOLORKEY indicates that the surface will be used for colorkey blits.
  If the hardware supports acceleration of colorkey blits between
  two surfaces in video memory, SDL will try to place the surface in
  video memory. If this isn't possible or if there is no hardware
  acceleration available, the surface will be placed in system memory.
  SDL_SRCALPHA means that the surface will be used for alpha blits and
  if the hardware supports hardware acceleration of alpha blits between
  two surfaces in video memory, to place the surface in video memory
  if possible, otherwise it will be placed in system memory.
  If the surface is created in video memory, blits will be _much_ faster,
  but the surface format must be identical to the video surface format,
  and the only way to access the pixels member of the surface is to use
  the SDL_LockSurface() and SDL_UnlockSurface() calls.
  If the requested surface actually resides in video memory, SDL_HWSURFACE
  will be set in the flags member of the returned surface.  If for some
  reason the surface could not be placed in video memory, it will not have
  the SDL_HWSURFACE flag set, and will be created in system memory instead. }

function SDL_AllocSurface(flags: UInt32; width, height, depth: Integer;
  RMask, GMask, BMask, AMask: UInt32): PSDL_Surface;
{$EXTERNALSYM SDL_AllocSurface}

function SDL_CreateRGBSurface(flags: UInt32; width, height, depth: Integer; RMask, GMask, BMask, AMask: UInt32): PSDL_Surface;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateRGBSurface'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateRGBSurface}

function SDL_CreateRGBSurfaceFrom(pixels: Pointer; width, height, depth, pitch
  : Integer; RMask, GMask, BMask, AMask: UInt32): PSDL_Surface;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateRGBSurfaceFrom'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateRGBSurfaceFrom}

procedure SDL_FreeSurface(surface: PSDL_Surface);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_FreeSurface'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_FreeSurface}

function SDL_MustLock(Surface: PSDL_Surface): Boolean;
{$EXTERNALSYM SDL_MustLock}
{ SDL_LockSurface() sets up a surface for directly accessing the pixels.
  Between calls to SDL_LockSurface()/SDL_UnlockSurface(), you can write
  to and read from 'surface->pixels', using the pixel format stored in
  'surface->format'.  Once you are done accessing the surface, you should
  use SDL_UnlockSurface() to release it.

  Not all surfaces require locking.  If SDL_MUSTLOCK(surface) evaluates
  to 0, then you can read and write to the surface at any time, and the
  pixel format of the surface will not change.  In particular, if the
  SDL_HWSURFACE flag is not given when calling SDL_SetVideoMode(), you
  will not need to lock the display surface before accessing it.

  No operating system or library calls should be made between lock/unlock
  pairs, as critical system locks may be held during this time.

  SDL_LockSurface() returns 0, or -1 if the surface couldn't be locked. }
function SDL_LockSurface(surface: PSDL_Surface): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LockSurface'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LockSurface}

procedure SDL_UnlockSurface(surface: PSDL_Surface);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_UnlockSurface'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_UnlockSurface}

{ Load a surface from a seekable SDL data source (memory or file.)
  If 'freesrc' is non-zero, the source will be closed after being read.
  Returns the new surface, or NULL if there was an error.
  The new surface should be freed with SDL_FreeSurface(). }
function SDL_LoadBMP_RW(src: PSDL_RWops; freesrc: Integer): PSDL_Surface;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LoadBMP_RW'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LoadBMP_RW}

// Convenience macro -- load a surface from a file
function SDL_LoadBMP(filename: PAnsiChar): PSDL_Surface;
{$EXTERNALSYM SDL_LoadBMP}

{ Save a surface to a seekable SDL data source (memory or file.)
  If 'freedst' is non-zero, the source will be closed after being written.
  Returns 0 if successful or -1 if there was an error. }

function SDL_SaveBMP_RW(surface: PSDL_Surface; dst: PSDL_RWops; freedst: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SaveBMP_RW'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SaveBMP_RW}

// Convenience macro -- save a surface to a file
function SDL_SaveBMP(surface: PSDL_Surface; filename: PAnsiChar): Integer;
{$EXTERNALSYM SDL_SaveBMP}

{ Sets the color key (transparent pixel) in a blittable surface.
  If 'flag' is SDL_SRCCOLORKEY (optionally OR'd with SDL_RLEACCEL),
  'key' will be the transparent pixel in the source image of a blit.
  SDL_RLEACCEL requests RLE acceleration for the surface if present,
  and removes RLE acceleration if absent.
  If 'flag' is 0, this function clears any current color key.
  This function returns 0, or -1 if there was an error. }

function SDL_SetColorKey(surface: PSDL_Surface; flag, key: UInt32) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetColorKey'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetColorKey}

{ This function sets the alpha value for the entire surface, as opposed to
  using the alpha component of each pixel. This value measures the range
  of transparency of the surface, 0 being completely transparent to 255
  being completely opaque. An 'alpha' value of 255 causes blits to be
  opaque, the source pixels copied to the destination (the default). Note
  that per-surface alpha can be combined with colorkey transparency.

  If 'flag' is 0, alpha blending is disabled for the surface.
  If 'flag' is SDL_SRCALPHA, alpha blending is enabled for the surface.
  OR:ing the flag with SDL_RLEACCEL requests RLE acceleration for the
  surface; if SDL_RLEACCEL is not specified, the RLE accel will be removed. }


function SDL_SetAlpha(surface: PSDL_Surface; flag: UInt32; alpha: UInt8): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetAlpha'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetAlpha}

{ Sets the clipping rectangle for the destination surface in a blit.

  If the clip rectangle is NULL, clipping will be disabled.
  If the clip rectangle doesn't intersect the surface, the function will
  return SDL_FALSE and blits will be completely clipped.  Otherwise the
  function returns SDL_TRUE and blits to the surface will be clipped to
  the intersection of the surface area and the clipping rectangle.

  Note that blits are automatically clipped to the edges of the source
  and destination surfaces. }
procedure SDL_SetClipRect(surface: PSDL_Surface; rect: PSDL_Rect); cdecl;
external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetClipRect'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetClipRect}

{ Gets the clipping rectangle for the destination surface in a blit.
  'rect' must be a pointer to a valid rectangle which will be filled
  with the correct values. }
procedure SDL_GetClipRect(surface: PSDL_Surface; rect: PSDL_Rect); cdecl;
external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetClipRect'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetClipRect}

{ Creates a new surface of the specified format, and then copies and maps
  the given surface to it so the blit of the converted surface will be as
  fast as possible.  If this function fails, it returns NULL.

  The 'flags' parameter is passed to SDL_CreateRGBSurface() and has those
  semantics.  You can also pass SDL_RLEACCEL in the flags parameter and
  SDL will try to RLE accelerate colorkey and alpha blits in the resulting
  surface.

  This function is used internally by SDL_DisplayFormat(). }

function SDL_ConvertSurface(src: PSDL_Surface; fmt: PSDL_PixelFormat; flags: UInt32): PSDL_Surface;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_ConvertSurface'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_ConvertSurface}

{
  This performs a fast blit from the source surface to the destination
  surface.  It assumes that the source and destination rectangles are
  the same size.  If either 'srcrect' or 'dstrect' are NULL, the entire
  surface (src or dst) is copied.  The final blit rectangles are saved
  in 'srcrect' and 'dstrect' after all clipping is performed.
  If the blit is successful, it returns 0, otherwise it returns -1.
 
  The blit function should not be called on a locked surface.
 
  The blit semantics for surfaces with and without alpha and colorkey
  are defined as follows:
 
  RGBA->RGB:
      SDL_SRCALPHA set:
   alpha-blend (using alpha-channel).
   SDL_SRCCOLORKEY ignored.
      SDL_SRCALPHA not set:
   copy RGB.
   if SDL_SRCCOLORKEY set, only copy the pixels matching the
   RGB values of the source colour key, ignoring alpha in the
   comparison.
 
  RGB->RGBA:
      SDL_SRCALPHA set:
   alpha-blend (using the source per-surface alpha value);
   set destination alpha to opaque.
      SDL_SRCALPHA not set:
   copy RGB, set destination alpha to opaque.
      both:
   if SDL_SRCCOLORKEY set, only copy the pixels matching the
   source colour key.
 
  RGBA->RGBA:
      SDL_SRCALPHA set:
   alpha-blend (using the source alpha channel) the RGB values;
   leave destination alpha untouched. [Note: is this correct?]
   SDL_SRCCOLORKEY ignored.
      SDL_SRCALPHA not set:
   copy all of RGBA to the destination.
   if SDL_SRCCOLORKEY set, only copy the pixels matching the
   RGB values of the source colour key, ignoring alpha in the
   comparison.
 
  RGB->RGB:
      SDL_SRCALPHA set:
   alpha-blend (using the source per-surface alpha value).
      SDL_SRCALPHA not set:
   copy RGB.
      both:
   if SDL_SRCCOLORKEY set, only copy the pixels matching the
   source colour key.
 
  If either of the surfaces were in video memory, and the blit returns -2,
  the video memory was lost, so it should be reloaded with artwork and
  re-blitted:
  while ( SDL_BlitSurface(image, imgrect, screen, dstrect) = -2 ) do
  begin
  while ( SDL_LockSurface(image) < 0 ) do
   Sleep(10);
  -- Write image pixels to image->pixels --
  SDL_UnlockSurface(image);
 end;

  This happens under DirectX 5.0 when the system switches away from your
  fullscreen application.  The lock will also fail until you have access
  to the video memory again. }

{ You should call SDL_BlitSurface() unless you know exactly how SDL
   blitting works internally and how to use the other blit functions. }

function SDL_BlitSurface(src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): Integer;
{$EXTERNALSYM SDL_BlitSurface}

{  This is the public blit function, SDL_BlitSurface(), and it performs
   rectangle validation and clipping before passing it to SDL_LowerBlit() }
function SDL_UpperBlit(src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_UpperBlit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_UpperBlit}

{ This is a semi-private blit function and it performs low-level surface
  blitting only. }
function SDL_LowerBlit(src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LowerBlit'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LowerBlit}

{ This function performs a fast fill of the given rectangle with 'color'
  The given rectangle is clipped to the destination surface clip area
  and the final fill rectangle is saved in the passed in pointer.
  If 'dstrect' is NULL, the whole surface will be filled with 'color'
  The color should be a pixel of the format used by the surface, and
  can be generated by the SDL_MapRGB() function.
  This function returns 0 on success, or -1 on error. }

function SDL_FillRect(dst: PSDL_Surface; dstrect: PSDL_Rect; color: UInt32) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_FillRect'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_FillRect}

{ This function takes a surface and copies it to a new surface of the
  pixel format and colors of the video framebuffer, suitable for fast
  blitting onto the display surface.  It calls SDL_ConvertSurface()

  If you want to take advantage of hardware colorkey or alpha blit
  acceleration, you should set the colorkey and alpha value before
  calling this function.

  If the conversion fails or runs out of memory, it returns NULL }

function SDL_DisplayFormat(surface: PSDL_Surface): PSDL_Surface; cdecl;
external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_DisplayFormat'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_DisplayFormat}

{ This function takes a surface and copies it to a new surface of the
  pixel format and colors of the video framebuffer (if possible),
  suitable for fast alpha blitting onto the display surface.
  The new surface will always have an alpha channel.

  If you want to take advantage of hardware colorkey or alpha blit
  acceleration, you should set the colorkey and alpha value before
  calling this function.

  If the conversion fails or runs out of memory, it returns NULL }


function SDL_DisplayFormatAlpha(surface: PSDL_Surface): PSDL_Surface; cdecl;
external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_DisplayFormatAlpha'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_DisplayFormatAlpha}

//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
//* YUV video surface overlay functions                                       */
//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

{ This function creates a video output overlay
  Calling the returned surface an overlay is something of a misnomer because
  the contents of the display surface underneath the area where the overlay
  is shown is undefined - it may be overwritten with the converted YUV data. }

function SDL_CreateYUVOverlay(width: Integer; height: Integer; format: UInt32; display: PSDL_Surface): PSDL_Overlay;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateYUVOverlay'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateYUVOverlay}

// Lock an overlay for direct access, and unlock it when you are done
function SDL_LockYUVOverlay(Overlay: PSDL_Overlay): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LockYUVOverlay'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LockYUVOverlay}

procedure SDL_UnlockYUVOverlay(Overlay: PSDL_Overlay); cdecl;
external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_UnlockYUVOverlay'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_UnlockYUVOverlay}


{ Blit a video overlay to the display surface.
  The contents of the video surface underneath the blit destination are
  not defined.
  The width and height of the destination rectangle may be different from
  that of the overlay, but currently only 2x scaling is supported. }

function SDL_DisplayYUVOverlay(Overlay: PSDL_Overlay; dstrect: PSDL_Rect) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_DisplayYUVOverlay'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_DisplayYUVOverlay}

// Free a video overlay
procedure SDL_FreeYUVOverlay(Overlay: PSDL_Overlay);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_FreeYUVOverlay'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_FreeYUVOverlay}

{------------------------------------------------------------------------------}
{ OpenGL Routines                                                              }
{------------------------------------------------------------------------------}

{ Dynamically load a GL driver, if SDL is built with dynamic GL.

  SDL links normally with the OpenGL library on your system by default,
  but you can compile it to dynamically load the GL driver at runtime.
  If you do this, you need to retrieve all of the GL functions used in
  your program from the dynamic library using SDL_GL_GetProcAddress().

  This is disabled in default builds of SDL. }


function SDL_GL_LoadLibrary(filename: PAnsiChar): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_LoadLibrary'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_LoadLibrary}

{ Get the address of a GL function (for extension functions) }
function SDL_GL_GetProcAddress(procname: PAnsiChar) : Pointer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_GetProcAddress'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_GetProcAddress}

{ Set an attribute of the OpenGL subsystem before intialization. }
function SDL_GL_SetAttribute(attr: TSDL_GLAttr; value: Integer) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_SetAttribute'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_SetAttribute}

{ Get an attribute of the OpenGL subsystem from the windowing
  interface, such as glX. This is of course different from getting
  the values from SDL's internal OpenGL subsystem, which only
  stores the values you request before initialization.

  Developers should track the values they pass into SDL_GL_SetAttribute
  themselves if they want to retrieve these values. }

function SDL_GL_GetAttribute(attr: TSDL_GLAttr; var value: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_GetAttribute'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_GetAttribute}

{ Swap the OpenGL buffers, if double-buffering is supported. }

procedure SDL_GL_SwapBuffers;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_SwapBuffers'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_SwapBuffers;}

{ Internal functions that should not be called unless you have read
  and understood the source code for these functions. }

procedure SDL_GL_UpdateRects(numrects: Integer; rects: PSDL_Rect);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_UpdateRects'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_UpdateRects}
procedure SDL_GL_Lock;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_Lock'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_Lock;}
procedure SDL_GL_Unlock;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GL_Unlock'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GL_Unlock;}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{* These functions allow interaction with the window manager, if any.        *}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ Sets/Gets the title and icon text of the display window }
procedure SDL_WM_GetCaption(var title : PAnsiChar; var icon : PAnsiChar);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WM_GetCaption'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WM_GetCaption}
procedure SDL_WM_SetCaption(const title : PAnsiChar; const icon : PAnsiChar);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WM_SetCaption'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WM_SetCaption}

{ Sets the icon for the display window.
  This function must be called before the first call to SDL_SetVideoMode().
  It takes an icon surface, and a mask in MSB format.
  If 'mask' is NULL, the entire icon surface will be used as the icon. }
procedure SDL_WM_SetIcon(icon: PSDL_Surface; mask: UInt8);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WM_SetIcon'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WM_SetIcon}

{ This function iconifies the window, and returns 1 if it succeeded.
  If the function succeeds, it generates an SDL_APPACTIVE loss event.
  This function is a noop and returns 0 in non-windowed environments. }

function SDL_WM_IconifyWindow: Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WM_IconifyWindow'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WM_IconifyWindow}

{ Toggle fullscreen mode without changing the contents of the screen.
  If the display surface does not require locking before accessing
  the pixel information, then the memory pointers will not change.

  If this function was able to toggle fullscreen mode (change from
  running in a window to fullscreen, or vice-versa), it will return 1.
  If it is not implemented, or fails, it returns 0.

  The next call to SDL_SetVideoMode() will set the mode fullscreen
  attribute based on the flags parameter - if SDL_FULLSCREEN is not
  set, then the display will be windowed by default where supported.

  This is currently only implemented in the X11 video driver. }

function SDL_WM_ToggleFullScreen(surface: PSDL_Surface): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WM_ToggleFullScreen'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WM_ToggleFullScreen}

{ Grabbing means that the mouse is confined to the application window,
  and nearly all keyboard input is passed directly to the application,
  and not interpreted by a window manager, if any. }

function SDL_WM_GrabInput(mode: TSDL_GrabMode): TSDL_GrabMode;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WM_GrabInput'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WM_GrabInput}

{------------------------------------------------------------------------------}
{ mouse-routines }
{------------------------------------------------------------------------------}

{ Retrieve the current state of the mouse.
  The current button state is returned as a button bitmask, which can
  be tested using the SDL_BUTTON(X) macros, and x and y are set to the
  current mouse cursor position.  You can pass NULL for either x or y. }

function SDL_GetMouseState(var x: Integer; var y: Integer): UInt8;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetMouseState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetMouseState}

{ Retrieve the current state of the mouse.
  The current button state is returned as a button bitmask, which can
  be tested using the SDL_BUTTON(X) macros, and x and y are set to the
  mouse deltas since the last call to SDL_GetRelativeMouseState(). }
function SDL_GetRelativeMouseState(var x: Integer; var y: Integer): UInt8;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetRelativeMouseState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetRelativeMouseState}

{ Set the position of the mouse cursor (generates a mouse motion event) }
procedure SDL_WarpMouse(x, y: UInt16);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WarpMouse'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WarpMouse}

{ Create a cursor using the specified data and mask (in MSB format).
  The cursor width must be a multiple of 8 bits.

  The cursor is created in black and white according to the following:
  data  mask    resulting pixel on screen
   0     1       White
   1     1       Black
   0     0       Transparent
   1     0       Inverted color if possible, black if not.

  Cursors created with this function must be freed with SDL_FreeCursor(). }
function SDL_CreateCursor(data, mask: PUInt8; w, h, hot_x, hot_y: Integer): PSDL_Cursor;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateCursor'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateCursor}

{ Set the currently active cursor to the specified one.
  If the cursor is currently visible, the change will be immediately
  represented on the display. }
procedure SDL_SetCursor(cursor: PSDL_Cursor);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetCursor'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetCursor}

{ Returns the currently active cursor. }
function SDL_GetCursor: PSDL_Cursor;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetCursor'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetCursor}

{ Deallocates a cursor created with SDL_CreateCursor(). }
procedure SDL_FreeCursor(cursor: PSDL_Cursor);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_FreeCursor'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_FreeCursor}

{ Toggle whether or not the cursor is shown on the screen.
  The cursor start off displayed, but can be turned off.
  SDL_ShowCursor() returns 1 if the cursor was being displayed
  before the call, or 0 if it was not.  You can query the current
  state by passing a 'toggle' value of -1. }
function SDL_ShowCursor(toggle: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_ShowCursor'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_ShowCursor}

function SDL_BUTTON( Button : Integer ) : Integer;

{------------------------------------------------------------------------------}
{ Keyboard-routines                                                            }
{------------------------------------------------------------------------------}

{ Enable/Disable UNICODE translation of keyboard input.
  This translation has some overhead, so translation defaults off.
  If 'enable' is 1, translation is enabled.
  If 'enable' is 0, translation is disabled.
  If 'enable' is -1, the translation state is not changed.
  It returns the previous state of keyboard translation. }
function SDL_EnableUNICODE(enable: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_EnableUNICODE'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_EnableUNICODE}

{ If 'delay' is set to 0, keyboard repeat is disabled. }
function SDL_EnableKeyRepeat(delay: Integer; interval: Integer): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_EnableKeyRepeat'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_EnableKeyRepeat}

procedure SDL_GetKeyRepeat(delay : PInteger; interval: PInteger);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetKeyRepeat'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetKeyRepeat}

{ Get a snapshot of the current state of the keyboard.
  Returns an array of keystates, indexed by the SDLK_* syms.
  Used:

  UInt8 *keystate = SDL_GetKeyState(NULL);
  if ( keystate[SDLK_RETURN] ) ... <RETURN> is pressed }

function SDL_GetKeyState(numkeys: PInt): PUInt8;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetKeyState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetKeyState}

{ Get the current key modifier state }
function SDL_GetModState: TSDLMod;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetModState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetModState}

{ Set the current key modifier state
  This does not change the keyboard state, only the key modifier flags. }
procedure SDL_SetModState(modstate: TSDLMod);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SetModState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SetModState}

{ Get the name of an SDL virtual keysym }
function SDL_GetKeyName(key: TSDLKey): PAnsiChar;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetKeyName'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetKeyName}

{------------------------------------------------------------------------------}
{ Active Routines                                                              }
{------------------------------------------------------------------------------}

{ This function returns the current state of the application, which is a
  bitwise combination of SDL_APPMOUSEFOCUS, SDL_APPINPUTFOCUS, and
  SDL_APPACTIVE.  If SDL_APPACTIVE is set, then the user is able to
  see your application, otherwise it has been iconified or disabled. }

function SDL_GetAppState: UInt8;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetAppState'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetAppState}


{ Mutex functions }

{ Create a mutex, initialized unlocked }

function SDL_CreateMutex: PSDL_Mutex;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateMutex'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateMutex}

{ Lock the mutex  (Returns 0, or -1 on error) }

 function SDL_mutexP(mutex: PSDL_mutex): Integer;
 cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_mutexP'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{ $ EXTERNALSYM SDL_mutexP}

function SDL_LockMutex(mutex: PSDL_mutex): Integer;
{$EXTERNALSYM SDL_LockMutex}

{ Unlock the mutex  (Returns 0, or -1 on error) }
function SDL_mutexV(mutex: PSDL_mutex): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_mutexV'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_mutexV}

function SDL_UnlockMutex(mutex: PSDL_mutex): Integer;
{$EXTERNALSYM SDL_UnlockMutex}

{ Destroy a mutex }
procedure SDL_DestroyMutex(mutex: PSDL_mutex);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_DestroyMutex'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_DestroyMutex}

{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
{ Semaphore functions                                           }
{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
{ Create a semaphore, initialized with value, returns NULL on failure. }
function SDL_CreateSemaphore(initial_value: UInt32): PSDL_Sem;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateSemaphore'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateSemaphore}


{ Destroy a semaphore }
procedure SDL_DestroySemaphore(sem: PSDL_sem);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_DestroySemaphore'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_DestroySemaphore}

{ This function suspends the calling thread until the semaphore pointed
  to by sem has a positive count. It then atomically decreases the semaphore
  count. }

function SDL_SemWait(sem: PSDL_sem): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SemWait'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SemWait}

{ Non-blocking variant of SDL_SemWait(), returns 0 if the wait succeeds,
   SDL_MUTEX_TIMEDOUT if the wait would block, and -1 on error. }

function SDL_SemTryWait(sem: PSDL_sem): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SemTryWait'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SemTryWait}

{ Variant of SDL_SemWait() with a timeout in milliseconds, returns 0 if
   the wait succeeds, SDL_MUTEX_TIMEDOUT if the wait does not succeed in
   the allotted time, and -1 on error.
   On some platforms this function is implemented by looping with a delay
   of 1 ms, and so should be avoided if possible. }

function SDL_SemWaitTimeout(sem: PSDL_sem; ms: UInt32): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SemWaitTimeout'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SemTryWait}

{ Atomically increases the semaphore's count (not blocking), returns 0,
   or -1 on error. }

function SDL_SemPost(sem: PSDL_sem): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SemPost'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SemTryWait}

{ Returns the current count of the semaphore }

function SDL_SemValue(sem: PSDL_sem): UInt32;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_SemValue'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_SemValue}

{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
{ Condition variable functions                                  }
{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
{ Create a condition variable }
function SDL_CreateCond: PSDL_Cond;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateCond'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateCond}

{ Destroy a condition variable }
procedure SDL_DestroyCond(cond: PSDL_Cond);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_DestroyCond'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_DestroyCond}

{ Restart one of the threads that are waiting on the condition variable,
   returns 0 or -1 on error. }

function SDL_CondSignal(cond: PSDL_cond): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CondSignal'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CondSignal}

{ Restart all threads that are waiting on the condition variable,
  returns 0 or -1 on error. }

function SDL_CondBroadcast(cond: PSDL_cond): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CondBroadcast'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CondBroadcast}


{ Wait on the condition variable, unlocking the provided mutex.
  The mutex must be locked before entering this function!
  Returns 0 when it is signaled, or -1 on error. }

function SDL_CondWait(cond: PSDL_cond; mut: PSDL_mutex): Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CondWait'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CondWait}

{ Waits for at most 'ms' milliseconds, and returns 0 if the condition
  variable is signaled, SDL_MUTEX_TIMEDOUT if the condition is not
  signaled in the allotted time, and -1 on error.
  On some platforms this function is implemented by looping with a delay
  of 1 ms, and so should be avoided if possible. }

function SDL_CondWaitTimeout(cond: PSDL_cond; mut: PSDL_mutex; ms: UInt32) : Integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CondWaitTimeout'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CondWaitTimeout}

{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
{ Condition variable functions                                  }
{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }

{ Create a thread }
function SDL_CreateThread(fn: PInt; data: Pointer): PSDL_Thread;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_CreateThread'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_CreateThread}

{ Get the 32-bit thread identifier for the current thread }
function SDL_ThreadID: UInt32;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_ThreadID'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_ThreadID}

{ Get the 32-bit thread identifier for the specified thread,
  equivalent to SDL_ThreadID() if the specified thread is NULL. }
function SDL_GetThreadID(thread: PSDL_Thread): UInt32;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetThreadID'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetThreadID}

{ Wait for a thread to finish.
  The return code for the thread function is placed in the area
  pointed to by 'status', if 'status' is not NULL. }

procedure SDL_WaitThread(thread: PSDL_Thread; var status: Integer);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_WaitThread'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_WaitThread}

{ Forcefully kill a thread without worrying about its state }
procedure SDL_KillThread(thread: PSDL_Thread);
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_KillThread'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_KillThread}

{------------------------------------------------------------------------------}
{ Get Environment Routines                                                     }
{------------------------------------------------------------------------------}
{$IFDEF WINDOWS}
function _putenv( const variable : PAnsiChar ): integer;
cdecl;
{$ENDIF}

{$IFDEF Unix}
{$IFDEF FPC}
function _putenv( const variable : PAnsiChar ): integer;
cdecl; external 'libc.so' name 'putenv';
{$ENDIF}
{$ENDIF}

{ Put a variable of the form "name=value" into the environment }
//function SDL_putenv(const variable: PAnsiChar): integer; cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Init'{$ELSE} SDLLibName{$ENDIF __GPC__}SDLLibName name '';
function SDL_putenv(const variable: PAnsiChar): integer;
{$EXTERNALSYM SDL_putenv}

// The following function has been commented out to encourage developers to use
// SDL_putenv as it it more portable
//function putenv(const variable: PAnsiChar): integer;
//{$EXTERNALSYM putenv}

{$IFDEF WINDOWS}
{$IFNDEF __GPC__}
function getenv( const name : PAnsiChar ): PAnsiChar; cdecl;
{$ENDIF}
{$ENDIF}

{* Retrieve a variable named "name" from the environment }
//function SDL_getenv(const name: PAnsiChar): PAnsiChar; cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_Init'{$ELSE} SDLLibName{$ENDIF __GPC__}SDLLibName name '';
function SDL_getenv(const name: PAnsiChar): PAnsiChar;
{$EXTERNALSYM SDL_getenv}

// The following function has been commented out to encourage developers to use
// SDL_getenv as it it more portable
//function getenv(const name: PAnsiChar): PAnsiChar;
//{$EXTERNALSYM getenv}

{*
 * This function gives you custom hooks into the window manager information.
 * It fills the structure pointed to by 'info' with custom information and
 * returns 1 if the function is implemented.  If it's not implemented, or
 * the version member of the 'info' structure is invalid, it returns 0.
 *}
function SDL_GetWMInfo(info : PSDL_SysWMinfo) : integer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_GetWMInfo'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_GetWMInfo}

{------------------------------------------------------------------------------}

//SDL_loadso.h
{* This function dynamically loads a shared object and returns a pointer
 * to the object handle (or NULL if there was an error).
 * The 'sofile' parameter is a system dependent name of the object file.
 *}
function SDL_LoadObject( const sofile : PAnsiChar ) : Pointer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LoadObject'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LoadObject}

{* Given an object handle, this function looks up the address of the
 * named function in the shared object and returns it.  This address
 * is no longer valid after calling SDL_UnloadObject().
 *}
function SDL_LoadFunction( handle : Pointer; const name : PAnsiChar ) : Pointer;
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_LoadFunction'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_LoadFunction}

{* Unload a shared object from memory *}
procedure SDL_UnloadObject( handle : Pointer );
cdecl; external {$IFNDEF NDS}{$IFDEF __GPC__}name 'SDL_UnloadObject'{$ELSE} SDLLibName{$ENDIF __GPC__}{$ENDIF};
{$EXTERNALSYM SDL_UnloadObject}



{------------------------------------------------------------------------------}

function SDL_Swap32(D: Uint32): Uint32;
{$EXTERNALSYM SDL_Swap32}

{ FreeAndNil frees the given TObject instance and sets the variable reference
  to nil.  Be careful to only pass TObjects to this routine. }
procedure FreeAndNil(var Obj);

{ Exit procedure handling }

{ AddExitProc adds the given procedure to the run-time library's exit
  procedure list. When an application terminates, its exit procedures are
  executed in reverse order of definition, i.e. the last procedure passed
  to AddExitProc is the first one to get executed upon termination. }
procedure AddExitProc(Proc: TProcedure);

// Bitwise Checking functions
function IsBitOn( value : integer; bit : Byte ) : boolean;

function TurnBitOn( value : integer; bit : Byte ) : integer;

function TurnBitOff( value : integer; bit : Byte ) : integer;

implementation

{$IFDEF __GPC__}
  {$L 'sdl'}  { link sdl.dll.a or libsdl.so or libsdl.a }
{$ENDIF}

function SDL_TABLESIZE(table: PAnsiChar): Integer;
begin
  Result := SizeOf(table) div SizeOf(table[0]);
end;

procedure SDL_OutOfMemory;
begin
  {$IFNDEF WINDOWS}
  SDL_Error(SDL_ENOMEM);
  {$ENDIF}
end;

function SDL_RWSeek(context: PSDL_RWops; offset: Integer; whence: Integer) : Integer;
begin
  Result := context^.seek(context, offset, whence);
end;

function SDL_RWTell(context: PSDL_RWops): Integer;
begin
  Result := context^.seek(context, 0, 1);
end;

function SDL_RWRead(context: PSDL_RWops; ptr: Pointer; size: Integer; n: Integer): Integer;
begin
  Result := context^.read(context, ptr, size, n);
end;

function SDL_RWWrite(context: PSDL_RWops; ptr: Pointer; size: Integer; n: Integer): Integer;
begin
  Result := context^.write(context, ptr, size, n);
end;

function SDL_RWClose(context: PSDL_RWops): Integer;
begin
  Result := context^.close(context);
end;

function SDL_LoadWAV(filename: PAnsiChar; spec: PSDL_AudioSpec; audio_buf: PUInt8; audiolen: PUInt32): PSDL_AudioSpec;
begin
  Result := SDL_LoadWAV_RW(SDL_RWFromFile(filename, 'rb'), 1, spec, audio_buf, audiolen);
end;

function SDL_CDInDrive( status : TSDL_CDStatus ): LongBool;
begin
  Result := ord( status ) > ord( CD_ERROR );
end;

procedure FRAMES_TO_MSF(frames: Integer; var M: Integer; var S: Integer; var
  F: Integer);
var
  value: Integer;
begin
  value := frames;
  F := value mod CD_FPS;
  value := value div CD_FPS;
  S := value mod 60;
  value := value div 60;
  M := value;
end;

function MSF_TO_FRAMES(M: Integer; S: Integer; F: Integer): Integer;
begin
  Result := M * 60 * CD_FPS + S * CD_FPS + F;
end;

procedure SDL_VERSION(var X: TSDL_Version);
begin
  X.major := SDL_MAJOR_VERSION;
  X.minor := SDL_MINOR_VERSION;
  X.patch := SDL_PATCHLEVEL;
end;

function SDL_VERSIONNUM(X, Y, Z: Integer): Integer;
begin
  Result := X * 1000 + Y * 100 + Z;
end;

function SDL_COMPILEDVERSION: Integer;
begin
  Result := SDL_VERSIONNUM(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL
    );
end;

function SDL_VERSION_ATLEAST(X, Y, Z: Integer): LongBool;
begin
  Result := (SDL_COMPILEDVERSION >= SDL_VERSIONNUM(X, Y, Z));
end;

function SDL_LoadBMP(filename: PAnsiChar): PSDL_Surface;
begin
  Result := SDL_LoadBMP_RW(SDL_RWFromFile(filename, 'rb'), 1);
end;

function SDL_SaveBMP(surface: PSDL_Surface; filename: PAnsiChar): Integer;
begin
  Result := SDL_SaveBMP_RW(surface, SDL_RWFromFile(filename, 'wb'), 1);
end;

function SDL_BlitSurface(src: PSDL_Surface; srcrect: PSDL_Rect; dst:
  PSDL_Surface;
  dstrect: PSDL_Rect): Integer;
begin
  Result := SDL_UpperBlit(src, srcrect, dst, dstrect);
end;

function SDL_AllocSurface(flags: UInt32; width, height, depth: Integer;
  RMask, GMask, BMask, AMask: UInt32): PSDL_Surface;
begin
  Result := SDL_CreateRGBSurface(flags, width, height, depth, RMask, GMask,
    BMask, AMask);
end;

function SDL_MustLock(Surface: PSDL_Surface): Boolean;
begin
  Result := ( ( surface^.offset <> 0 ) or
           ( ( surface^.flags and ( SDL_HWSURFACE or SDL_ASYNCBLIT or SDL_RLEACCEL ) ) <> 0 ) );
end;

function SDL_LockMutex(mutex: PSDL_mutex): Integer;
begin
  Result := SDL_mutexP(mutex);
end;

function SDL_UnlockMutex(mutex: PSDL_mutex): Integer;
begin
  Result := SDL_mutexV(mutex);
end;

{$IFDEF WINDOWS}
function _putenv( const variable : PAnsiChar ): Integer;
cdecl; external {$IFDEF __GPC__}name '_putenv'{$ELSE} 'MSVCRT.DLL'{$ENDIF __GPC__};
{$ENDIF}


function SDL_putenv(const variable: PAnsiChar): Integer;
begin
  {$IFDEF WINDOWS}
  Result := _putenv(variable);
  {$ENDIF}

  {$IFDEF UNIX}
  {$IFDEF FPC}
  Result := _putenv(variable);
  {$ELSE}
  Result := libc.putenv(variable);
  {$ENDIF}
  {$ENDIF}
end;

{$IFDEF WINDOWS}
{$IFNDEF __GPC__}
function getenv( const name : PAnsiChar ): PAnsiChar;
cdecl; external {$IFDEF __GPC__}name 'getenv'{$ELSE} 'MSVCRT.DLL'{$ENDIF};
{$ENDIF}
{$ENDIF}

function SDL_getenv(const name: PAnsiChar): PAnsiChar;
begin
  {$IFDEF WINDOWS}

  {$IFDEF __GPC__}
  Result := getenv( string( name ) );
  {$ELSE}
  Result := getenv( name );
  {$ENDIF}

  {$ELSE}

  {$IFDEF UNIX}

  {$IFDEF FPC}
  Result := fpgetenv(name);
  {$ELSE}
  Result := libc.getenv(name);  
  {$ENDIF}

  {$ENDIF}

  {$ENDIF}
end;

function SDL_BUTTON( Button : Integer ) : Integer;
begin
  Result := SDL_PRESSED shl ( Button - 1 );
end;

function SDL_Swap32(D: Uint32): Uint32;
begin
  Result := ((D shl 24) or ((D shl 8) and $00FF0000) or ((D shr 8) and $0000FF00) or (D shr 24));
end;

procedure FreeAndNil(var Obj);
{$IFNDEF __GPC__}
{$IFNDEF __TMT__}
var
  Temp: TObject;
{$ENDIF}
{$ENDIF}
begin
{$IFNDEF __GPC__}
{$IFNDEF __TMT__}
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
{$ENDIF}
{$ENDIF}
end;

{ Exit procedure handling }
type
  PExitProcInfo = ^TExitProcInfo;
  TExitProcInfo = record
    Next: PExitProcInfo;
    SaveExit: Pointer;
    Proc: TProcedure;
  end;

var
  ExitProcList: PExitProcInfo = nil;

procedure DoExitProc;
var
  P: PExitProcInfo;
  Proc: TProcedure;
begin
  P := ExitProcList;
  ExitProcList := P^.Next;
  ExitProc := P^.SaveExit;
  Proc := P^.Proc;
  Dispose(P);
  Proc;
end;

procedure AddExitProc(Proc: TProcedure);
var
  P: PExitProcInfo;
begin
  New(P);
  P^.Next := ExitProcList;
  P^.SaveExit := ExitProc;
  P^.Proc := Proc;
  ExitProcList := P;
  ExitProc := @DoExitProc;
end;

function IsBitOn( value : integer; bit : Byte ) : boolean;
begin
  result := ( ( value and ( 1 shl bit ) ) <> 0 );
end;

function TurnBitOn( value : integer; bit : Byte ) : integer;
begin
  result := ( value or ( 1 shl bit ) );
end;

function TurnBitOff( value : integer; bit : Byte ) : integer;
begin
  result := ( value and not ( 1 shl bit ) );
end;

end.


