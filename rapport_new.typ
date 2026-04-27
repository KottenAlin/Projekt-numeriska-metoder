#set document(
  title: "Rapporttitel",
  author: "Författarnamn",
  date: datetime.today()
)

#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2.5cm, top: 2.5cm, bottom: 2cm),
  numbering: "1",
  header: [
    #set align(right)
    Projekt numeriska metoder -- VT2026
  ],

)

#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "sv"
)

#set math.equation(numbering: "(1)")

#show figure.caption: set text(size: 9.5pt)

#set heading(numbering: "1.1.1")

#set par(justify: true)
#set text(hyphenate: true)

// Title Page
#align(center)[
  #v(2cm)
  #text(size: 24pt, weight: "bold")[Projekt numeriska metoder (SF1546)]
  #v(0.5cm)
  #text(size: 14pt)[Värmeöverföring: Från teori till numerisk lösning]
  #v(3cm)
  #text(size: 12pt)[Författare: Sebastian Alin, Robert Falk, Pontus Graf von Hasslingen]
  #v(0.2cm)
  #text(size: 11pt)[Datum: #datetime.today().display()]
  #v(5cm)
]

#pagebreak()

// Table of Contents
#outline(
  title: "Innehållsförteckning",
  depth: 3
)

#pagebreak()

// Introduktion
= Introduktion <introduktion>

Detta projekt ingår i kursen SF1546 - Projekt numeriska metoder, och syftar till att tillämpa numeriska metoder för att lösa problem inom värmeöverföring i en värmeväxlare och kylflänsar.

Syftet med projektet är att lösa problem kopplade till verkligheten, med numeriska metoder, särskilt de som innehåller ickelinjära ekvationssystem och randvärdesproblem. Genom att använda dessa metoder, kommer vi att kunna analysera och optimera värmeöverföringen i de givna systemen.


Projektet är indelat i två delar, där den första delen syftar till att lösa ett icke-linjärt ekvationssystem som beskriver värmeöverföringen i en värmeväxlare (@Figur1), med hjälp av Newtons metod ($x_(n+1) = x_n - f(x_n)/(f'(x_n))$), för att få beräkna den maximala ytterdiametern *$d$* och sedan innerdiameter *$D_s$*.

#figure(
  align(center)[
#image("/assets/image-1.png", alt: "Bildbeskrivning", width: 60%, )],
  caption: [Schematiskt diagram över värmeväxlaren och de givna parametrarna (finns även i kursens projektbeskrivning), hämtad från
  #link("https://commons.wikimedia.org/wiki/File:Straight-tube_heat_exchanger_1-pass.PNG")
  ]
) <Figur1>


Den andra delen fokuserar på att lösa ett randvärdesproblem som beskriver värmeöverföringen i en kylfläns (@Figur_kylflans).
Med hjälp av diskretisering med centrerad differens, och finita differensmetoden, beräknas temperaturfördelningen längs kylflänsen för material med olika egenskaper.

#figure(
  align(center)[
#image("/assets/image-2.png", alt: "Bildbeskrivning", width: 60%, )],
  caption: [Schematiskt diagram över kylflänsen och de givna parametrarna hämtade från kursens projektbeskrivning.
  ]
) <Figur_kylflans>

= Problemformulering Metod <metod>

== Värmeväxlare del 1.1 <del1.1>
Värmeväxlarne i det första problemet kan beskrivas av följande icke-linjära ekvationssystem med givna parametrar (@Tabell1):
  $
     Q=A_(e x) dot U_f dot Delta T_m
  $ <eq1>
  $
    U_f = 1/(d/(D_s dot h_t)+d dot R_(f i)/D_s+ (d dot ln(d slash D_s))/(2k_w)+ R_(f o)+ 1/h_s)
  $ <eq2>
#align(center)[
  #figure(
  table(
  columns: (auto, auto, auto),
  align: (center, center, center),
  stroke: 0.4pt,
  inset: 6pt,

  [*Parameter*], [*Värde*], [*Enhet*],
  [$R_(f i)$], [$1.76 dot 10^(-4)$], [$m^2 degree C slash W$],
  [$R_(f o)$], [$1.76 dot 10^(-4)$], [$m^2 degree C slash W$],
  [$h_s$],    [$356$],                 [$W slash (m^2 degree C)$],
  [$h_t$],    [$356$],                 [$W slash (m^2 degree C)$],
  [$k_w$],    [$60$],                  [$W slash (m degree C)$],
),
caption: [parametrar för värmeöverföringen i värmeväxlaren],
) <Tabell1>
]
  Specifikationer för värmeöverföringen i värmeväxlaren är som följer:
  $ Delta T_m = 29.6 degree C$ och $ Q = 801368 W$; den minsta ytarean som uppfyller specifikationerna är given till $ A_(e x) = 64.15 m^2$ och skalets innerdiameter är $ D_s = 1.219m$.

Alla parametrar förutom rörets ytterdiameter *$d$* är kända. Genom att konstruera en funktion $f(d)$ som representerar skillnaden mellan den beräknade värmeöverföringen och den givna värmeöverföringen, kan problemet formuleras som att hitta roten till denna funktion; det vill säga där $f(d) = 0$.
$
  f(d) = A_(e x) dot U_f(d) dot Delta T_m-Q = 0
$
För att lösa denna rot, användes Newtons metod, som iterativt närmar sig lösningen genom att uppdatera gissningen baserat på funktionen och dess derivata.
$
  x_(d+1) = d_n - f(d_n)/f'(d_n)
$


== Värmeväxlare del 1.2 <del1.2>
Det andra problemet bygger på del 1.2 (@del1.1) med två ytterligare ekvationer, samt givna parametrar (@Tabell2), där tryckskillnaden över värmeväxlaren $Delta P$ måste beaktas. För detta problem är rörets ytterdiameter *$d$* och skalets innerdiameter *$D_s$* är okända:

#columns(2)[
  $
  Delta P = c/(D_s^2(S_t-d)^2)
$ <eq5>
#colbreak()
$
  A_(e x) = pi K_1 D_1^(n_1)/(d^(n_1-1))
$ <eq6>
]
#align(center)[
  #figure(
  table(
  columns: (auto, auto, auto),
  align: (center, center, center),
  stroke: 0.6pt,
  inset: 6pt,

  [*Parameter*], [*Värde*], [*Enhet*],
  [$c$],      [$0.389$],               [$W s dot m$],
  [$S_t$],    [$0.016$],               [$m$],
  [$K_1$],    [$0.249$],               [$m$],
  [$n_1$],    [$2.207$],               [],
  ),
  caption: [Givna parametrar för värmeväxlaren.],
  ) <Tabell2>
]

Specifikationerna för värmeöverföring är samma som i del 1.1 ($Delta T_m = 29.6 degree C$ och $Q = 801368 W$), och en given maximal tryckskillnad över värmeväxlaren $Delta P = 49080 P a$.
Genom att använda de två nya ekvationerna, kan både $d$ och $D_s$ lösas samtidigt genom ett system av två icke-linjära ekvationer.

@eq1 kan nu omformuleras till att inkludera $D_s$ som en variabel, där $U_f$ och $A_(e x)$ är funktioner av både $d$ och $D_s$:
$
  Q(d, D_s) = A_(e x)(d, D_s) dot U_f (d, D_s) dot Delta T_m
$ <eq7>
$
=> F_1(d, D_s) = A_(e x)(d, D_s) dot U_f (d, D_s) dot Delta T_m - Q = 0
$ <eq8>
@eq5 ger en ytterligare ekvation som relaterar $d$ och $D_s$:
$
 F_2(d, D_s) = c/(D_s^2(S_t-d)^2) - Delta P = 0
$ <eq9>

Dessa funktioner kan tillsamans konstrueras som en vektorvärd funktion: $ arrow(F) = (F_1, F_2) = arrow(0)$. Detta system av icke-linjära ekvationer kan sedan lösas med hjälp av Newtons metod för system, där $arrow(x) = (d, D_s)$:
$
  arrow(x)_(n+1) = arrow(x)_n - J^(-1) arrow(F)(x_n)
$


== Derivataapproximationer del 2.1 <del2.1>
I denna del härleds approximationen i @eq12 med hjälp av Taylorutveckling. Därefter implementera tre olika derivata approximationer i _Python_ för *$sin(e^x)$* vid $x=0.75$.
$
  f(x_j) = (-omega_(j+2) + 4 omega_(j+1) - 3 omega_j) / (2h) + cal(O)(h^2)
$
$
  f'(x_j) = (3omega_j - 4 omega_(j-1) + omega_(j-2)) / (2h) + cal(O)(h^2)
$ <eq12>
$
  f'(x_j) = (omega_(j+1)-(omega_(j-1)))/(2h) + cal(O)(h^2)
$
$omega_j = f(x_j)= f(a+j h)$ där $a$ är startpunkten, $b$ är slutpunkten, och $h$ är steglängden $h=(b-a)/N$, där $N$ är antalet delintervall.


== Randvärdesproblem del 2.2 <del2.2>
Denna del fokuserade på att lösa ett randvärdesproblem som beskriver av differensialekvationen
$
  (d^2 T)/(d x^2) = alpha_1(T-T_infinity) + alpha_2 (T^4-T^4_infinity), quad quad x in [0, L]
$<eq14>
Samt Dirichlet randvillkor:
$
  T(0)=T_s, quad quad T(L)=T_infinity
$
Detta problem kan lösas genom att diskretisera andra ordningens derivata med central differens, där den andra derivatan approximativt kan skrivas som:
$
  (d^2 T)/(d x^2) approx (T_(j+1) - 2T_j + T_(j-1))/(h^2) quad quad (+  cal(O)(h^2))
$<eq16>
Där $h=(L)/N$, där $N$ är antalet delintervall.

Vidare kan uttrycket skrivas för varje givet $T_j=T(h j)$ som en funktion: $F_j (T_(j-1), T_j, T_(j+1)) = 0$, där $T_0=T_s$ och $T_N=T_(infinity)$.
Detta ger upphov till ett system av icke-linjära ekvationer ($arrow(F) = (F_1, F_2, ..., F_(N-1)) = arrow(0)$) som kan lösas med hjälp av Newtons metod för system, $arrow(T)^(k+1)= arrow(T)^(k) - J^(-1) arrow(F)(T^(k))$<eq:newtonsys>. #footnote[Notera $arrow(T^k)$ används som superskript och inte som exponent ]


= Genomförande och Resultat <resultat>

== Värmeväxlare del 1.1 <res1.1>

=== Uppgift 1
I Denna deluppgift formuleras den matematiska modellen för att implementera Newtons metod, genom att beräkna $f(d)$ och dess derivata $f'(d)$ analytiskt.
$f'(d)$ kan beräknas genom att använda kedjeregeln och produktregeln för derivering av vilket ger:
$
  f'(d) = -A_(e x) dot Delta T_m dot U_f '(d)
$
$U_f '(d)$ kan beräknas genom att använda kvotregeln för derivering, där $g(d)$ är nämnaren i uttrycket för $U_f(d)$:
$
  g(d) = d/(D_s dot h_t)+d dot R_(f i)/D_s+ (d dot ln(d slash D_s))/(2k_w)+ R_(f o)+ 1/h_s
$
$
  U_f(d) = 1/g(d)  => U_f '(d) = -(g'(d))/(g(d)^2)
$
$g(d)$ är relativt enkelt att derivera bortsätt från den logaritmiska termen, där produktregeln måste tillämpas.#footnote[$d/(d d)(ln(d slash D_s)) = d/(d d)(ln(d)-ln(D_s)) = 1/d- 0$]

$
  d/(d d)(d dot ln(d slash D_s)) = 1 dot ln(d slash D_s) + d dot 1 /d = ln(d slash D_s) + 1
$

$
  => g'(d) = 1/(D_s dot h_t) + R_(f i)/D_s + (ln(d slash D_s)+1)/(2k_w)
$ <eq15>
$
   f'(d) = - (A_(e x) dot Delta T_m ) dot (-(g'(d))/(g(d)^2)) = A_(e x) dot Delta T_m dot (g'(d))/(g(d)^2)
$

=== Uppgift 2 <uppgift2>
Uppgift 2 syftar till att implementera Newtons metod i _Python_, med den beräknade derivatan, för att iterativt närma sig lösningen för $d$, med en startgissning *$d_0 = 0.007m$* och en tolerens på *$10^(-8)m$*.

```python
def newton_method(d_0, tolerance, max_iter=10000):
    d_n = d_0
    errors = []
    for i in range(max_iter): # Loop until max iterations
        if f_prime(d_n) == 0:  # Avoid division by zero
            print("Derivative is zero. No solution found.")
            return None
        d_next = d_n - f(d_n) / f_prime(d_n) # newtons method formula
        errors.append(abs(d_next - d_n)) # store the error for convergence analysis

        if abs(d_next - d_n) < tolerance:
            print(f"Converged to {d_next} after {i+1} iterations.")
            return d_next, errors
        d_n = d_next
    return None
```

Denna implementering ger svaret *$d = 0.0191314071m approx 19.1m m$* efter 4 iterationer.

=== Uppgift 3
Denna uppgift skall analysera konvergensordningen för Newtons metod genom att använda de beräknade felen från varje iteration, och jämföra lösningen mot pythons egna lösning

*a)*
genom att anta felet som en potensfunktion kan konvergensordningen $p$ uppskattas genom att använda följande formel:
$
 e_(k+1) approx C e_k^p => e_(k+2) approx C e_(k+1)^p
$
$
  e_(k+2)/e_(k+1) = (C e_(k+1)^p)/(C e_k^p) =  (e_(k+1)/e_k)^p => ln(e_(k+2)/e_(k+1)) = p ln(e_(k+1)/e_k) => p = ln(e_(k+2) slash e_(k+1)) / ln(e_(k+1) slash e_k)
$ <eq18>
Implementeringen av detta i _Python_ ger nu en uppskattning av konvergensordningen *$p=2.3561$*. Det ligger relativt nära den teoretiska konvergensordningen för Newtons metod, som är *2*.#footnote[Detta kan härledas med Taylor utveckling (#link("https://math.libretexts.org/Bookshelves/Applied_Mathematics/Numerical_Methods_(Chasnov)/02%3A_Root_Finding/2.04%3A_Order_of_Convergence ")[se länk]), och hämtades från föreläsningsanteckningarna]

*b)* Lösningen från Scipy: ```python (optimized_solution = optimize.fsolve(f, d_0)) ``` ger *$d=0.0191314071m$*, vilket i praktiken är identiskt med vår implementerade lösning, och bekräftar att vår implementation av Newtons metod är korrekt.

*c)*
Genom att plotta funktionen $f(d)$ över intervallet $[0, 2]$ kan vi visuellt bekräfta att det finns två rötter (@Figur_fd). Den första ligger nära *$d approx 0.0191m$*, vilket stämmer med både Newtons metod och SciPy:s fsolve när startgissningen ligger nära denna lösning.
Den andra roten ligger nära *$d approx 0.8314m$* (se @disk:1.1.3c). Detta stämmer väl med körningarna där startgissningar som $0.4$, $0.95$ och $1.1$ konvergerar mot samma andra rot. För en startgissningen $1.5$ konvergerar inte metoden.

#figure(
  image("/assets/del1/man.png", alt: "Bildbeskrivning", width: 80%),
  caption: [plot av $f(d)$ över intervallet $[0, 2]$ ]
) <Figur_fd>


== Värmeväxlare del 1.2 <res1.2>

=== Uppgift 4
Uppgiften syftar till att formulera det icke-linjära ekvationssystemet så att det kan lösas med Newtons metod för system. I metoden konstruerades en vektorvärd funktion $ arrow(F) = (F_1, F_2)$ där $F_1$ (@eq8) och $F_2$ (@eq9) är de två ekvationerna som beskriver systemet. För att implementera Newtons metod för system (@eq:newtonsys), krävs även Jacobimatrisen, som består av de partiella derivatorna av $F_1$ och $F_2$ med avseende på variablerna $d$ och $D_s$.
Jacobimatrisen $J$ kan skrivas som:
$
  J = mat(
    delim: "[",
    (partial F_1)/(partial d), (partial F_1)/(partial D_s);
    (partial F_2)/(partial d), (partial F_2)/(partial D_s);
  )
$

$
  F_2 = c/(D_s^2(S_t-d)^2) - Delta P = c/h(d, D_s) - Delta P quad quad (h(d, D_s) = D_s^2(S_t-d)^2)
$
$  => (partial F_2)/(partial d) = -c/(h(d, D_s)^2)(partial h)/(partial d) = -c(2D_s^2(S_t-d))/(D_s^4(S_t-d)^4) = -(2c)/(D_s^2(S_t-d)^3) $
$  => (partial F_2)/(partial D_s) = -c/(h(d, D_s)^2)(partial h)/(partial D_s) = c(2D_s (S_t-d)^2)/(D_s^4(S_t-d)^4) = (2c)/(D_s^3(S_t-d)^2) $

$
  F_1 = A_(e x)(d, D_s)/(g(d, D_s)) dot Delta T_m - Q, quad quad (g(d, D_s) = 1 slash U_f)
$
$
  => (partial F_1)/(partial d) = Delta T_m ((partial A_(e x))/(partial d)  dot g(d, D_s) - A_(e x) dot (partial g)/(partial d))/g(d, D_s)^2
$
$
  => (partial F_1)/(partial D_s) = Delta T_m ((partial A_(e x))/(partial D_s)  dot g(d, D_s) - A_(e x) dot (partial g)/(partial D_s))/g(d, D_s)^2
$

$
  A_(e x) = pi K_1 D_1^(n_1) dot (d^(1-n_1)) => quad  (partial A_(e x))/(partial d) = -pi K_1 D_1^(n_1)(n_1-1)/(d^n_1)  quad quad (partial A_(e x))/(partial D_s) = pi K_1 n_1 D_1^(n_1-1)/(d^(n_1-1))
$

$(partial g)/(partial d)$ har redan beräknats i @eq15
$
  (partial g)/(partial d) = 1/(D_s dot h_t) + R_(f i)/D_s + (ln(d slash D_s)+1)/(2k_w)
$

$ (partial g)/(partial D_s) = -d/(D_s^2 dot h_t) - d dot R_(f i)/D_s^2 - d /(2k_w D_s) quad (partial/(partial D_s)(d dot ln(d slash D_s))=  1/(d slash D_s) dot -d/(D_s^2) = -1/ D_s  ) $

=== Uppgift 5
*a)*
Upgiften syftar till att implementera Newtons metod för system i _Python_, med den beräknade Jacobimatrisen, för att iterativt närma sig lösningen för $d$ och $D_s$, med startgissningen $d_0 = 0.015m$ och $D_(s 0) = 0.8m$, och en tolerens på $10^(-8)$; samt analysera konvergensen av lösningen.

```python
def jacobian(d, D):
    return np.array([[dF1dd(d, D), dFdD(d, D)],
                     [dF2dd(d, D), dF2dD(d, D)]])

def newton_method_system(d_0, D_0, tolerance, max_iter=10000):
    d_n = d_0
    D_n = D_0
    errors = []
    for i in range(max_iter):
        F_n = F(d_n, D_n)
        J_n = jacobian(d_n, D_n)
        if np.linalg.det(J_n) == 0:  # Avoid singular Jacobian
            print("Jacobian is singular. No solution found.")
            return None

        delta = np.linalg.solve(J_n, -F_n) # Solve J_n * delta = -F_n for this step
        d_next = d_n + delta[0]
        D_next = D_n + delta[1]
        errors.append(np.linalg.norm(delta))

        if np.linalg.norm(delta) < tolerance:
            print(f"Converged to (d={d_next}, D={D_next}) after {i+1} iterations.")
            return d_next, D_next, errors
        d_n, D_n = d_next, D_next

    print("Maximum iterations reached. No solution found.")
    return None
```

Lösningen i python är mycket lika lösningen från del 1.1 (@del1.1), med skillnaden att derivatan är utbytt mot Jacobimatrisen, och att både $d$ och $D_s$ löses ut med hjälp av linjära algebra. Lösningen konvergerar till *$d=0.0118869m$* och *$D_s=0.684476m$* efter 9 iterationer.

*b)*
Genom att använda beräkna felet till normen av uppdateringssteget $delta$, kan konvergensen analyseras på samma sätt som i del 1.1, och uppskatta konvergensordningen $p$ med @eq18

```python
    for i in range(2, len(e)):
        order_of_convergence = np.log(e[i]/e[i-1]) / np.log(e[i-1]/e[i-2])
```

#align(center)[#block(
  fill: luma(81.61%),
  inset: 5pt,
  radius: 4pt,
```bash
Order of convergence at iteration 2: -0.18984893081596307
Order of convergence at iteration 3: -0.33340935241195935
Order of convergence at iteration 4: 10.356263334193248
Order of convergence at iteration 5: 2.745105076264547
Order of convergence at iteration 6: 2.1575607548371583
Order of convergence at iteration 7: 2.017792532754369
Order of convergence at iteration 8: 2.0036658242583423
```
)]

Detta ger en konvergensordning som i början svänger kraftigt, men som sedan stabiliseras runt *2*, vilket ilusterras tydligt i @Figur2 och är i linje med den teoretiska konvergensordningen för Newtons metod (se @disk:1.2.5).

#figure(
  image("/assets/Figure_2.png"),
  caption: [Log log plot av $e_(k+1)$ versus$e_k $ (m)]
)<Figur2>


== Derivataapproximationer del 2.1 <res2.1>

=== Uppgift 6
*a)* Denna uppgift skall härleda den givna approximationen i @eq12 genom att använda Taylorutveckling av funktionen $f$ runt punkten $x+h$, och ta fram det specifika uttrycket för felet i approximationen, som är av ordning $h^2$.

$
  f'(x_j) = (-omega_(j+2) + 4 omega_(j+1) - 3 omega_j) / (2h) + cal(O)(h^2) = (-f(x_j+2h) + 4 f(x_j+h) - 3 f(x_j)) / (2h)
$
$
  f(x_j+2h) = f(x_j) + 2h f'(x_j) + (2h)^2/2 f''(x_j) + (2h)^3/6 f'''(xi_1)
$
$
  f(x_j+h) = f(x_j) + h f'(x_j) + h^2/2 f''(x_j) + h^3/6 f'''(xi_2)
$
Genom att substituera dessa uttryck i approximationen

$
  (-f(x_j) - 2h f'(x_j) - 2h^2 f''(x_j) - 8h^3/6 f'''(xi_1) + 4f(x_j) + 4h f'(x_j) + 2h^2 f''(x_j) + 4h^3/6 f'''(xi_2) - 3f(x_j)) / (2h)
$
$
  = (2h f'(x_j) + 4h^3/6 f'''(xi_2) - 8h^3/6 f'''(xi_1)) / (2h) = f'(x_j) + h^2/3 (f'''(xi_2) - 2f'''(xi_1))
$
$
  = f'(x_j) + cal(O)(h^2)
$
Där $xi_1, xi_2 in [x_j, x_j+2h]$. Detta visar att felet i approximationen är av ordning *$h^2$*.

*b)* Denna uppgift skall implementera tre olika finita differnsmetoder i _Python_ för att approximera derivatan av *$sin(e^x)$* vid *$x=0.75$*. Resultatet skall jämföras med den exakta derivatan, samt analysera plotta felet i varje metod för olika värden av $h=2^(-k)$, där  $k=1,2,3,4,5,6,7,8$.
Beräkningarna gav följande resultat:

#align(center)[
  #block(
    fill: luma(81.61%),
    inset: 8pt,
    radius: 4pt,
```bash
Analytical derivative at x=0.75: -1.09967e+00
h = 5.00000e-01, eq8: -1.30089e+00, eq12: -3.42609e+00, eq13: -5.70715e-01
h = 2.50000e-01, eq8: -1.17237e+00, eq12: -1.15732e+00, eq13: -9.30383e-01
h = 1.25000e-01, eq8: -1.11918e+00, eq12: -1.07648e+00, eq13: -1.05550e+00
h = 6.25000e-02, eq8: -1.10463e+00, eq12: -1.09127e+00, eq13: -1.08889e+00
h = 3.12500e-02, eq8: -1.10091e+00, eq12: -1.09734e+00, eq13: -1.09705e+00
h = 1.56250e-02, eq8: -1.09998e+00, eq12: -1.09907e+00, eq13: -1.09903e+00
h = 7.81250e-03, eq8: -1.09975e+00, eq12: -1.09952e+00, eq13: -1.09951e+00
h = 3.90625e-03, eq8: -1.09969e+00, eq12: -1.09963e+00, eq13: -1.09963e+00
```
  ),
]
#figure(
  image("assets/del2.1/Figure_1.png", width: 80%),
  caption: [Log log plot av felet för olika derivataapproximationer, vid olika värden av $h$ ]
) <Figur:del2.1>

== Randvärdesproblem del 2.2 <res2.2>

=== Uppgift 7 <uppgift7>
Denna uppgift skall diskretisera intervallet $[0, L]$ i $N=4$ delintervall, och approximera andra derivatan för @eq14 med central differens, För att sätta upp det resulterande systemet av icke-linjära ekvationer och dess jacobimatris.

Det diskretiserade ntervallet $[0, L]$ ger 5 punkter: $x=0,space L/4, space  L/2 , space (3L)/4 , space L$. Med dirichlet randvillkor, där $T(0)=T_s$ och $T(L)=T_infinity$, är de okända temperaturerna vid de inre punkterna $T_1=T(L/4)$, $T_2=T(L/2)$, och $T_3=T(3L/4)$.

Från @eq14 och @eq16 kan uttrycket för varje inre punkt skrivas som:
$
  F_j (T_(j-1), T_j, T_(j+1)) = (T_(j+1) - 2T_j + T_(j-1))/(h^2) - alpha_1(T_j-T_infinity) - alpha_2 (T_j^4-T_infinity^4) = 0
$
$ arrow(F)(T_0, T_1, T_2) = (F_1, F_2, F_3) = arrow(0) $
Detta system kan lösas med Newtons metod för system, där $arrow(T)^(k+1)= arrow(T)^(k) - J^(-1) arrow(F)(T^(k))$.
Jacobimatrisen består av de partiella derivatorna av varje $F_j$ med avseende på $T_(j-1)$, $T_j$, och $T_(j+1)$.
$
  J = mat(
    delim: "[",
    (partial F_1)/(partial T_1), (partial F_1)/(partial T_2), (partial F_1)/(partial T_3);
    (partial F_2)/(partial T_1), (partial F_2)/(partial T_2), (partial F_2)/(partial T_3);
    (partial F_3)/(partial T_1), (partial F_3)/(partial T_2), (partial F_3)/(partial T_3);
  )
$
Jacobimatrisen kan delas upp i tre delar: den  triangulära delen, den diagonala delen, och resten av matrisen, där varje del består av de partiella derivatorna av $F_j$ med avseende på $T_(j plus.minus 1)$, $T_j$, och $T_(j+1)$ respektive.

$
  (partial F_j)/(partial T_j) = -2/(h^2) - alpha_1 - 4 alpha_2 T_j^3 quad = quad 1/h^2 dot (-k_j) quad quad (k_j = 2 + alpha_1 h^2 + 4 alpha_2 h^2 T_j^3)
$<eq45>
$
  (partial F_j)/(partial T_(j-1)) = (partial F_j)/(partial T_(j+1)) = 1/(h^2)
$<eq46>
$
  (partial F_j)/(partial T_(j+2)) = (partial F_j)/(partial T_(j-2)) = 0
$<eq47>
Detta ger Jacobimatrisen:

$
  J = 1/h^2 dot mat(
    delim: "[",
    -k_1, 1, 0;
    1, -k_2, 1;
    0, 1, -k_3;

  )
$
Newtons metod  $J Delta T = -arrow(F)(T_k) quad (Delta T= T_(k+1) - T_(k))$ kan sedan lösas med hjälpa av Gauss-Jordans metod, eller ```python delta_T = np.linalg.solve(J, -F_vec)```
 i _Python_.

=== Uppgift 8.1 <uppgift8.1>
I Denna uppgift generaliseras uppgift 7 (@uppgift7[]) för ett godtyckligt antal delintervall *$N$*.

Enlig @eq45, @eq46, och @eq47, kan Jacobimatrisen för ett godtyckligt antal delintervall $N$ skrivas som en tridiagonal matris, där den diagonala delen består av elementen $-k_j/h^2$, och de två närmaste diagonalerna består av elementen $1/h^2$. Resten av matrisen består av nollor.
$
  J = 1/h^2 dot mat(
    delim: "[",
    -k_1, 1, 0, ..., 0;
    1, -k_2, 1, ..., 0;
    dots.v, dots.down, dots.down, dots.down, dots.v;
    0, ..., 1, -k_(N-2), 1;
    0, ..., 0, 1, -k_(N-1);
  )
$

=== Uppgift 8.2 <uppgift8.2>
Denna uppgift skall implementera lösningen av randvärdesproblemet i @uppgift7 (@uppgift7) och @uppgift8.1 (@uppgift8.1) i _Python_.

```python
def finite_difference(a_1, a_2, T_inf, T_s, L, N=100):
    x = np.linspace(0, L, N + 1) # Create a grid of points
    h = L / N # step size
    T0 = np.zeros(N+1) # Initialize an array to store the values at each point.
    T0[0] = T_s
    T0[-1] = T_inf

    def F(T): # Define the function F(T) that represents the system of equations
      F_vec = np.zeros(N-1)
      for i in range(1, N): # Calculate F_i using the finite difference approximation
          F_i = (T[i-1]-2*T[i]+T[i+1])-h**2*(a_1*(T[i]-T_inf)+a_2*(T[i]**4-T_inf**4))
          F_vec[i-1] = F_i
      F_list.append(F_vec)
      return F_vec

    def jacobian(T): # Define the Jacobian matrix of F(T)
        J = np.zeros((N-1, N-1))
        for i in range(1, N):
            J[i-1, i-1] = -2-h**2*(a_1+a_2*4*T[i]**3) # Diagonal elements
            if i > 1: # Calculate the off-diagonal elements.
                J[i-1, i-2] = 1
            if i < N-2:
                J[i-1, i] = 1
        return J

    def newton_method(T0, tol=1e-6, max_iter=1000):
        T = T0.copy()
        T0[i] = T_s + (T_inf - T_s) * (x[i] / L) # Linear interpolation start guess

        ''' code for newton method  can be found in previous sections '''

    T = newton_method(T0)
    return x, T
```

För att få en startgissning för $T$, kan en linjär interpolation mellan randvillkoren användas, där $T_i = T_s + (T_infinity - T_s) dot (x_i / L)$ för varje inre punkt $x_i$.

=== Uppgift 8.3 <uppgift8.3>
Denna uppgift skall använda den implementerade lösningen i uppgift 8.1 (@uppgift8.2[]) för att lösa randvärdesproblemet för $N=400$ delintervall, med givna parammtrar $T(L)=T_(infinity)$ $alpha_1 = (4h_c)/(D dot K)$ och från @Tabell3. Lösningen skall sedan plottas och jämföras med den analytiska lösningen av det linjära problemet, och Noggranhetsordningen beräknas.
$
  T(x) = T_infinity + (T_s - T_infinity) dot e^(-sqrt(alpha_1) x)
$

#align(center)[
  #figure(
  table(
  columns: (auto, auto, auto),
  align: (center, center, center),
  stroke: 0.6pt,
  inset: 5pt,

  [*Parameter*], [*Värde*], [*Enhet*],
  [$h_c$],       [$40$],              [$W slash (m^2 dot K)$],
  [$K$],         [$240$],             [$W slash (m dot K)$],
  [$epsilon$],   [$0.4$],             [],
  [$D$],         [$4.13 dot 10^(-3)$], [$m$],
  [$T_s$],       [$450$],             [$K$ ],
  [$T_oo$],      [$293$],             [$K$ ],
  ),
  caption: [Fläns parametervärden för att testa implementering.],
  ) <Tabell3>
]

Den numeriska $T$ lösningen kan utverderas mot den analytiska $cal(T)$, med hjälp av root mean square error (RMSE) som mått på skillnaden mellan de två lösningarna.
$
e_(r m s) = (1/(N-1) dot sum_(k)^(N-1 )(T_k- cal(T)_k)^2)^(1 slash 2)
$<eq51>
*a)*
Den numeriska lösningen ger en mycket bra approximation av den analytiska lösningen, med ett fele på *$e_(r m s) = 0.00365 space K$*, som i plotten (@Figur3) ser identiska ut. Från @Figur4 kan det även ses att felet är störst nära $x=0$ (se @disk:2.2).

  #figure(
    image("/assets/del2.2.1.png", width: 75%),
  caption: [Numerisk lösning jämfört med analytisk lösning.]
) <Figur3>

#figure(
    image("/assets/del2.2.2.png", width: 70%),
  caption: [Skillnaden mellan numerisk och analytisk lösning över intervallet $[0, L] (m)$.]
) <Figur4>

*b)*
För att beräkna norggrannhetsordningen, kan felet (rms @eq51) beräknas för olika värden av $N = 50, 100, 200, 400, 800$ ($h= L/(N)$), och sedan använda formeln:
$
  e approx C h^(-p) => ln(e) = ln(C) - p ln(h) => p = (ln(e_2) - ln(e_1)) / (ln(h_2) - ln(h_1))
$

Detta resulterade i en uppskattning av noggranhetsordningen *$p=1.98$* (@Figur_loglog_n), vilket är i linje med den teoretiska noggranhetsordningen för central differensmetoden, som är 2.


#figure(
  image("/assets/8.3/Figure_1.png", width: 70%),
  caption: [loglog plot av $e$ mot $n$ för att uppskatta noggranhetsordningen. ]
) <Figur_loglog_n>

=== Del 8.4 <del8.4>
Här ska både den linjära och icke-linjära termen i ekvationen @eq14 lösas, för att modellera värmestrålningens effekt. Lösningen skall implementerar tre olika flänsar med olika materialegenskaper (@Tabell4), och resultaten jämföras in en plot.

givna paramtrar för systemet är: $L=0.30m, quad D=5.0dot 10^(-3)m, quad, T(0)=373.15 K, quad T(L)=293.15 K $

$
  alpha_1 = (4h_c)/(D dot K) quad quad alpha_2 = (4 epsilon sigma)/(D dot K)
$
Där $sigma$ är Stefan-Boltzmanns konstant: $sigma = 5.67 dot 10^(-8) space W slash (m^2 dot K^4)$

#figure(
  table(
  columns: (auto, auto, auto, auto, auto),
  align: (center, center, center),
  stroke: 0.6pt,
  inset: 5pt,

   [*Parameter*], [*SS AISI 316*], [*Aluminium *], [*Koppar *], [*Enhet*],

   [$K$], [$14$], [$180$], [$398$], [$W slash (m dot K)$],
   [$h_c$], [$100$], [$100$], [$100$], [$W slash (m^2 dot K)$],
   [$epsilon$], [$0.17$], [$0.82$], [$0.03$], [],

  ),
  caption: [Fläns parametervärden för olika konstruktioner.],
  ) <Tabell4>

  *a)* Tempraturfördelningen i de tre olika materialen över Längden $L$ kan ses i @Figur5, där det tydligt framgår att kopparflänsen har den mest effektiva värmeöverföringen, följt av aluminium och sedan SS AISI 316 (se @disk:2.2).

#figure(
    image("/assets/del2.2.3.png", width: 85%),
  caption: [Temperaturfördelning i de tre olika materialen över Längden $L$.]
) <Figur5>

*b)*
Genom att beräkna skillnaden i temperaturfördelningen (RMSE) för successivt ökand längder på flänsen (för de olika materialen), kan en längd på flänsen upskattas där skillnaden i temperaturfördelning mellan den nuvarande och tidigare längden mindre än en tolerans ($norm(T_k-T_(k-1)) < epsilon $). Detta ger en uppskattning av när värmestrålningens effekt kan ignoreras i designen av flänsar.

```python
def compare_solutions(L1, L2, h=None):
    x1, T1 = finite_difference(a_1, a_2, T_inf, T_0, L1, N=400)
    x2, T2 = finite_difference(a_1, a_2, T_inf, T_0, L2, N=400)
    T2_on_x1 = np.interp(x1, x2, T2) # interpolate T2 onto the x1 grid
    error = T1 - T2_on_x1 # Calculate the error between the two solutions.
    rmse = np.sqrt(np.mean(error**2))
    return rmse

def find_infinite_length(L0=0.01, rel_tol=1e-3):
    L = L0
    max_L = 100.0  # Set a maximum length to prevent infinite loops
    error_list = []
    L_values = []
    tol = rel_tol * (T_0 - T_inf)  # Set the tolerance based on the relative error
    while L < max_L:
        err = compare_solutions(L, L*0.5)
        error_list.append(err)
        L_values.append(L)

        if err < tol:
            return L, error_list, L_values
        L *= 1.1
```

En rimlig uppskattning för längden där antagandet om oändlig längd skall vara noggrant bör därför vara *0.098m* för SS AISI 316, *0.340m* för aluminium, och *0.548m* för koppar, om toleransen sätts till $1%=0.80K$, och *0.159m* (SS AISI 316), *0.548m* (Aluminium) samt *0.882 m* (koppar) för en tolerans på $0.1%=0.080K$ (se @).

#figure(
  grid(
    columns: 2,
image("/assets/rmse/Figure_1.png"),
image("/assets/rmse/Figure_2.png"),
image("/assets/rmse/Figure_3.png")

  ),
  caption: [loglog plot av RMSE mellan temperaturfördelning för olika längder av flänsen, mot en fläns med 1.5 gånger längre längd, för de tre olika materialen. ],
) <Figur6>

#pagebreak()

= Diskussion <diskussion>
=== Del 1.1 uppgift 3 C) <disk:1.1.3c>

Att metoden ej konvergerar för startgissningen 1.5 beror sannolikt på att funktionens derivata är för låg vid denna punkt (@Figur3), vilket kan leda till att Newtons metod inte konvergerar.

En ytterdiameter på cirka 19 mm (som framtogs i @uppgift2[Uppgift 2]) är fortfarande en rimlig lösning för en värmeväxlare (@Figur1), och detta är därför den fysikaliskt relevanta roten i det aktuella intervallet. Det bör dock understrykas att den andra roten (kring 0.8314m) inte är en rimlig lösning för problemet, eftersom den ger en mycket stor ytterdiameter i förhållande till skalets innerdiameter $D_s = 1.219m$. Den fysikaliskt relevanta lösningen är därför roten nära $0.0191m$.

=== Del 1.2 uppgift 5 <disk:1.2.5>

Utvärderingen av ekvationssystemet ger en ytterdiameter av rörest på 11.9mm, och en innerdiameter av skalet på 68.4cm. Dessa bedöms vara rimliga lösningar för konstruktionen av en värmeväxlare (@Figur1).

Att den uppskattade konvergensordningen för ekvationssystemet fluktuerar kraftigt under de första iterationerna är ett förväntat beteende (@Figur2). Detta beror på att Newtons metod endast är lokalt kvadratiskt konvergent. Under de första iterationerna befinner sig startgissningen utanför den region där Taylorutvecklingens andragradsterm dominerar, vilket gör att stegen styrs av funktionens globala icke-linjäritet.

=== Del 2.1 uppgift 6 b) <disk:2.1.6b>

Att framåt- och bakåtdifferens ger ett något större fel än centraldifferens beror på trunkeringsfelets ledande konstant (@Figur:del2.1). Trots att alla tre metoder har noggrannhetsordning $cal(O)(h^2)$, är konstanten för tre-punkts framåt- och bakåtdifferens ($plus.minus h^2/3 f'''(xi)$) ungefär dubbelt så stor som för centraldifferensen. ($-h^2/6 f'''(xi)$). I en log-log-plot resulterar denna faktor två i en parallellförskjutning uppåt.

Att felet för framåtdifferensen avviker från den raka linjen och "dyker" för stora värden på $h$ förklaras av att $h$ inte är tillräckligt litet, varvid högre ordningars termer (som $h^3$ och $h^4$) i Taylorutvecklingen blir signifikanta. För specifika kombinationer av $x$ och stora $h$ kan feltermerna av olika ordning få motsatta tecken och därmed delvis ta ut varandra. Detta ger tillfälligt ett skenbart lägre fel innan metoden övergår i sitt förväntade asymptotiska beteende när $h$ minskar.

=== Del 2.2 <disk:2.2>

*Uppgift 8.3 a*
Från @Figur4 kan det observeras att felet är störst nära $x=0$. Detta är förväntat, eftersom det är där temperaturgradienten är som störst, vilket kan leda till större numeriska fel i den finita differens approximationen av andra derivatan. Även om felet är störst nära $x=0$, så är det fortfarande mycket litet i absoluta termer, vilket indikerar att den numeriska lösningen är mycket noggrann över hela intervallet.


*Uppgift 8.4*
*a)* <hej>
Tempraturfördelningen i de tre olika materialen över Längden $L$ kan ses i @Figur5. kopparflänsen har den mest effektiva värmeöverföringen. Detta beror fysikaliskt på kopparns högre termiska konduktivitet, vilket möjliggör snabbare värmeöverföring längs flänsen.

*b)*
För att praktiskt kunna jämföra skillnaden i temperaturfördelning för olika längder krävs det att lösningarna utvärderas vid samma x-punkter. Eftersom varje flänslängd ger ett eget diskretiserat rutnät, måste den ena lösningen därför interpoleras till det andra rutnätet innan RMSE beräknas.

Metoden hade möjligen också kunnat implementeras genom att jämföra temperaturfördelningen för en viss längd mot en mycket lång längd $norm(T_(r e f)-T_k) < epsilon quad    (T_(r e f) approx T_infinity)  $. Problemet med denna metod är att givet ett konstant antal delintervall $N=400$, kommer steglängden $h$ att öka. Detta medför att approximationen blir oprecis nära $x=0$, där temperaturgradienten är som störst. Detta skulle kunna lösas genom att variera steglängden $h$ för varje längd, beroende på gradienten.

Detta kunde implementeras separat och gav liknande uppskattningar av den kritiska längden där värmestrålningens effekt kan ignoreras: 0.074 m (SS AISI 316), 0.260 m (Aluminium) och 0.420 m (Koppar) för en tolerans på $0.1%$ (se @bilagaA[Bilaga A]).

Felet (@Figur6) avtar inte helt monotont, vilket sannolikt beror på att lösningarna jämförs på olika diskreta nät och att interpolation därför krävs. Eftersom ett fast antal delintervall används ökar dessutom steglängden när flänslängden växer, vilket påverkar noggrannheten nära $x=0$, och kan ge små lokala variationer i felet.


#pagebreak()

= Bilagor <bilagor>

== Bilaga A <bilagaA>
#figure(
  grid(
    columns: 2,
image("/assets/rmse2/Figure_1.png"),
image("/assets/rmse2/Figure_2.png"),
image("/assets/rmse2/Figure_3.png")

  ),
  caption: [
    RMSE mellan temperaturfördelning för olika längder av flänsen, mot en referenslösning med mycket lång fläns (L=100m)
  ]
)

== Bilaga B <bilagaB>
#figure(
align(center)[#block(
  fill:  luma(81.61%),
  inset: 6pt,
  radius: 4pt,
```bash
Initial guess: d = 0.015000, D = 0.800000
Iteration 1: d = 0.014483, D = 0.753866, Error = 4.61e-02
Iteration 2: d = 0.013815, D = 0.736671, Error = 1.72e-02
Iteration 3: d = 0.013018, D = 0.715934, Error = 2.08e-02
Iteration 4: d = 0.012303, D = 0.696451, Error = 1.95e-02
Iteration 5: d = 0.011947, D = 0.686244, Error = 1.02e-02
Iteration 6: d = 0.011888, D = 0.684513, Error = 1.73e-03
Iteration 7: d = 0.011887, D = 0.684476, Error = 3.76e-05
Iteration 8: d = 0.011887, D = 0.684476, Error = 1.66e-08
Iteration 9: d = 0.011887, D = 0.684476, Error = 3.14e-15
```
)],
caption: [Iterativ lösning av Newtons metod för system, där både $d$ och $D_s$ löses ut samtidigt.]
)