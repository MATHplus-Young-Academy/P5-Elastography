# Estimation of displacements and mechanical tissue properties from Magnetic Resonance Elastography data
MR Elastography is an imaging technique sensitive to tissue mechanics and tissue mechanical properties. Combined with mathematical models, it can be used to estimate biomarkers from low-resolution displacement data. This project targets the development of an automatic pipeline to obtain high-quality displacement images and estimate mechanical parameters applying smoothing and inverse estimators to the complex MRE signal.

## Background

MR Elastography is a relatively novel techniques that can allow for non invasive characterization of tissue pathologies. In order to use MRE in clinical applications, the raw phase images needs to be processed and converted in to displacement fields that can be then used in the context of mathematical models, inverse problems, or data assimilation frameworks.

These pre-processing steps have the purpose to (i) remove acquisition artifacts, (ii) apply certain transformation to the original signal, (iii) take into account physical properties of the tissue, (iv) smoothing/noise reduction, among others.

This project aims at facilitating the usage of MR images in mathematical models by creating a standard (as much as possible) preprocessing set of routines to be applied to raw data.

## Methodology

### Images

We plan to consider different types of images:
- raw phase data coming from MRE experiments
- smoothed data from IR (inversion recovery) MRE, where some a priori analysis considering tissue mixture (solid/fluid) has been included
- simulated (synthetic) data

### Unwrapping

### Parameter estimation

Once the displacements have been recovered, we plan to implement a finite volume (FV) direct inversion method to obtain estimates of mechanical parameters.
The FV direct method has been developed by [Mura, Braun, Sack, Barnhill (2018)](#). 
The approach is based on (i) assuming a linear incompressible elastic or viscoelastic underlying PDEs, (ii) integrating the available data on elementary volumes, (iii) estimating the remaining parameters by a least-squares-type approach

The main questions to be answered concerns the possibility of integrating over different volume sies, and the interplay of this method with the considered preprocessing steps.


## Practical aspects/agenda

### Day 1

The team work begun with a general discussion/introduction,  and with gatherig of references about the imaging context (MRE), the physical context (Elasticity/PDEs), and the mathematical/computational framework.

We indentified the relevant assets to begin: 
- different dataset (from Charit??) of MRE experiments (Lilaj et al. 2021)
- a set of matlab routines for unwrapping and parameter estimation from the Charit?? (I. Sack) group 
- a preliminary finite-volume based code for the direct estimation (in matlab) (Mura, Braun, Barnhill, Sack 2018)
- A C++ code code for poroelastic modeling ([MAD](#))

The first tasks concerned:
- Test the unwrapping on the available data
- Convert the matlab routines to python functions
- Generate synthetic data using 

Starting point: MATLAB routine to unwrap DICOM sequence
- First python code to read DICOM, convert the MATLAB code and test the unwrapping
