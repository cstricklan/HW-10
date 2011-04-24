%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Diffraction Through a Grating
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize MATLAB
close all; clc;
clear all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Problem
%   A grating residing in air is made of alternating layers of two 
%   materials with dielectric consts of er,low=4 and er,high = 4.41
%   Period = 3.44cm, f=59%, d=1.43cm
%   
%   
%   
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% UNITS
meters = 1;
decimeters = 1e-1 * meters;
centimeters = 1e-2 * meters;
millimeters = 1e-3 * meters;
inches = 2.54 * centimeters;
feet = 12 * inches;
seconds = 1;
hertz = 1/seconds;
kilohertz = 1e3 * hertz;
megahertz = 1e6 * hertz;
gigahertz = 1e9 * hertz;

% Constants
c0 = 299792458;

% Frequency we want to transmit
f0 = 10 * gigahertz;

NPML = [0 0 20 20];

% Grating Material
erhigh = 4.41;
erlow = 4;

d = 1.43 * centimeters; % the Binary stand height
PeriodWidth = 3.44 * centimeters;  %Width between to Binary stands
Highwidth = PeriodWidth*.59;
Lowwidth = (1-.59) * PeriodWidth;

%Calculate the Length of our layers.

dc.x = Lowwidth;
dc.y = d;

Size.x = PeriodWidth;
Size.y = d;

rNx = ceil(Size.x/(centimeters*decimeters)); %This Nz represents real world size
rNy = ceil(Size.y/(centimeters*decimeters));
disp(rNx);
disp(rNy);

% Material Vectors Initialized at Air
rER = ones(rNx,rNy);
rUR = ones(rNx,rNy); 

dx = Size.x/rNx;
dy = Size.y/rNy;

for nx=1:ceil(Highwidth/dx)+9
  for ny=1:rNy
    rER(nx,ny) = erhigh;
  end
end

for nx=ceil(Highwidth/dx)+10:rNx
  for ny=1:rNy
    rER(nx,ny) = erlow;
  end
end



% Frequency

freq_start = 4 * gigahertz;
freq_end = 6 * gigahertz;

NFREQ = freq_end / (0.01*gigahertz); 
FREQ = linspace(freq_start, freq_end, NFREQ); %FREQ List

Buffer.x.value = 0;
Buffer.x.e = [-1 -1];
Buffer.x.u = [1 1];

Buffer.y.value = 15;
Buffer.y.e = [1 1];
Buffer.y.u = [1 1];

subplot(121);
imagesc(rER);
subplot(122);
imagesc(rER');
global ERzz;
FDTD2D( dc, Size, rER, rUR, -1, 5e-4, Buffer, NPML, FREQ, NFREQ, 10, -1, 'Diffraction Grating', 20);
disp('finished');