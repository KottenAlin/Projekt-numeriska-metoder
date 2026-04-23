#set document(
  title: "Rapporttitel",
  author: "Författarnamn",
  date: datetime.today()
)

#set page(
  paper: "a4",
  margin: (left: 2cm, right: 3cm, top: 2.5cm, bottom: 2.5cm),
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
  depth: 2
)

#pagebreak()

// Introduktion
= Introduktion

Detta prjekt är en del av kursen SF1546 - Projekt numeriska metoder, och syftar till att tillämpa numeriska metoder för att lösa problem inom värmeöverföring i en värmeväxlare och kylflänsar.

Målet med projektet är att lösaproblem kopplade till värkligheten, med numeriska metoder, särskill de som inehåller ickelinjära ekvationssystem och randvärdesproblem. Genom att använda dessa metoder, kommer vi att kunna analysera och optimera värmeöverföringen i de givna systemen.


Projektet är indelat i två delar, där den första delen syftar till att lösa ett icke-linjärt ekvationssystem som beskriver värmeöverföringen i en värmeväxlare, med hjälp av Newtons metod ($x_(n+1) = x_n - f(x_n)/(f'(x_n))$), för att få beräkna den maximala ytterdimatern *$d$* och sedan innderdiameter $D_s$.

#align(center)[
#image("/assets/image-1.png", alt: "Bildbeskrivning", width: 60%, )]

Den andra delen fokuserar på att lösa ett randvärdesproblem som beskriver värmeöverföringen i en kylfläns.
Med hjälp av diskretisering, med centrerad differns, och finita differnsmetoden, beräknas temperaturfördelningen längs kylflänsen för material med olika egenskaper.

#align(center)[
#image("/assets/image-2.png", alt: "Bildbeskrivning", width: 60%, )
]

= Metod

== Del 1.1 <del1.1>
Det första problemet kan beskrivas av följande icke-linjära ekvationssystem med givna parametrar (@Tabell1):
    $
     Q(d)=A_(e x) dot U_f dot Delta T_m
  $ <eq1>
  $
    U_f = 1/(d/(D_s dot h_t)+d dot R_(f i)/D_s+ (d dot ln(d slash D_s))/(2k_w)+ R_(f o)+ 1/h_s)
  $ <eq2>
#align(center)[
  #figure(
  table(
  columns: (auto, auto, auto),
  align: (center, center, center),
  stroke: 0.6pt,
  inset: 8pt,

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
  Specefikationer för värmeöverföringen i värmeväxlaren är som följer:
  $ Delta T_m = 29.6 degree C$ och $ Q = 801368 W$; den minsta ytarean som upfyller specefkationerna är given till $ A_(e x) = 64.15 m^2$ och skalets innerdiameter är $ D_s = 1.219m$.

Alla parametrar förutom $d$ är kända, och genom att konstruera en funktion $f(d)$ som representerar skillnaden mellan den beräknade värmeöverföringen och den givna värmeöverföringen, kan problemet formuleras som att hitta roten till denna funktion; det vill säga där $f(d) = 0$.
$
  f(d) = A_(e x) dot U_f(d) dot Delta T_m-Q = 0
$
För att lösa denna rot, användes Newtons metod, som iterativt närmar sig lösningen genom att uppdatera gissningen baserat på funktionen och dess derivata.
$
  x_(d+1) = d_n - f(d_n)/f'(d_n)
$


== Del 1.2
Det andra problemet bygger på @del1.1 (del 1.2) med två ytterligare ekvationer och ginva parametrar (@Tabell2), där både $d$ och $D_s$ är okända:

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
  inset: 8pt,

  [*Parameter*], [*Värde*], [*Enhet*],
  [$c$],      [$0.389$],               [$W s dot m$],
  [$S_t$],    [$0.016$],               [$m$],
  [$K_1$],    [$0.249$],               [$m$],
  [$n_1$],    [$2.207$],               [],
  ),
  caption: [Givna parametrar för värmeväxlaren.],
  ) <Tabell2>
]

Specefikationerna för värmeöverföring är samma som i del 1.1 ($Delta T_m = 29.6 degree C$ och $Q = 801368 W$), och en given maximal tryckskillnad över värmeväxlaren $Delta P = 49080 P a$.

och genom att använda de två nya ekvationerna, kan både $d$ och $D_s$ lösas samtidigt genom att konstruera ett system av två icke-linjära ekvationer och använda newtons metod för system.

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



Dess funktioner kan tillsamans konstrueras som en vektorvärd funktion, $ arrow(F) = (F_1, F_2) = arrow(0)$. Detta system av icke-linjära ekvationer kan sedan lösas med hjälp av Newtons metod för system, där $arrow(x) = (d, D_s)$:
$
  arrow(x)_(n+1) = arrow(x)_n - J^(-1) arrow(F)(x_n)
$



== Del 2.1
Denna del går ut på att teoretiskt härleda approximationen i @eq12 med hjälp av Taylorytveckling, och implementera tre olika approximationer i _Python_ för att derivatan av *$sin(e^x)$* vid $x=0.75$.
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




== Del 2.2
Denna del fokuserade på att lösa ett randvärdesproblem som beskriver av differensialekvationen
$
  (d^2 T)/(d x^2) = alpha_1(T-T_infinity) + alpha_2 (T^4-T^4_infinity), quad quad x in [0, L]
$<eq14>
Samt dirichlet randvillkor:
$
  T(0)=T_s, quad quad T(L)=T_inf
$
Detta problem kan lösas genom att diskritetisera andra ordningens derivata med central differens, där den andra derivatan approximativt kan skrivas som:
$
  (d^2 T)/(d x^2) approx (T_(j+1) - 2T_j + T_(j-1))/(h^2) quad quad (+  cal(O)(h^2))
$<eq16>
Där $h=(L)/N$, där $N$ är antalet delintervall.

Vidare kan uttrycket skrivas för varje givet $T_j=T(h j)$ som en funktion: $F_j (T_(j-1), T_j, T_(j+1)) = 0$, där $T_0=T_s$ och $T_N=T_(infinity)$.
Detta ger upphov till ett system av icke-linjära ekvationer ($arrow(F) = (F_1, F_2, ..., F_(N-1)) = arrow(0)$) som kan lösas med hjälp av Newtons metod för system, $arrow(T)^(k+1)= arrow(T)^(k) - J^(-1) arrow(F)(T^(k))$. #footnote[Notera $arrow(T^k)$ används som superskript och inte som exponent ]



= Resultat

== Del 1.1
=== Uppgift 1
Denna del uppgift skall formulera den mattematiska modellen för att implementera newtons metod, genom att beräkna $f(d)$ och dess derivata $f'(d)$ analytiskt.
$f'(d)$ kan beräknas genom att använda kedjeregeln och produktregeln för derivering av vilket ger:
$
  f'(d) = -A_(e x) dot Delta T_m dot U_f '(d)
$
$U_f '(d)$ kan beräknas genom att använda kvotregeln för derivering, där $g(d)$ är nämnaren i uttrycket för $U_f(d)$:
$
  g(d) = d/(D_s dot h_t)+d dot R_(f i)/D_s+ (d dot ln(d slash D_s))/(2k_w)+ R_(f o)+ 1/h_s $
$
  U_f(d) = 1/g(d) = g(d)^(-1) => U_f '(d) = -1/(g'(d)^2)
$
$g(d)$ är relativt enkelt att derivera förutom den logaritmiska termen, där och produktregeln måste användas.



$
  d/(d d)(d dot ln(d slash D_s)) = 1 dot ln(d slash D_s) + d dot 1 /d = ln(d slash D_s) + 1
$#footnote[$d/(d d)(ln(d slash D_s)) = d/(d d)(ln(d)-ln(D_s)) = 1/d- 0$]
Detta ger derivatan:
$
  g'(d) = 1/(D_s dot h_t) + R_(f i)/D_s + (ln(d slash D_s)+1)/(2k_w) + (1/(2k_w))
  $<eq15>
  $ => f'(d) = - (A_(e x) dot Delta T_m )/(1/(D_s dot h_t) + R_(f i)/D_s + (ln(d slash D_s)+1)/(2k_w) )^2
$
=== Uppgift 2
Denna uppgift skall implementera Newtons metod i _Python_, med den beräknade derivatan, för att iterativt närma sig lösningen för $d$, med en startgissning $d_0 = 0.007m$ och en tolerens på $10^(-8)$ (Givet från uppgiften).

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

    print("Maximum iterations reached. No solution found.")
    return None

```

Denna lösning ger svaret *$d=0.00746192m$* efter endast 3 iterationer, vilket visar på en snabb konvergens.
=== Upgift 3
Denna uppgift skall analysera konvergensordningen för Newtons metod genom att använda de beräknade felen från varje iteration. och jämföra lösningen mod pythons egna lösning

*a)*
genom att anta felet som en potensfunktion kan konvergensordningen $p$ uppskattas genom att använda följande formel:
$
 e_(k+1) approx C e_k^p => e_(k+2) approx C e_(k+1)^p
$
$
  e_(k+2)/e_(k+1) = (C e_(k+1)^p)/(C e_k^p) =  (e_(k+1)/e_k)^p => ln(e_(k+2)/e_(k+1)) = p ln(e_(k+1)/e_k) => p = ln(e_(k+2) slash e_(k+1)) / ln(e_(k+1) slash e_k)
$ <eq18>
Implementeringen av detta i _Python_ ger en uppskattning av konvergensordningen *$p=1.9901146 approx 2$*, och stämmer väl överens med den teoretiska konvergensordningen för Newtons metod, som är 2.

*b)* Lösningen från Scipy: (`optimized_solution = optimize.fsolve(f, d_0)`) ger *$d=0.00746195m$*, vilket är i praktiken identiskt med vår implementerade lösning, och bekräftar att vår implementation av Newtons metod är korrekt och effektiv.

*c)*

== Del 1.2
=== Uppgift 4
Denna uppgift skall formulera det icke-linjära ekvationssystemet så att det kan lösas med Newtons metod för system. I metoden konstruerades en vektorvärd funktion $ arrow(F) = (F_1, F_2)$ där $F_1$ (@eq8) och $F_2$ (@eq9) är de två ekvationerna som beskriver systemet. För att implementera Newtons metod för system ($arrow(x)_(n+1) = arrow(x)_n - J^(-1) arrow(F)(x_n)$), krävs även Jacobimatrisen, som består av de partiella derivatorna av $F_1$ och $F_2$ med avseende på variablerna $d$ och $D_s$.
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
$  => (partial F_2)/(partial d) = -c/(h(d, D_s)^2)(partial h)/(partial d) = c(2D_s^2(S_t-d))/(D_s^4(S_t-d)^4) = (2c)/(D_s^2(S_t-d)^3) $
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
  (partial g)/(partial d) = 1/(D_s dot h_t) + R_(f i)/D_s + (ln(d slash D_s)+1)/(2k_w) + (1/(2k_w))
$

$ (partial g)/(partial D_s) = -d/(D_s^2 dot h_t) - d dot R_(f i)/D_s^2 - d /(2k_w D_s) quad (partial/(partial D_s)(d dot ln(d slash D_s))=  1/(d slash D_s) dot -d/(D_s^2) = -1/ D_s  ) $

Jacobimatrisen kan därmed skrivas som:
$
  mat(
    delim: "[",
    Delta T_m ((partial A_(e x))/(partial d)  dot g(d, D_s) - A_(e x) dot (partial g)/(partial d))/g(d, D_s)^2,    = Delta T_m ((partial A_(e x))/(partial D_s)  dot g(d, D_s) - A_(e x) dot (partial g)/(partial D_s))/g(d, D_s)^2 ;
    (2c)/(D_s^2(S_t-d)^3), (2c)/(D_s^3(S_t-d)^2)
  )
$

=== Uppgift 5
*a)*
Denna uppgift skall implementera Newtons metod för system i _Python_, med den beräknade Jacobimatrisen, för att iterativt närma sig lösningen för $d$ och $D_s$, med startgissningen $d_0 = 0.015m$ och $D_(s 0) = 0.8m$, och en tolerens på $10^(-8)$; samt analysera konvergensen av lösningen.

#block(
  fill: luma(81.61%),
  inset: 8pt,
  radius: 4pt,
```python
def jacobian(d, D):
    return np.array([[dF1dd(d, D), dFdD(d, D)],
                     [dF2dd(d, D), dF2dD(d, D)]])

# implement the Newton's method for solving the system of equations F(d, D) = 0
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

        delta = np.linalg.solve(J_n, -F_n) # Solve J_n * delta = -F_n for the update step
        d_next = d_n + delta[0]
        D_next = D_n + delta[1]
        errors.append(np.linalg.norm(delta))

        if np.linalg.norm(delta) < tolerance:
            print(f"Converged to (d={d_next}, D={D_next}) after {i+1} iterations.")
            return d_next, D_next, errors

        d_n, D_n = d_next, D_next

    print("Maximum iterations reached. No solution found.")
    return None
```)

Lösningen i python är mycket lika lösningen från del 1.1 (@del1.1), med skillnaden att derivatan är utbytt mot Jacobimatrisen, och att både $d$ och $D_s$ löses ut med hjälp av linjära algebra. Lösningen konvergerar till *$d=0.0118869m$* och *$D_s=0.684476m$* efter 9 itterationer.

#align(center)[#block(
  fill:  luma(81.61%),
  inset: 8pt,
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
)]

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

Detta ger en konvergensordning som i början svänger kraftigt, men som sedan stabiliseras runt *2*, vilket är i linje med den teoretiska konvergensordningen för Newtons metod ().

#figure(

image("/assets/Figure_2.png"),
caption: [Log log]

)








== Del 2.1
=== Uppgift 6
*a)* Denna uppgift skall härleda den givna approximationen i @eq12 genom att använda Taylorytveckling av funktionen $f$ runt punkten $x+h$, och ta fram det specifika uttrycket för felet i approximationen, som är av ordning $h^2$.

$
  f(x_j) = (-omega_(j+2) + 4 omega_(j+1) - 3 omega_j) / (2h) + cal(O)(h^2) = (-f(x_j+2h) + 4 f(x_j+h) - 3 f(x_j)) / (2h)
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
  = (2h f'(x_j) + 4h^3/6 f'''(xi_2) - 8h^3/6 f'''(xi_1)) / (2h) = f'(x_j) + h^2/3 (f'''(xi_2) - 4f'''(xi_1))
$
$
  = f'(x_j) + cal(O)(h^2)
$
Där $xi_1, xi_2 in [x_j, x_j+2h]$. Detta visar att felet i approximationen är av ordning *$h^2$*.



*b)* Denna uppgift skall implementera tre olika finita differnsmetoder i _Python_ för att approximera derivatan av *$sin(e^x)$* vid $x=0.75$. Resultatet skall jämföras med den exakta derivatan, samt analysera plotta felet i varje metod för olika värden av $h=2^-k$, där  $k=1,2,3,4,5,6,7,8$.
detta gav följande resultat:

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






== Del 2.2

=== Uppgift 7
Denna uppgift skall diskritisera intervallet $[0, L]$ i $N=4$ delintervall, och approximera andra derivatan med central differens, För att sätta upp det resulterande systemet av icke-linjära ekvationer och dess jacobimatris.

Intervallet $[0, L]$ diskretiseras i $N=4$ delintervall, vilket ger 5 punkter: $x_0=0$, $x_1=L/4$, $x_2=L/2$, $x_3=3L/4$, och $x_4=L$. Med dirichlet randvillkor, där $T(0)=T_s$ och $T(L)=T_infinity$, är de okända temperaturerna vid de inre punkterna $T_1=T(L/4)$, $T_2=T(L/2)$, och $T_3=T(3L/4)$.

Från @eq14 och @eq16 kan uttrycket för varje inre punkt skrivas som:
$
  F
$


= Diskussion

Discuss your findings and their implications.

= Slutsats

Summarize your main findings and conclusions.
