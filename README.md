# GATO365-Canvas-Questions-Algorithm

## How to use the code: 

### Step 1: 
#### Put quiz questions into an .xlsx file with the following column names included: 'question_identifier', 'type_questions', 'points', 'question_stem', 'question_options', and 'answer'

### Step 2: 
#### Change all sections that say 'USER INPUT': set working directory, import .xlsx file, quiz title, time limit, max attempts, and write out .xml file name (at end of file)

### Step 3: 
#### Run the code.

### Step 4: 
#### Take the .xml file you create, place into a folder, and zip the folder (Canvas only accepts .zip files)

### Step 5: 
#### Go to your Canvas course. Go to settings (left hand bar). Click 'Import Course Content' (right hand bar). For content type select 'QTI.zip file'. 'Choose file'. Click 'Import' (do NOT check 'Overwrite assessment content with matching IDs).  

## Additional Notes:
### Question Types Available: 
#### - Multiple Choice 
#### - Numeric (Range and Exact Answer) 
#### - Open Ended 
#### - Text Boxes 
### Ident Variable: 
#### Each question/text box needs a UNIQUE identification number. If two ident numbers are the same, both questions won't be in the quiz, only one.
#### The ident variable can be any length (single to infinite digits). 
#### Currently, textboxes autogenerate ident numbers (1, 2, 3, 4, 5...) for each box that appears. Ensure that ident numbers for other entities are greater than the textbox count. 
### Text Boxes: 
#### Currently this code can not change the font size or bold the font. 
#### Textboxes do not need an identification number on the spreadsheet. 
### Images: 
#### Currently this code cannot upload/add images to quiz questions. 
### imsmanifest.xml :
#### This code is currently not needed to upload a quiz to Canvas. No need to run or include in the .zip file. May be of interest in the future if images can be uploaded. 
