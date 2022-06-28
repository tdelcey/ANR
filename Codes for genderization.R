## dplyr for data manipulation ##

library("dplyr")

## readxl to call my excel table into R

library("readxl")

## Writexl to save my outpt to my desktop in excel format

library("writexl")

##Step 1 Call the data##
##To do this on Mac, Select a file or folder and perform a right-click. When the context menu pops up, press and hold the Option key on the keyboard. Copy “File-name” as Pathname option will appear in the context menu. Just click it to copy the full file path to the clipboard.

Table1 <- read_excel("/Users/user/Desktop/ANR_Researcher Details.xlsx")

##Step 2 extract the column of interest, use the pull function. pull()

surname <- pull(Table1,Projet.Partenaire.Responsable_scientifique.Prenom)

## Step 3cAutomate the sex report by applying the gender function

r <- gender(surname)

## Step 4 Print the output 

r

## Step 5 tabulate the output and assign it to result

data.frame(r)
result <- data.frame(r)

##Save to excel to view the full report

write_xlsx(result,"/Users/user/Desktop/Juliet Works/My R Projects/result.xlsx")
## Quit and Save
q()
