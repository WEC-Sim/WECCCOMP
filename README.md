# WECCCOMP – WEC Control Competition

**Author:**          Kelley Ruehl, Sandia National Laboratories

**WEC-Sim Version:** v2.2

**Matlab Version:** R2017a

Numerical setup for the WEC Control Competition (WECCCOMP) using WEC-Sim to model the WaveStar.

To Do:
* Add Franceso's lin->rot and rot->lin in 'Rotary' variant subsystem (i.e. WaveStar_Francesco.slx and controller_init.m) (NT)
* Add damping/drag values? (Francesco)
* Add non-linear hydrostatic look-up table? (NT/KR)
* Compare to exp data (NT/KR)
* Rotate WaveStar geom 180deg (KR)
* implement PTO efficiency model (0.7) + (1/0.7)
* write model documentation (KR)
* test performance metrics w/Controller (NT)
* run WECCCOMP seastates