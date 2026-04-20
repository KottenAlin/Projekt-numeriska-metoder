#set document(
  title: "Rapporttitel",
  author: "Författarnamn",
  date: datetime.today()
)

#set page(
  paper: "a4",
  margin: (left: 2.5cm, right: 2.5cm, top: 2.5cm, bottom: 2.5cm),
  numbering: "1",
  header: [
    #set align(right)
    Projekt numeriska metoder
  ],

)

#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "sv"
)

#set heading(numbering: "1.1.1")

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
  title: "Table of Contents",
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

Den andra delen fokuserar på att lösa ett randvärdesproblem som beskriver värmeöverföringen i en kylfläns. Med hjälp av diskretisering av och finita differnsmetoden, beräknas temperaturfördelningen längs kylflänsen för material med olika egenskaper.

#align(center)[
#image("/assets/image-2.png", alt: "Bildbeskrivning", width: 60%, )
]

= Metod

== Del 1.1

== Del 1.2

== Del 2.1

== Del 2.2


= Resultat

== Del 1.1a

== Del 1.2

== Del 2.1

== Del 2.2




= Diskussion

Discuss your findings and their implications.

= Slutsats

Summarize your main findings and conclusions.
