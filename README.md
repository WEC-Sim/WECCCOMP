# WECCCOMP – WEC Control Competition

**Author:**          Kelley Ruehl (Sandia), Nathan Tom (NREL) and Francesco Ferri (Aalborg)

**WEC-Sim Version:** v2.2

**Matlab Version:** R2017a

**WEC-Sim Model**
Numerical model for the WEC Control Competition (WECCCOMP) using WEC-Sim to model the WaveStar.

**To Do:**
* Rotate WaveStar geom 180deg (KR) - COMPLETE
* implement PTO efficiency in post (KR) - COMPLETE
* Add lin->rot and rot->lin in 'Rotary' variant subsystem (i.e. WaveStar_Francesco.slx and controller_init.m) (Francesco)
* Compare to exp data (NT/KR)
* Add damping/drag values? (Francesco)
* convert Iyy to cg from A (KR/NT)
* write model documentation (KR)
* test performance metrics w/Controller (NT)
* run free decay 
* run WECCCOMP sea states

**Questions?**
* Post all WEC-Sim modeling questions to the [WEC-Sim online forum](https://github.com/WEC-Sim/WEC-Sim/issues).
* Post all WECCCOMP control competition questions to the [WECCCOMP online forum](http://www.eeng.nuim.ie/coer/control-competition-forum-login/). 