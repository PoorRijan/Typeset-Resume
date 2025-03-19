#let content = yaml("information.yaml") // Get the content file
// Set global params and values

#set page(
  margin: 0.5cm,
  numbering: "1",
)

#set text(
  size: 10pt,
  hyphenate: false,
)

#set list(
  spacing: 6pt
)

#set par(
  leading: 6pt,
  justify: true,
)
// #show par: set block(spacing: 4pt)

#show heading.where(
    level: 2,
): it => block(width: 100%)[
    #set align(left)
    #set text( size: 1em, weight: "bold")
    #it.body 
    #line(length: 100%, stroke: 1pt + black)
    #v(0em)// draw a line 
]

// Name title/heading
#show heading.where(
    level: 1,
): it => block(width: 100%)[
    #set text( size: 1.5em, weight: "bold")
    #it.body
    #v(-1em)
    #line(length: 100%)
]

#set heading(level: auto)

// Generic functions to keep the code readible

// My goal with these functions is to make them as reproducible as possible

#let contacts(entry) = {
  if (entry.at("URL",default:none) != none and entry.at("Logo", default:none)!= none) {
   box(image(entry.Logo),height:1em)
   link(entry.URL)[#entry.Show] 
   h(1cm)
  } else if entry.at("URL", default:none) != none {
   link(entry.URL)[#entry.Show] 
  } else if entry.at("Logo",default:none) != none {
    box(image(entry.Logo),height:1em)
    [#entry.Show] 
  } else {
    [#entry.show] 
  }
}

#let introduction(content) = {
  set align(center)
  
  [
    #set text(size: 2.0em, weight: "bold")
    
    #upper(content.Name)
    
    #v(-0.75em)
  ]

  
  [
    #set text(size: 1.25em, weight: "bold")
    
    #content.Profession
    
    #v(-0.75em)
  ]
  
  [
    #set text(size: 1em)
    
    #content.Location

    #v(-0.75em)  
  ]


  [
    #set text(size: 11pt)
      
    #for entry in content.Contacts [
     #contacts(entry)
    ]
  ]
}


#let experience_function(experience_entry) = {
  [
    *#experience_entry.Position* #h(1fr) *#experience_entry.Start* - *#experience_entry.End* \
    #if (experience_entry.at("URL", default: none) != none) [
      #underline[#link(experience_entry.URL)[#experience_entry.Company]] #h(1fr) #experience_entry.Location \
    ] else [
      #underline[#experience_entry.Company] #h(1fr) #experience_entry.Location \
    ]
    #for task in experience_entry.Tasks [
      - #eval(task, mode: "markup")
    ]
    #v(-0.25em)
  ]
}

#let education_entry(education_entry) = {
  [
    #if (education_entry.at("URL", default: none) != none) [
      *#underline[#link(education_entry.URL)[#education_entry.Institute]]* #h(1fr) *#education_entry.Location* \
    ] else [
      *#underline[#education_entry.Institute]* #h(1fr) *#education_entry.Location* \
    ]
    #text(style: "italic")[#education_entry.Degree] #h(1fr) #education_entry.Start - #education_entry.End \ 
  ]
}

#let awards_function(awards_entry) = {
  [
    *#underline[#awards_entry.Name]* #h(1fr) *#awards_entry.Organization* \
    #awards_entry.Date \
    #for note in awards_entry.Notes [
      - #note
    ] #v(-0.5em)
  ]
}

#let skills_entry(skills_entry) = {
  [
    #v(-0.10em)
    *#underline[#skills_entry.Section]* \
    #for hit in skills_entry.Tools [
      #v(-0.25em)
      *#hit.Tool*: \ 
      #for entry in hit.Tasks [
        - #entry \
      ]
    ] 
  ]
}

#let publication_entry(publication_entry) = {
  [
    #if (publication_entry.at("URL", default: none) != none) [
      *#underline[#link(publication_entry.URL)[#publication_entry.Name]]* #h(1fr) *#publication_entry.Date*\
    ] else [
      *#underline[#publication_entry.Name]* #h(1fr) *#publication_entry.Date*\
    ]
    #publication_entry.DOI \
    #v(-0.5em)
  ]
}

// Actual content

// For now there are these manually written #v() adjustments throughout the page because I do not know a better way.

#v(-1em)

#introduction(content.Introduction)

#v(-1em)

= Experience
#for entry in content.Experience {
  experience_function(entry)
}
// #work_entry(content.Work)

#v(-0.75em) // to compensate for the previous sections's trailing white space

= Education 

#for entry in content.Education {
  education_entry(entry)
}

= Research and Publications

#v(0.5em)

#for entry in content.Publications {
  publication_entry(entry)
}

= Awards

#for entry in content.Awards {
  awards_function(entry)
}

#pagebreak()

= Skills

// The grid makes it such that the items are distributed into two columns
// For more information
// visit https://stackoverflow.com/questions/78938372/how-to-send-content-into-specific-boxes-in-typst

#for entry in content.Skills {
  skills_entry(entry)
}

