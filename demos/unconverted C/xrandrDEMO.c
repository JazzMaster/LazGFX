#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<X11/Xlib.h>
#include<X11/extensions/Xrandr.h>

Display                 *dpy;
Window                  root;
int                     num_sizes;
XRRScreenSize           *xrrs;
XRRScreenConfiguration  *conf;
short                   possible_frequencies[64][64];
short                   original_rate;
Rotation                original_rotation;
SizeID                  original_size_id;

int main(int argc, char *argv[]){
 dpy    = XOpenDisplay(NULL);
 root   = RootWindow(dpy, 0);
 xrrs   = XRRSizes(dpy, 0, &num_sizes);

//the value of item zero- should be the detectGraph output.
// (we detected XxY at z Hz)

 for(int i = 0; i < num_sizes; i ++) {
        short   *rates;
        int     num_rates;

        printf("\n\t%2i : %4i x %4i  ", i, xrrs[i].width, xrrs[i].height);

        rates = XRRRates(dpy, 0, i, &num_rates);

        for(int j = 0; j < num_rates; j ++) {
                possible_frequencies[i][j] = rates[j];
                printf("%4i ", rates[j]); } }

 printf("\n");

 //
 //     GET CURRENT RESOLUTION AND FREQUENCY
 //
 conf                   = XRRGetScreenInfo(dpy, root);
 original_rate          = XRRConfigCurrentRate(conf);
 original_size_id       = XRRConfigCurrentConfiguration(conf, &original_rotation);

 printf("\n\tCURRENT SIZE ID  : %i\n", original_size_id);

 XCloseDisplay(dpy); 
}


//
//      gcc -o XrandrDEMO xrandrDEMO.c -lX11 -lXrandr -lstdc++

//﻿
