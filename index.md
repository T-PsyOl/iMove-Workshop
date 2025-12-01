## Workshop at iMove 2025 (Lübeck)

This repository accompanies the hands-on session presented at  
**iMove 2025 – International Conference on Movement and Computing**  
Lübeck, Germany  
<https://imove2025.org/>

### **Session Title**
**The do's and don'ts of multimodal data acquisition in everyday life**

### **Presenters**
- **Martin Bleichner** (University of Oldenburg)  
- **Melanie Klapprott** (University of Oldenburg)

---

## Overview

In this hands-on tutorial, we explore practical strategies for collecting
multimodal physiological and behavioral data in everyday life environments.
We discuss pitfalls, technical challenges, and best practices when working
with mobile EEG, wearable sensors, and event-based data streams.

The tools in this repository (MATLAB scripts, examples, and documentation)
are designed to give participants a starting point for building their own
multimodal recording and analysis pipelines.

---

## Materials Included in This Repository

### **1. `keyboardScript.m`**
A minimal LSL event stream generator that sends keyboard press and release
events as markers.  
Useful for prototyping timing, testing experimental pipelines, and validating
LSL connections.  
Created by **Martin Bleichner (2025)**.

> *Note:* No guarantee of precise event timing — this tool is intended for
training and demonstration purposes.

### **2. XDF Sonification Tool**
A script that:
- Loads XDF files  
- Identifies keyboard streams  
- Aligns multiple participants on a shared time axis  
- Visualizes press–release durations as horizontal bars  
- Generates audio sonifications of the performance  
- Computes synchrony and asynchrony between players  

Designed for illustrating timing, coordination, and event structure in
multimodal data.

