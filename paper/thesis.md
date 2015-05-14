---
title: Utility of Foam Waveguides for recovering the input signal in Hybrid Acoustic Drums.
author: Marcell J. Vazquez-Chanlatte
abstract: TODO
---

# Introduction

In this paper we explore the effects of introducing a foam waveguide into the cavity
of hybrid acoustic drums. First we shall give some properties that motivate the use of 
foam waveguides for drumpads (and potentially other human interface devices). Then
to concretely illustrate these benefits, a preliminary design of a system exploiting these
effects is developed. Next the design's theoretical properties are explored and tested.
We then develop software techniques for automatically calibrating such a system to then
recover to input signal. This signal could then be convolved with another drum's impulse
response to replicate the sound of that drum being driven instead. Finally, we shall 
explore issues with technique and avenues for future research.

# Motivations

The motivations for studying foam waveguides include lowering the intensity of the sound produced, 
eliminating echos, and using lower sample rates. Let us quickly explore why these are desirable 
properties.

## Lowering the Signal Intensity

The advantages of lowering the signal intensity at numerous. One might imagine such a drum
pad being used in an apartment complex where the surrounding communities ambinent noise is 
heavily regulated. Additionally, as with wireless radios, lowering intensity signals can be
in closer proximity to each other without effecting the quality of the communications. Here
cross talk might result from a sound wave propegrating into a nearby instrument. With the 
introduction of damping in both instruments, not only is the initial sound wave lower 
intensity, but if it reaches a near by instrument, it is futher attenuated before reaching 
the sensors.

## Eliminating Echos

The attenuation also helps eliminate unwanted signals reflected from the boundary (which may be thought of 
as sources at mirror locations). Indeed, with sufficient damping, time delay of arrival estimates can safely
ignore the possibilities of echos.

## Lowering Sample Rates

Finally, many of the techniques for calibration and localization utilize time delay of arrive. As we shall see
the introduction of damping by filling the cavity with a high density polymer foam and placing the sensors inside
the foam significantly lowers the wave speed. While this does not effect the frequency of the waves and thus the 
capturing of the signal's structure (modulo frequency dependent attenuation), it does decrease the minimal sample
rate for accurately computing the time delay of arrival. This enables the use of cheaper sensors for calibration
and localization.

# Design of Drumpad & Instrumentation

Many of the techniques discussed in this paper were motivated by Roberto Aimi's work on real-time convolution in percussion instruments.
[-@aimi2007percussion] Here, the focus is on drum pads since their dynamics are modeled using simple linear differential equations. This
allows one to estimate the greens function (corresponding to the impulse response) of the system which could be used to deconvolve the
signal to recover the original signal (see figure 3).

## Hardware Design

An image of the drumpad used in the measurments seen later in this paper can be seen in Figure 1. A caricature of the drum is
given in Figure 2. The essential features are a circular membrane pinned down on the boundary. Beneath the membrane is a 
cavity that serves wave guide (with a smaller wave speed) sending the signal to the sensor at the bottom of the cavity.
The foam also applies viscous damping to the drum head as it oscillates.

![Drumpad Overlayed with the location of the sensors relative to the dataset tap locations. 
Not pictured is the foam in between the drumhead and the sensor. ](img/drum_xray.jpg) 

![Cartoon of side view of drumpad.](img/drum_side_cartoon.png ) 


TODO: add reference for PZT datasheet
The sensors themselves are common pizeo electric PZT ceramic contact mics. While these sensors exhibit hysteresis due to
the lack of inversion symmetry, one the time scales and pressures necessary for this application, the response is linear. 

The signals were detected using a Focusrite Scarlett 18i8 audio interface and the jack2 audio server.


## Software Design

![Overview of the system. This paper focuses on developing the region in the dotted box, leaving the synthesis as potential future work. The ultimate goal is to have $G$ have the essential features of $X$. Thus ideally, $G$ is $(D*X)/D$. ](img/overview.png)

As previously noted, the inspiration for this design comes from Roberto Aimi's PhD Thesis. The key difference is that the 
specialization to drumpads allows us to create a training loop that calibrates or learns the response of the drum.

The ultimate goal, as shown in Figure 3, is to use the drumpad as the input and replicate another drum's response. 
To counteract the filter the drumpad, D, applies to the input, X, we try to design a filter G to be D's inverse. 
This is done by deconvoling (an inverse in frequency space) X with the computed greens function.

The calibration procedure

# Analysis of Drumpad Properties

## Theory

### Drum Head Vibrations

> $(\delta_r^2 + \frac{1}{r}\delta_r + \frac{1}{r^2}\delta_{\theta}^2) u = \frac{1}{c^2}\left(
\delta_t^2 + 2 \gamma \delta_t \right)u$

Where $r, \theta$ are cylindrical coordinates, $a$ is the damping coeff, and $c$ is the speed of sound for the material.

> $u_{mn}(r, \theta, t) = J_m(\lambda_{mn}r)[a_{mn}\cos(m \theta) + b_{mn}\sin(m\theta)] \cos{(t\sqrt{c^2 \lambda_{mn}^2 - \gamma^2})}\exp(-\gamma t)$

> $u(r, \theta, t) = \sum_{m=0} \sum_{n=1} u_{nm}$

- $\lambda_{mn} = \alpha_{mn}/R$
  - $\alpha_{mn}$ is the $n$th root of $J_m$

> $c = \sqrt{\frac{N^{*}_{rr}}{\rho h}}$
 
 - $c$ is the speed of sound in the medium
 - $h\equiv$ thickness
 - $N^{*}_{rr} \equiv$ is the radial membrane resultant on $\delta \Omega$
 - $\gamma$ is the attenuation factor
 
 For uniform tension:
 
> $c = \sqrt{\frac{T}{\rho h}}$
 
 - $T =$ Tension

- Fixing $\theta$ and $r$, modes are sinusoids decaying as $\exp(-\gamma t)$

- Varying $r$ and fixing $\theta$ and $t$ should result in Bessel functions

- Varying $\theta$ and fixing $t$ and $r$ should give sinusoids 

### Is viscous damping really approriate?

The previous derivation of the drum head modes assumed that the drum head undergoes viscous damping.
One may reasonably the validity of this assumption[^1]. For example, another reasonable model for the
damping might be coulomb damping since the foam maintains near constant mechanic contact with the
drum head. Moreover, the damping could include higher order terms resulting in turbulent damping.
Lastly, because the foam is constructed using polymers the a fractional model likely captures the
intermediate nature between viscous and hysteretic modes.

#### Turbulent Damping

Let us address each of these concerns. Higher order terms should not dominate in this regime since
no fluids are involved making turbulent effects unlikely. A deeper analysis reveals that even if
there were higher order terms, the non-linearity only emerges when the relative initial conditions 
deviate largely from quiescent conditions (which is not applicable here since this would imply 
the drumhead either deform or tear).

#### Coulomb Damping

Next there is the question of whether Coulomb damping plays a role. Despite the constant mechanical
contact, Coulomb damping would only apply for transverse movements of the foam relative to the
drum-head. While certainly present, the compressive forces are likely to dominate due to the uniform
tension assumption and fixed border boundary condition.

#### Fractional Damping

The most likely candidate for an alternative damping model is fractional damping. Fractional damping
is often used to model polymers which constitute the construction of the foam. These demonstrate a
combination hysteresis and viscosity. [^2]Nevertheless, the hysteretic effects are likely on the order of
similar non-linearities in the piezo contact mics.

Finally, as we shall see in the measurements section, the empirically the model fits a viscous damping model.
An important consequence of this is that the linearity of the viscous damping model allows model to 
be deconvolved, recovering the forcing on reasonable time scales (on the order of milliseconds).

### Damping and its effects on Ray Tracing and Time Delay of Arrival

![Path of the signal through the drum. In this toy model, the path taken in the minimum in time (and thus also attenuation). 
Thus, $\Delta$ is determined by H and the wave speed of the foam.](img/wave_path.png)

> (@T_1) $T(\Delta) = \frac{1}{c_{2}} \sqrt{\Delta^{2} + h^{2}} + \frac{1}{c_{1}} \left(- \Delta + x\right)$

> (@dTdH) $\frac{d T}{d \Delta} = \frac{\Delta}{c_{2} \sqrt{\Delta^{2} + h^{2}}} - \frac{1}{c_{1}}$

Solving for roots yields: 

> $\Delta = \left [ - \sqrt{\frac{c_{2}^{2} h^{2}}{\left(c_{1} - c_{2}\right) \left(c_{1} + c_{2}\right)}}, \quad \sqrt{\frac{c_{2}^{2} h^{2}}{\left(c_{1} - c_{2}\right) \left(c_{1} + c_{2}\right)}}\right ]$

We throw out the negative root since $\Delta$ was defined to be positive.

Computing the concavity of the system yields

> (@ddTddH) $\frac{d^2 T}{d^2 \Delta} = - \frac{\Delta^{2}}{c_{2} \left(\Delta^{2} + h^{2}\right)^{\frac{3}{2}}} + \frac{1}{c_{2} \sqrt{\Delta^{2} + h^{2}}}$

Which when evaluated at  $\quad \sqrt{\frac{c_{2}^{2} h^{2}}{\left(c_{1} - c_{2}\right) \left(c_{1} + c_{2}\right)}}$  for reasonable values of $c_1$, $c_2$, and $h$ ($c_1 \gg c_2, h > 0$ yields a positive result implying that this is infact a minima. [^1]

Substituting calculated $\Delta$ into (@T_1) then gives 

> (@T_2) $T = \frac{1}{c_{2}} \sqrt{\frac{c_{1}^{2} h^{2}}{c_{1}^{2} - c_{2}^{2}}} + \frac{x}{c_{1}} - \frac{1}{c_{1}} \sqrt{\frac{c_{2}^{2} h^{2}}{c_{1}^{2} - c_{2}^{2}}}$.

Shuffling terms around gives

> (@T_3) $T = \frac{h}{c_1}(1- \beta^2)^{-1/2}(\beta^{-1} + \frac{x}{h} - \beta)$

- $\beta \equiv \frac{c_2}{c_1}$

Which can be easily identified as a linear relation w.r.t. $x$ 

> (@T_4) $T = b + a x$

- $\gamma \equiv (1 - \beta^2)^{-1/2}$

- $a = \frac{\gamma}{c_1}$

- $b = h(\beta^{-1} - \beta)\frac{\gamma}{c_1}$

Thus, solving for $b$ and $a$ can be done using a linear fit.

Note that $b$ and $a$ are related by a factor of $h (\beta^{-1} - \beta)$

Thus

> $\frac{b}{h a} = \beta^{-1} - \beta$

Multiplying by $\beta$ we get

> $\beta^2 + \frac{b}{h a}\beta - 1 = 0$

Whose roots are

> $\left [ - \sqrt{1 + \frac{b}{a h}}, \quad \sqrt{1 + \frac{b}{a h}}\right ]$

We can throw out the negative result since $c_1 \wedge c_2 > 0$ impling $\beta=c_2/c_1$ is positive.

With $\beta$ estimated, a series of $T(x)$ measurements can be recast as a linear system w.r.t. $\frac{1}{c_1}$ and $\frac{1}{c_2}$

Thus, determining $c_1$ which in turn induces the mode frequencies: $\frac{c}{R} \alpha_{mn}$

More over, for the expected values, $\frac{c_1}{c_2} \approx \frac{1000}{10}$ and $h \approx \frac{1}{10}$m, $\Delta \approx \frac{1}{1000}$ which is less than the diameter of the piezo sensors.

### Damping as a means to eliminate echos

## Measured

### Excited Modes

![Example impulse response of the system. Log decrement fit indicates the regime where theory is consistent (see fit).](img/impulse.png ) 

![After the initial 0.05ms the log of the peaks fits a linear relation as expected. The initial 
deviation is due to a super position of modes, which gives way to a primary mode compatible with the foam. See spectrum.](img/linear_decay.png ) 

![Example Impulse Zoomed on the first 30ms. Note how the higher frequencies attenuate away.](img/impulse_zoomed.png)

![Spectrum](img/spectrum.png ) 


### Measured Time Delay of Arrival

# Calibration

With the theory in place and real world measurments backing up the soundness of many of 
the assumptions, we now shift focus to calibrating the instrumentation automatically. The 
key requirments to localize the microphone array relative to each other (either by direct 
measurement or array self localization), compute the relevant parameters for calculating
the forcing based on the signal. The primary method described builds on the theory developed so
far to compute the greens function of the system from the wavespeed and damping coefficients. In
practice, one can choose the materials and have strong priors for these quantities parameters at a given
tempature.

## Feasibility of measuring signal

Recall from figure 8, that the predominate modes exist under $1$ khz. The arduino api reference [-@ArduinoReference]
specifies that an analogRead takes about 100 microseconds ($10^-4 s$) allowing use to easily measure the relevant modes.

## Feasibility of computing wave speed

The problem then lies in computing and estimating the wave speed of the material (to estimate which modes correspond to 
which frequencies or equivelently, to localize the forcing). As seen in the Measured Time Delay of Arrival seciton, 
the introduction of damping decreases the wave speed from from $\approx 1000 m/s$ (typical of solids) to $\approx 40 m/s$
(characteristic of porous absorbers like the foam used). Thus the time resolution required to measure the waves 
difference in arrival over 4" (the smallest diameters typically seen in drum heads) is only $\approx 
\frac{1}{4}\frac{1}{100} s$. This is a huge window when compared with the undamped TDOA window of $\frac{1}{2}10^{-4} 
s$ which is on the same order as the time it takes to get an analog measurement on the arduino. Therefore, 
linear least squares fitting described in the ray tracing segment can be used to compute both the wave speed of the
foam, but also the wave speed of the drum head.

## Source Localization and Computing the impulse response

TODO: see johanes sources

# Piezos as actuators to calibrate modes

Another technique work mentioning (but not actively explored here) is actuate the piezos using a known
aperiodic signal (as to have a clear start and end point) and empirically measure the filter between
it and other sensors. For reasonably dense sensor arrays, this could give a very good estimate for the 
greens function.

# Computing $G$ Using Markov Chains

# Issues and Potential Solutions

# Future Work

# Conclusion

[^1]: Indeed, the idea of viscous damping invokes imagery of drum filled entirely submerged in molasses.

[^2]: The effect itself owing to the thermal/statistical nature of polymer chain length.
