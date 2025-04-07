---
date: 2025-04-02
layout: post
permalink: /en/2025/04/02/04-02-data-driven-solutions-in-siloed-organizations.html
tags:
- Project
- DevOps
- Leadership
- Organizational Culture
title: Solving Non-Expert Domain Issues with Data Within Siloed Organizational Structures
---
> `gpt-4-turbo` has translated this article into English.

### Background

At the beginning of my employment, I was in charge of App and GUI development when **the product frequently stopped working in the field**, prompting the company to assign additional **field support tasks**.

The product was based on a **control system and embedded environment**, and at that time, I had **no experience in embedded or control domains**.

Additionally, the **embedded and control system departments operated in a silo structure**, which hindered information sharing and collaboration.

---

### Problem Definition

- The product stopped **more than 3 times a day on average**
- Recovery was only possible through **manual reset**
- **The root cause had not been clearly identified**

---

### Problem Approach and Execution Strategy

1. **Data-driven approach**
    - Directly collect status data from the field
    - Log sensor values, control statuses, and location information at the time of issue occurrence
    - **Extract common patterns**
2. **Collaboration with domain experts**
    - Continuous communication with the system control development team
    - Learn about control state flow and the operating principles of safety switches
3. **Anomaly detection and analysis**
    - Identify conditions where location/sensor values **exceed thresholds** leading to stops
    - Attempt to adjust thresholds → **root problem not solved**
    - Plotting sensor data reveals a symptom where **magnetometer readings are periodically incorrect**
4. **Maintaining problem definition amidst organizational resistance**
    - Embedded team repeatedly responds with: "Sensor issue, no improvement possible"
    - Document, quantify, and analyze the phenomenon based on **reports grounded in numerical analysis**

---

### ⚙️ Execution Results and System Improvements

- Developed an **event definition and alarm system** for symptom detection
- Set up a **data transmission pipeline** for collecting field sensor data
- Developed a **subsystem capable of remote reset**
- Improved service stability by **automating and remote controlling** repetitive field reset tasks

---

### Final Outcome

- **Decrease in incident occurrence**, reduced field response burden
- **Enhanced operational efficiency with remote recovery capabilities**
- **Problem fully resolved months after resignation through firmware modification**,

    with confirmation from **internal employees** that the analyzed cause was correct
    

---

### Key Competencies

- **Proactive problem definition and execution in a non-expert domain**
- **Facilitating collaboration and demonstrating execution skills within organizational barriers**
- **Complete experience from data-based analysis to operational automation design**