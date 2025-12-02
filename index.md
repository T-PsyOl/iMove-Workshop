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

### **1. `keyboardEventScript.m`**
A minimal LSL event stream generator that sends keyboard press and release
events as markers.  
Useful for prototyping timing, testing experimental pipelines, and validating
LSL connections.  
Created by **Martin Bleichner (2025)**.

> *Note:* No guarantee of precise event timing — this tool is intended for
training and demonstration purposes.

[Download keyboardScript.m](https://raw.githubusercontent.com/T-PsyOl/iMove-Workshop/main/keyboardEventScript.m)
<a href="https://raw.githubusercontent.com/T-PsyOl/iMove-Workshop/main/keyboardEventScript.m"
   download="keyboardEventScript.m"
   style="display:inline-block;
          padding:10px 16px;
          background:#007acc;
          color:white;
          border-radius:6px;
          text-decoration:none;
          font-weight:600;">
  📥 Download keyboardEventScript.m
</a>


### **2. `iMoveScript.m`**
A script that:
- Loads XDF files  
- Identifies keyboard streams  
- Aligns multiple participants on a shared time axis  
- Visualizes press–release durations as horizontal bars  
- Generates audio sonifications of the performance  
- Computes synchrony and asynchrony between players  

Designed for illustrating timing, coordination, and event structure in
multimodal data.

[Download iMoveScript.m](https://raw.githubusercontent.com/T-PsyOl/iMove-Workshop/main/iMoveScript.m)


