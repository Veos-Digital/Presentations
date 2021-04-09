<div class="row" style="width:100%;margin-top:200px">
  <h1 class="almost_white">Julia-JavaScript communication for interactive dashboards</h1>
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
- JavaScript is an amazing language for UI development.
]

--

.container[
- Many different frameworks exist (Angular, React, Vue, Svelte, Mithril, etc).
]

--

.container[
- JavaScript is not an ideal language to develop novel Machine Learning (ML) techniques.
]

--

.container[
- How does one manage communications between JavaScript and backend language (in our case Julia)?
]

---

### First attempt: HTTP requests (REST server)

- JavaScript handles the UI client-side.

- The users specifies the analysis they want to run.

- The analysis parameters are sent to the server (via HTTP request).

- Server responds with analysis result.

- UI renders the analysis result client-side.

---

### Advantages

- Decoupling (separation of concerns) between model and interface.

- Each language does what it excels at (resp. UI for JavaScript, ML for Julia).

--

### Disadvantages

- The content of the HTTP response is massively complex. It should contain:

  - an arbitrarily complex plot, with an arbitrary complex layout,
  - rules for the plot interactivity,
  - the design of a "sub-interface" specific to the analysis.

--

- This "sub-interface" interactivity is problematic:

  - it cannot happen client-side as it requires to recompute the model,
  - for continuous parameters, HTTP requests should be for each slider step.

---

### Possible solution: observables synchronized via websockets

.container[
Observables are "updatable units" that emit signals when their value changes, thus updating other observables.
]

.container[
Current architecture:

- the UI is built on the Julia side, using a markup language (HyperText),
- a set of interlinked observables determines the model as well as the UI,
- JavaScript observables are synced to the UI *and* to their Julia counterparts (via websockets).
]

---

layout: false
class: center

<img style="margin-top: 20%" src="assets/logo_png/DarkIconLeft.png" width="50%">
