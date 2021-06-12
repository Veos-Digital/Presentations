<div class="row" style="width:100%;margin-top:200px">
  <h1 class="almost_white">AlgebraOfGraphics: a simple language for data visualization</h1>
</div>
<div class="row" style="width:100%">
  <div class="column" style="width:100%;margin-left:50%">
    <img src="assets/logo_png/DarkIconLeft.png" width="50%">
  </div>
</div>

---

layout: true
<div class="footer">
  <img style ="margin-left:65%" src="assets/logo_png/DarkNoIcon.png" width="20%">
</div>

---

### Introduction

.container[
- Data-driven decisions are becoming increasingly common, both in industry and in academia.
]

--

.container[
- Data analysis tools need to become accessible to a wide audience.
]

--

.container[
- At the moment, there is a divide between
  - simple but limited _no-code_ tools and
  - powerful but complex _programming_ environments.
]

---

### Business perspective

.container[
Potential advantages of a simple and powerful data visualization tool.

- Advisory projects require less time and effort.

- Easier onboarding experience for new data scientists.
]

--

<br>

.container[
A data visualizations framework makes it possible to design

- _power-user_ UIs, targeted at data science departments, and

- _simplified_ UIs, targeted at decision makers
  - a means of distributing a custom analysis / ML technique.
]

---

### Design philosophy

AlgebraOfGraphics aims to be a simple and general language for data visualizations.

--

.container[

__From question to plot.__<br> Generate a visualization that answers a given question based on the data.

__Explicit commands.__<br> Do not interpret user input but follow it literally.

__Composable user-defined building blocks.__<br> Allow users to define their own building blocks, and combine them with `*` and `+`.

__Opinionated visual defaults.__<br> The library, not the user, is responsible for a consistent and inclusive visual style.

__Wide format support.__<br> Support a wide range of data formats. Do not require the user to manually convert.
]

---

layout: false
class: center

<img style="margin-top: 20%" src="assets/logo_png/DarkIconLeft.png" width="50%">
