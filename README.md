# GATO365-Canvas-Questions-Algorithm

## How to use the code: 

### Step 1: 
#### Put quiz questions into an .xlsx file with the following column names included: 'question_identifier', 'type_question', 'points', 'question_stem', 'question_options', and 'answer'

### Step 2: 
#### Change all sections that say 'USER INPUT': set working directory, import .xlsx file, quiz title, time limit, max attempts, and write out .xml file name (at end of file)

### Step 3: 
#### Run the code.

### Step 4: 
#### Go to your Canvas course. Go to settings (left hand bar). Click 'Import Course Content' (right hand bar). For content type select 'QTI.zip file'. 'Choose file'. Click 'Import' (do NOT check 'Overwrite assessment content with matching IDs).  

## Additional Notes:
### Question Types Available: 
#### - Multiple Choice (multiple_choice)
##### Spreadsheet format answer choices: answer choice A; answer choice B; answer choice C; etc.
###### Correct answer must be listed first
#### - Numeric (Range and Exact Answer) (numeric)
##### Spreadsheet format Range answer: [1, 2] 
###### If you want multiple ranges to be acceptable: [1, 2]; [-1, -2]; etc. 
##### Spreadsheet format Exact Answer answer: 2
###### If you want multiple exact answers to be acceptable: 2; 1; etc. 
#### - Open Ended (open_ended)
#### - Text Boxes (text_box)
##### Spreadsheet format: put textbox words in the question_stem column. Only need to fill out question type (text_box) and question stem. 
#### - Matching (matching)
##### Spreadsheet format answer choices: match option A; match option B; match option C; etc. 
##### Spreadsheet format answer: explantory variable - match option B; response varaible - match option A; etc. 
#### - File Upload (file_upload)
##### Spreadsheet format: only need to fill out question_stem, identification, and points. 
#### - Select All That Apply (select_all)
##### Spreadsheet format answer choices: answer choice A; answer choice B; answer choice C; etc. 
##### Spreadsheet format answer: answer choice A; answer choice C; etc. 
#### - Fill In The Blank (fill_in_the_blank)
##### Spread sheet format question: the dog goes _______.
###### - must type out the blank using underscores 
##### Spread sheet answer format: woof; bark; etc. 
###### - list all acceptable answers 
### Ident Variable: 
#### Each question/text box needs a UNIQUE identification number. If two ident numbers are the same, both questions won't be in the quiz, only one.
#### The ident variable can be any length (single to infinite digits). 
#### Currently, textboxes autogenerate ident numbers (1, 2, 3, 4, 5...) for each box that appears. Ensure that ident numbers for other entities are greater than the textbox count. 
#### Using idents of the same number of four digits long or five digits long will conflict with other aspects of the code (ie 1111 or 77777)
### Text Boxes: 
#### Currently this code can not change the font size or bold the font. 
#### Textboxes do not need an identification number on the spreadsheet. 
### Images: 
#### Currently this code cannot upload/add images to quiz questions. 
### imsmanifest.xml :
#### This code is currently not needed to upload a quiz to Canvas. No need to run or include in the .zip file. May be of interest in the future if images can be uploaded. 
### assessment_metadata.xml :
#### This code is currently not needed to upload a quiz to Canvas. No need to run or include in the .zip file. May be of interest in the future to indicate quiz deadlines, shuffle answers, etc. via the XML code. Likely easier to set these settings manually. 
