#set document(
  title: "Report Title",
  author: "Author Name",
  date: datetime.today()
)

#set page(
  paper: "a4",
  margin: (left: 2.5cm, right: 2.5cm, top: 2.5cm, bottom: 2.5cm),
  numbering: "1",
  header: [
    #set align(right)
    Report Document
  ],

)

#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "en"
)

#set heading(numbering: "1.1.1")

// Title Page
#align(center)[
  #v(2cm)
  #text(size: 24pt, weight: "bold")[Report Title]
  #v(0.5cm)
  #text(size: 14pt)[Subtitle or Project Name]
  #v(3cm)
  #text(size: 12pt)[Author Name]
  #v(0.2cm)
  #text(size: 11pt)[Date: #datetime.today().display()]
  #v(5cm)
]

#pagebreak()

// Table of Contents
#outline(
  title: "Table of Contents",
  depth: 2
)

#pagebreak()

// Introduction
= Introduction

This is the introduction section of your report. Replace this text with your actual content.

== Subsection

Add your subsection content here.

= Methodology

Describe your methodology in this section.

== Method 1

Details about method 1.

== Method 2

Details about method 2.

= Results

Present your results here.




= Discussion

Discuss your findings and their implications.

= Conclusion

Summarize your main findings and conclusions.

= References
