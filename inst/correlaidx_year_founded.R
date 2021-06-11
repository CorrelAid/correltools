local_chapters_year_founded <- tibble::tribble(
  ~chapter_de, ~chapter_en, ~year_founded,
  'Berlin', 'Berlin', 2018,
  'Bremen', 'Bremen', 2018,
  'Köln', 'Cologne', 2021,
  'Dortmund', 'Dortmund', 2018,
  'Göttingen', 'Göttingen', 2019,
  'Hamburg', 'Hamburg', 2020,
  'Jena', 'Jena', 2021,
  'Karlsruhe', 'Karlsruhe', 2021,
  'Konstanz', 'Konstanz', 2018,
  'Leipzig', 'Leipzig', 2021,
  'Mannheim', 'Mannheim', 2018,
  'München', 'Munich', 2020,
  'Nederland', 'Netherlands', 2018,
  'Rhein-Main', 'Rhein-Main', 2018,
  'Ruhrgebiet', 'Ruhrgebiet', 2018,
  'Stuttgart', 'Stuttgart', 2020,
  'Switzerland', 'Switzerland', 2021,
  'Paris', 'Paris', 2019
)

usethis::use_data(local_chapters_year_founded, internal = FALSE, overwrite = TRUE)
