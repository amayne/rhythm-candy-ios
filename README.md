Rhythm Candy for iOS
==============

An example app showing you how to analyze audio data and perform note onset detection in iOS 4.0 and above using the Accelerate framework.

This code is several years old but still works fine. I was frustrated to see that even at 3 years later its still hard to find a decent audio analysis example project, so here's mine. 

Out of the box this will take the current MPMediaItem being played and analyze its audio track.  

It shows you how to calculate the FFT, Spectral Flux & pruned output using simple thresholding techniques to detect note onsets in any audio (mp3, wav etc). It is lightning fast with a 3min mp3 taking approx 3 seconds on an iPhone 3GS. 

Could be the basis for any music rhythm game, bpm counter etc etc.

**Enjoy!**

For more info:
--------------

- http://en.wikipedia.org/wiki/Fast_Fourier_transform

- http://en.wikipedia.org/wiki/Spectral_flux

and my favourite tutorial (Android based):

- http://www.badlogicgames.com/wordpress/?p=161
