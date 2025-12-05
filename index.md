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
> 
<a href="https://raw.githubusercontent.com/T-PsyOl/iMove-Workshop/main/keyboardEventScript.m"
   download="keyboardEventScript.m"
   style="display:inline-block;
          padding:10px 16px;
          background:#007acc;
          color:white;
          border-radius:6px;
          text-decoration:none;
          font-weight:600;">
  📥 Get keyboardEventScript.m
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

<a href="https://raw.githubusercontent.com/T-PsyOl/iMove-Workshop/main/iMoveScript.m"
   download="iMoveScript.m"
   style="display:inline-block;
          padding:10px 16px;
          background:#007acc;
          color:white;
          border-radius:6px;
          text-decoration:none;
          font-weight:600;">
  📥 Get iMoveScript.m
</a>

## Prerequisites: MATLAB + EEGLAB + LSL Libraries
To ensure that the scripts in this repository run correctly, please complete the following setup steps.

1. Open MATLAB

2. Install EEGLAB
Download EEGLAB from the official website:
<https://sccn.ucsd.edu/eeglab/download.php>

3. Start EEGLAB in MATLAB

Launch MATLAB and run:
```
eeglab
```
4. Install the LSL MATLAB Viewer Plugin

Inside EEGLAB:

Go to File → Manage EEGLAB Extensions

Search for: "LSL"

Install the xdfimport plugin
Install the lsl matlab viewer plugin

Restart EEGLAB if prompted

This plugin automatically installs the required LSL dependencies.

5. Initialize the LSL MATLAB Viewer Once

After installation, run the LSL Matlab Viewer:
Go to File → LSL Matlab Viewer

or type in 
```
vis_stream
```
This ensures all dependencies are correctly added to MATLAB’s path.

### Optional: Install LabRecorder (for your own recordings)

If you want to record your own LSL data (e.g., keyboard events, EEG streams, sensors), get the  LabRecorder:

<https://github.com/labstreaminglayer/App-LabRecorder/releases>

Choose the appropriate version for your operating system, download it, and unzip it.
No installation is required — just run the LabRecorder executable.

## How to Use the Demo Setup
For the demonstration, we use three laptops, all connected to the same local network (in our case, a WiFi network without internet access).

### Network Setup
To ensure that all LSL data streams can reach each other reliably:

Disable the firewall on all three laptops
(remember to turn it back on before reconnecting to the internet).

Check IP connectivity

Open the terminal: press Win + R, type cmd, press Enter

Look up the computer’s IP address:
```
ipconfig
```
From each machine, test whether the others are reachable:

```
ping <IP-address-of-other-computer>
```

You should see responses such as:
```
Reply from <IP>: bytes=32 time<1ms TTL=128
```
If all machines can ping each other, the network is ready.

### Roles of the Three Computers
1. Recording Computer

One laptop serves as the recording machine.
It runs LabRecorder, which collects all available LSL streams and stores them together in a single XDF file.

2. and 3. Event-Generating Computers

The other two laptops each run a small MATLAB script (included in this repository).
These scripts:

* Create an LSL event stream

* Send keyboard press and release events in real time

Once running, these streams automatically appear in LabRecorder on the recording laptop.

### Running the Demo

- Start the MATLAB scripts on the two event-generating laptops.
Each script will begin sending LSL keyboard events when you type. 

- On the recording laptop, launch LabRecorder.
You should now see all available streams, including the keyboard streams.

- Press Record in LabRecorder to start the recording.
All incoming data will be saved into one XDF file.

- After recording, use the provided iMoveScript.m to:

   - Load the XDF file

   - Identify streams

   - Visualize keypress timing

   - Sonify the performance


## References

Kothe, Christian, Seyed Yahya Shirazi, Tristan Stenner, et al.
“The Lab Streaming Layer for Synchronized Multimodal Recording.”
Imaging Neuroscience, online ahead of print, 18 August 2025.
<https://doi.org/10.1162/IMAG.a.136>

Blum, Sarah, Daniel Hölle, Martin Georg Bleichner, and Stefan Debener.
“Pocketable Labs for Everyone: Synchronized Multi-Sensor Data Streaming and Recording on Smartphones with the Lab Streaming Layer.”
Sensors 21, no. 23 (2021): 23.
<https://doi.org/10.3390/s21238135>

Klapprott, Melanie, and Stefan Debener.
“Mobile EEG for the Study of Cognitive-Motor Interference during Swimming?”
Frontiers in Human Neuroscience 18 (2024): 1466853.
<https://doi.org/10.3389/fnhum.2024.1466853>

Hölle, Daniel, Sarah Blum, Sven Kissner, Stefan Debener, and Martin G. Bleichner.
“Real-Time Audio Processing of Real-Life Soundscapes for EEG Analysis: ERPs Based on Natural Sound Onsets.”
Frontiers in Neuroergonomics 3 (2022).
<https://doi.org/10.3389/fnrgo.2022.793061>

Hölle, Daniel, Joost Meekes, and Martin G. Bleichner.
“Mobile Ear-EEG to Study Auditory Attention in Everyday Life.”
Behavior Research Methods 53, no. 5 (2021): 2025–2036.
<https://doi.org/10.3758/s13428-021-01538-0>

Hölle, Daniel, and Martin G. Bleichner.
“Smartphone-Based Ear-Electroencephalography to Study Sound Processing in Everyday Life.”
European Journal of Neuroscience 58, no. 7 (2023): 3671–3685.
<https://doi.org/10.1111/ejn.16124>

Papin, Lara J., Manik Esche, Joanna E. M. Scanlon, Nadine S. J. Jacobsen, and Stefan Debener.
“Investigating Cognitive-Motor Effects during Slacklining Using Mobile EEG.”
Frontiers in Human Neuroscience 18 (May 2024).
<https://doi.org/10.3389/fnhum.2024.1382959>

Rosenkranz, Marc, Timur Cetin, Verena N. Uslar, and Martin G. Bleichner.
“Investigating the Attentional Focus to Workplace-Related Soundscapes in a Complex Audio-Visual-Motor Task Using EEG.”
Frontiers in Neuroergonomics 3 (2023).
<https://doi.org/10.3389/fnrgo.2022.1062227>

Rosenkranz, Marc, Thorge Haupt, Manuela Jaeger, Verena N. Uslar, and Martin G. Bleichner.
“Using Mobile EEG to Study Auditory Work Strain during Simulated Surgical Procedures.”
Scientific Reports 14, no. 1 (2024): 24026.
<https://doi.org/10.1038/s41598-024-74946-9>

Korte, Silvia, Manuela Jaeger, Marc Rosenkranz, and Martin G. Bleichner.
“From Beeps to Streets: Unveiling Sensory Input and Relevance across Auditory Contexts.”
Frontiers in Neuroergonomics 6 (April 2025): 1571356.
<https://doi.org/10.3389/fnrgo.2025.1571356>
