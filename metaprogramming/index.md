<div class="row" style="width:100%;margin-top:200px">
  <h1 class="almost_white">Metaprogramming for machine learning</h1>
  <h3 class="almost_white">Pietro Vertechi</h3>
  <h4 class="almost_white">pietro.vertechi@veos.digital</h4>
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

### Metaprogramming

- Code that (re)writes other code.

--

- Underlying assumption: code is data.

--

- Reduce boilerplate.

--

- Create Domain Specific Languages.

--

- Tweak external functions:
  - memoize,
  - preallocate,
  - differentiate,
  - run on GPU.

---

### Macros: convert expression typed in by user

.container[
Inherited from LISP language.

Translate expression into novel expressions, which are then evaluated.
]

--

.container[
#### Examples

```julia
julia> @time sin.(rand(2))
  0.000003 seconds (2 allocations: 192 bytes)
2-element Array{Float64,1}:
 0.3465147188587482
 0.5578638085440257

julia> @test 3 * 4 == 34
Test Failed at REPL[17]:1
  Expression: 3 * 4 == 34
   Evaluated: 12 == 34
ERROR: There was an error during testing
```
]

---

### Macros: convert expression typed in by user

.container[
Macros can be used to create syntax specific to a domain.

#### Example: JuMP (optimization package)

```julia
julia> @variable model 0 <= x <= 2
x

julia> @variable model 0 <= y <= 30
y

julia> @objective model Max 5x + 3y
5 x + 3 y
```
]

--

.container[
```julia
julia> @macroexpand @variable model 0 <= x <= 2
quote
    JuMP._valid_model(model, :model)
    JuMP._error_if_cannot_register(model, :x)
    var"#7###253" = JuMP.add_variable(model, JuMP.build_variable(JuMP.var"#_error#86"{LineNumberNode,Tuple{Symbol,Expr}}(:(#= REPL[10]:1 =#), (:model, :(0 <= x <= 2))), JuMP.VariableInfo(true, 0, true, 2, false, NaN, false, NaN, false, false)), "x")
    (JuMP.object_dictionary(model))[:x] = var"#7###253"
    x = var"#7###253"
end
```
]

---

### Possible applications in machine learning / data science

.container[
#### Probabilistic programming (Turing.jl)

```julia
@model function coinflip(y)
    # Our prior belief about the probability of heads in a coin.
    p ~ Beta(1, 1)

    # The number of observations.
    N = length(y)
    for n in 1:N
        # Heads or tails of a coin are drawn from a Bernoulli distribution.
        y[n] ~ Bernoulli(p)
    end
end
```
]

--

.container[
#### Data wrangling (DataFramesMeta.jl)

```julia
julia> @where df :x .> x :y .== 3

julia> @transform df newCol = cos.(:x) anotherCol = :x.^2 + 3*:x .+ 4
```
]

---

### Limitations

Macros only have access to the syntax that was manually typed in.

- Break composability.

- Cannot be used on external code.

.container[
```julia
@mymacro f() # no access to the function body of `f`
```
]

---

### Cassette: exploit intermediate representation of a function

.container[
- Each function is converted to an Intermediate Representation (IR) before being optimized by compiler.

- We can access and tweak code in IR form.
]

--

.container[
```julia
julia> f(x) = 3x + 12

julia> @code_lowered f(3)
CodeInfo(
1 ─ %1 = 3 * x
│   %2 = %1 + 12
└──      return %2
)
```
]

---

count: false

### Cassette: exploit intermediate representation of a function

.container[
```julia
julia> using Cassette

julia> Cassette.@context Ctx;

julia> Cassette.overdub(Ctx(), f, 3)
21
```
]

--

.container[
```julia
julia> @code_lowered Cassette.overdub(Ctx(), f, 3)
CodeInfo(
    @ REPL[14]:1 within `f'
1 ─       #self# = Core.getfield(##overdub_arguments#254, 1)
│         x = Core.getfield(##overdub_arguments#254, 2)
│         Cassette.prehook(##overdub_context#253, Main.:*, 3, x)
│   %4  = Cassette.overdub(##overdub_context#253, Main.:*, 3, x)
│         Cassette.posthook(##overdub_context#253, %4, Main.:*, 3, x)
│   %6  = %4
│         Cassette.prehook(##overdub_context#253, Main.:+, %6, 12)
│   %8  = Cassette.overdub(##overdub_context#253, Main.:+, %6, 12)
│         Cassette.posthook(##overdub_context#253, %8, Main.:+, %6, 12)
│   %10 = %8
└──       return %10
)
```
]

---

### Possible use case: memoization

.container[
Store results of previous function evaluations and do not recompute.

#### Example: silly Fibonacci definition

```julia
fib(n) = n <= 1 ? n : fib(n - 2) + fib(n - 1)
```

`fib(n)` takes exponential time to compute.
]

---

count: false

### Possible use case: memoization

.container[
```julia
using Cassette: Cassette, @context, overdub, recurse

@context MemoizeCtx

function Cassette.overdub(ctx::MemoizeCtx, ::typeof(fib), n)
    get!(ctx.metadata, n) do
        recurse(ctx, fib, n)
    end
end
```
]

--

.container[
Now computations are stored:

```julia
julia> fibtest(n) = [fib(i) for i in 1:n]

julia> @time fibtest(40)
  1.423613 seconds

julia> @time overdub(MemoizeCtx(metadata=Dict{Int, Int}()), fibtest, 40)
  0.000008 seconds
```
]

---

### More complex applications

.container[
- Automatically preallocate arrays (https://github.com/oxinabox/AutoPreallocation.jl)
]

--

.container[
- Generate GPU kernels (for multiple backends) directly from julia code (https://github.com/JuliaGPU/KernelAbstractions.jl)
]

--

.container[
- Automatic reverse-mode differentiation (https://github.com/FluxML/Zygote.jl)
]

---

### Limitations

- Increase in compile time.

--

- Possible performance problems (bypass compiler optimizations).

--

- Ongoing work on the Julia compiler team to mitigate these issues.

---

### Conclusions

.container[
- Macros allow us to create Domain Specific Languages for optimization and data manipulation.

- More advanced metaprogramming tools allow us to use (almost...) arbitrary code in machine learning pipelines on CPU and GPU.
]