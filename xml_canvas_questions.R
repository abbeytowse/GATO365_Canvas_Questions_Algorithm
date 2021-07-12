#libraries 
library(tidyverse)
library(rlist)
library(readxl)

#user input begins 
#USER INPUT 
setwd("C:/Users/towse/R/canvas_quiz/pieces_of_code")    #set directory 

#USER INPUT 
question_bank = read_xlsx('template_of_question_types.xlsx')    #import spreadsheet with questions 

#USER INPUT
title = 'testing template'    #name the quiz 
time_limit = 'unlimited'    #set time limit (minutes or 'unlimited') 
max_attempts = 'unlimited'    #set max attempts (integer or 'unlimited')

#USER INPUT - minutes code currently is not functional
#if no images input 'no_images'
#image_name_list = list('mySquirrelImage.jpg')    #list the images to use in the quiz
#location_num_list = list('item_1', 'item_4')    #list the location of each image 

#num_of_images = length(image_name_list)    #get the num of images in the file 

#user input ends 

#beginning part of xml file, before questions 
beginning_xml_chunk = paste('<?xml version="1.0" encoding="UTF-8"?>
<questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation=
"http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
  <assessment ident="gacc8cbc8c785376e85ccd059145646cb" title="', title,'">
    <qtimetadata>
      <qtimetadatafield>
        <fieldlabel>qmd_timelimit</fieldlabel>
        <fieldentry>', time_limit, '</fieldentry>
      </qtimetadatafield>
      <qtimetadatafield>
        <fieldlabel>cc_maxattempts</fieldlabel>
        <fieldentry>', max_attempts, '</fieldentry>
      </qtimetadatafield>
    </qtimetadata>
    <section ident="root_section">')

#questions start 

question_xml_chunk = ''    #create string of questions in xml
text_box_num = 0    # declare and initiate variable 
for (i in 1:nrow(question_bank)) {    #iterate through each row of the file 
  
  ident = question_bank$question_identifier[i]    #get question identifier
  points = question_bank$points[i]    #get question point value 
  question = question_bank$question_stem[i]    #get question 
  
  image_string = ''    #create blank string for default image name/no image 
  #if (str_detect(location_num_list[1], toString(i)))    #if this question has an image 
  #{
  #image_name = image_name_list[1]    #get image name 
  #image_string = paste('&amp;nbsp;&lt;/p&gt;&lt;p&gt;&lt;img src="$IMS-CC-FILEBASE$/Uploaded%20Media/',image_name,'" alt="',image_name,'"&gt;&amp;nbsp;')
  #image_name_list = image_name_list[-1]     #remove image name from list 
  #location_num_list = location_num_list[-1]    #remove item num from list 
  #}
  
  if (question_bank$type_question[i] == 'multiple_choice') {    #if multiple choice
    question_options = question_bank$question_options[i]
    ans_choices_list = as.list(str_split(question_options, ';')[[1]])    #put into list 
    
    num_ans_choices = length(ans_choices_list)    #get number of answer choices
    corr_ans = question_bank$answer[i]    #get the correct answer 
    corr_ans_index = match(tolower(corr_ans), tolower(ans_choices_list))
    corr_ans_resp = paste('response', corr_ans_index[1]) %>% 
      str_remove_all(' ')    #determine what answer choice option is correct 
    corr_ans_resp_code = paste(corr_ans_index, corr_ans_index, corr_ans_index, corr_ans_index) %>% 
      str_remove_all(' ')    #create code to correspond with correct answer choice
    
    mc_ans_choices_codes = ''   #create string to store codes 
    mc_ans_choices_codes_list = list()   #create empty list to store codes 
    for (i in 1:num_ans_choices){
      num = toString(i)
      four_digit_code = paste(num, num, num, num) %>% 
        str_remove_all(' ')    #create unique code for each answer choice
      mc_ans_choices_codes = paste(mc_ans_choices_codes, four_digit_code, ',')    #make codes string 
      mc_ans_choices_codes_list = list.append(mc_ans_choices_codes_list, four_digit_code)    #make codes list 
    }
    mc_ans_choices_codes = str_remove_all(mc_ans_choices_codes, ' ')    #remove spaces from string 
    
    repeat_mc_code = ''   #create string to store the answer choices xml code 
    for (i in 1:num_ans_choices) {
      resp_val = paste('response', i) %>% 
        str_remove_all(' ')    #create response number 
      repeat_mc_code = paste(repeat_mc_code, '<response_lid ident="',resp_val, '" rcardinality="Single">
                <render_choice>
                  <response_label ident="',mc_ans_choices_codes_list[i],'">
                    <material>
                      <mattext texttype="text/plain">',ans_choices_list[i],'</mattext>
                    </material>
                  </response_label>
                </render_choice>
              </response_lid>')
    }
    
    question_xml_chunk = paste(question_xml_chunk,'<item ident="', ident,'" title="Question">
            <itemmetadata>
              <qtimetadata>
                <qtimetadatafield>
                  <fieldlabel>question_type</fieldlabel>
                  <fieldentry>multiple_choice_question</fieldentry>
                </qtimetadatafield>
                <qtimetadatafield>
                  <fieldlabel>points_possible</fieldlabel>
                  <fieldentry>',points,'</fieldentry>
                </qtimetadatafield>
                <qtimetadatafield>
                  <fieldlabel>original_answer_ids</fieldlabel>
                  <fieldentry>', mc_ans_choices_codes, '</fieldentry>
                </qtimetadatafield>
                <qtimetadatafield>
                  <fieldlabel>assessment_question_identifierref</fieldlabel>
                  <fieldentry>g2e96198227a3229fb48608ba1634367a</fieldentry>
                </qtimetadatafield>
              </qtimetadata>
            </itemmetadata>
            <presentation>
              <material>
                <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;', question, image_string,'&lt;/p&gt;&lt;/div&gt;</mattext>
              </material>', repeat_mc_code,'</presentation>
            <resprocessing>
              <outcomes>
                <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
              </outcomes>
              <respcondition continue="No">
                <conditionvar>
                  <varequal respident="',corr_ans_resp,'">',corr_ans_resp_code,'</varequal>
                </conditionvar>
                <setvar action="Set" varname="SCORE">100</setvar>
              </respcondition>
            </resprocessing>
          </item>')
  }
  else if (question_bank$type_question[i] == 'text_box') {
    text_box_num = text_box_num + 1    #create unique text box identifier 
    text = question_bank$question_stem[i]    #get text 
    question_xml_chunk = paste(question_xml_chunk, '<item ident="', text_box_num,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>text_only_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>0</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry></fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>gf47b767d37e06559ff801f2d253307ba</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;', text, image_string,'&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>
        </presentation>
      </item>')
  }
  else if (question_bank$type_question[i] == 'numeric') {    #numeric question types 
    if (str_detect(question_bank$answer[i], '\\[') == TRUE) {    #range of values 
      num_ranges = question_bank$answer[i] %>% 
        str_count(';') + 1    #determine if there are multiple answers
      answer_string = question_bank$answer[i] %>% 
        str_remove_all('\\[') %>% 
        str_remove_all('\\]') %>% 
        str_replace_all(';', ',')    #reformat answer 
      answer_list = as.list(str_split(answer_string, ',')[[1]])    #place answer in list 
      repeat_numeric_code = ''    #blank string to store repeat section 
      j = 1
      for (i in 1:num_ranges) {    #repeat for the number of ranges
        repeat_numeric_code = paste(repeat_numeric_code, '<respcondition continue="No">
              <conditionvar>
                <vargte respident="response1">',answer_list[j + 1],'</vargte>
                <varlte respident="response1">',answer_list[j],'</varlte>
              </conditionvar>
              <setvar action="Set" varname="SCORE">100</setvar>
            </respcondition>')
        j = j + 2    #move to next set of answers
      }
      question_xml_chunk = paste(question_xml_chunk, '<item ident="',ident,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>numerical_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>',points,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry>1588,3549</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>g5323b39cb52872f8e8bb48952d3b6cf1</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question, image_string,'&amp;nbsp;&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>
          <response_str ident="response1" rcardinality="Single">
            <render_fib fibtype="Decimal">
              <response_label ident="answer1"/>
            </render_fib>
          </response_str>
        </presentation>
        <resprocessing>
          <outcomes>
            <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
          </outcomes>',repeat_numeric_code,'
        </resprocessing>
      </item>')
    }
    else {    #numeric with exact answer
      num_ranges = question_bank$answer[i] %>% 
        str_count(';') + 1    #determine the number of ranges 
      answer_string = question_bank$answer[i] %>% 
        str_replace_all(';', ',')    #reformat answer string
      answer_list = as.list(str_split(answer_string, ',')[[1]])    #turn answer into list 
      repeat_numeric_code = ''    #create string to store repeat code 
      # find how this is formated in the spreadsheet: 
      margin_of_error = 0
      j = 1
      for (i in 1:num_ranges) {
        repeat_numeric_code = paste(repeat_numeric_code, '<respcondition continue="No">
            <conditionvar>
              <or>
                <varequal respident="response1">',answer_list[j],'</varequal>
                <and>
                  <vargte respident="response1">', toString(as.numeric(answer_list[j]) - margin_of_error),'</vargte>
                  <varlte respident="response1">', toString(as.numeric(answer_list[j]) + margin_of_error),'</varlte>
                </and>
              </or>
            </conditionvar>
            <setvar action="Set" varname="SCORE">100</setvar>
          </respcondition>')
        j = j + 1    #move to the next set of answers
      }
      question_xml_chunk = paste(question_xml_chunk, '<item ident="',ident,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>numerical_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>',points,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry>4256,6031</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>gbaffeae35dd6407e2901b7f363db9209</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question, image_string,'&amp;nbsp;&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>
          <response_str ident="response1" rcardinality="Single">
            <render_fib fibtype="Decimal">
              <response_label ident="answer1"/>
            </render_fib>
          </response_str>
        </presentation>
        <resprocessing>
          <outcomes>
            <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
          </outcomes>',repeat_numeric_code,'
        </resprocessing>
      </item>')
    }
  }
  else if (question_bank$type_question[i] == 'open_ended') {
    question_xml_chunk = paste(question_xml_chunk, '<item ident="',ident,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>essay_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>',points,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry></fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>gb87d4651e63409338eb1a6e61f8fde8f</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question,'&amp;nbsp;&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>
          <response_str ident="response1" rcardinality="Single">
            <render_fib>
              <response_label ident="answer1" rshuffle="No"/>
            </render_fib>
          </response_str>
        </presentation>
        <resprocessing>
          <outcomes>
            <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
          </outcomes>
          <respcondition continue="No">
            <conditionvar>
              <other/>
            </conditionvar>
          </respcondition>
        </resprocessing>
      </item>')
  }
  else if (question_bank$type_question[i] == 'matching') {
    question_options = paste('', question_bank$question_options[i])    #add space in front for match() purposes
    ans_choices_list = as.list(str_split(question_options, ';')[[1]])    #put into list 
    num_of_choices = length(ans_choices_list)    #get the num of answer choices
    
    matches = question_bank$answer[i]    #get the match combinations 
    matches_list = as.list(str_split(matches, ';')[[1]])    #transform into list 
    num_of_matches = length(matches_list)    #get number of matches the student needs to make 
    
    matching_part_1_codes = ''     #create blank string to store codes in 
    matching_part_1_codes_list = list()    #create blank list to store codes in 
    for (i in 1:num_of_matches) { 
      num = toString(i)
      four_digit_code = paste(num, num, num, num) %>% 
        str_remove_all(' ')    #create unique code for each match
      matching_part_1_codes = paste(matching_part_1_codes, four_digit_code, ',')    #make codes string 
      matching_part_1_codes_list = list.append(matching_part_1_codes_list, four_digit_code)    #make codes list 
    }
    
    matching_ans_choices_codes_list = list()    #create blank list to store codes in 
    for (i in 1:num_of_choices) {
      num = toString(i)
      five_digit_code = paste(num, num, num, num, num) %>% 
        str_remove_all(' ')    #create unique code for each answer choice 
      matching_ans_choices_codes_list = list.append(matching_ans_choices_codes_list, five_digit_code)    #make codes list
    }
    
    matching_part_1_list = list()    #create blank list to store first half of match in 
    matching_part_2_list = list()    #create blank list to store second half of match in 
    for (i in 1:num_of_matches) {
      part_1 = gsub('-.*', '', matches_list[i])    #get first half of match 
      matching_part_1_list = list.append(matching_part_1_list, part_1)    #add to list 
      part_2 = gsub('.*-', '', matches_list[i])    #get second half od match 
      matching_part_2_list = list.append(matching_part_2_list, part_2)    #add to list 
    }
    
    inner_repeat_matching_code = ''    #create blank string to store repeated code in 
    for (i in 1:num_of_choices) { 
      resp_ident =  matching_ans_choices_codes_list[i]    #get the ident number from list 
      ans_choice = ans_choices_list[i]    #get answer choice from list 
      inner_repeat_matching_code = paste(inner_repeat_matching_code, '<response_label ident="',resp_ident,'">
                <material>
                  <mattext>',ans_choice,'</mattext>
                </material>
              </response_label>')    #add to string 
    }
    
    resp_val_list = list()    #create blank list to stroe response_ident in
    for (i in 1:num_of_matches) {
      resp_val = paste('response_', matching_part_1_codes_list[i]) %>% 
        str_remove_all(' ')    #create response_ident 
      resp_val_list = list.append(resp_val_list, resp_val)    #add to list 
    }
    
    repeat_options_matching_code = ''    #create blank string to store repeating section in 
    for (i in 1:num_of_matches) {
      repeat_options_matching_code = paste(repeat_options_matching_code, '<response_lid ident="',resp_val_list[i],'">
            <material>
              <mattext texttype="text/plain">',matching_part_1_list[i],'</mattext>
            </material>
            <render_choice>
            ',inner_repeat_matching_code,'
            </render_choice>
          </response_lid>')    #create the repeating chunk of code 
    }
    
    repeat_correct_matches_code = ''    #create blank string to store repeating section in 
    for (i in 1:num_of_matches) {
      code_index = match(tolower(matching_part_2_list[i]), tolower(ans_choices_list))
      part_2_code = matching_ans_choices_codes_list[code_index]    #get the ident of the match answer
      repeat_correct_matches_code = paste(repeat_correct_matches_code, '<respcondition>
            <conditionvar>
              <varequal respident="',resp_val_list[i],'">',part_2_code,'</varequal>
            </conditionvar>
            <setvar varname="SCORE" action="Add">25.00</setvar>
          </respcondition>')
    }
    
    #concatenate all the pieces of code together 
    question_xml_chunk = paste(question_xml_chunk, '<item ident="',ident,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>matching_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>',points,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry>',matching_part_1_codes,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>g9e2583dcc067eeca9a05065914a829f6</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question,'&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>
          ',repeat_options_matching_code,'
        </presentation>
        <resprocessing>
          <outcomes>
            <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
          </outcomes>
          ',repeat_correct_matches_code,'
        </resprocessing>
      </item>')
  }
  else if (question_bank$type_question[i] == 'file_upload') {
    question_xml_chunk = paste(question_xml_chunk, '<item ident="',ident,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>file_upload_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>',points,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry></fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>geb62e5d9e6507b736be3933f340e55a5</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question,'&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>
        </presentation>
        <resprocessing>
          <outcomes>
            <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
          </outcomes>
        </resprocessing>
      </item>')
  }
  else if (question_bank$type_question[i] == 'select_all') {
    select_all_ans_options = question_bank$question_options[i]
    ans_choices_list = as.list(str_split(select_all_ans_options, ';')[[1]])    #put into list 
    num_ans_choices = length(ans_choices_list)    #get number of answer choices
    
    answers = question_bank$answer[i]
    answers_list = as.list(str_split(answers, ';')[[1]])
    num_corr_answers = length(answers_list)
    
    corr_ans_index_list = list()
    for (i in 1:num_corr_answers) {
      corr_answer = answers_list[i]
      corr_ans_index = match(tolower(corr_answer), tolower(ans_choices_list))
      corr_ans_index_list = list.append(corr_ans_index_list, corr_ans_index)
    }
    
    select_all_ans_choices_codes = ''   #create string to store codes 
    select_all_ans_choices_codes_list = list()   #create empty list to store codes 
    for (i in 1:num_ans_choices){ 
      num = toString(i)
      four_digit_code = paste(num, num, num, num) %>% 
        str_remove_all(' ')    #create unique code for each answer choice
      select_all_ans_choices_codes = paste(select_all_ans_choices_codes, four_digit_code, ',')    #make codes string 
      select_all_ans_choices_codes_list = list.append(select_all_ans_choices_codes_list, four_digit_code)    #make codes list 
    }
    select_all_ans_choices_codes = str_remove_all(select_all_ans_choices_codes, ' ')    #remove spaces from string 
    
    corr_ans_codes_list = list()
    for (i in 1:num_corr_answers) {
      index = as.numeric(corr_ans_index_list[i])
      code = as.numeric(select_all_ans_choices_codes_list[index])
      corr_ans_codes_list = list.append(corr_ans_codes_list, code)
    }
    
    select_all_repeat_code = ''
    for (i in 1:num_ans_choices) { 
      ans_choice_code = toString(select_all_ans_choices_codes_list[i])
      ans_choice = toString(ans_choices_list[i])
      select_all_repeat_code = paste(select_all_repeat_code, '<response_label ident="',ans_choice_code,'">
                <material>
                  <mattext texttype="text/plain">',ans_choice,'</mattext>
                </material>
              </response_label>')
    }
    
    #if code in correct list matches code in code list it is a yes, if not it is a no 
    correct_ans_chunk = ''
    for (i in 1: num_ans_choices) {
      ans_code = toString(select_all_ans_choices_codes_list[i])
      if (is.element(select_all_ans_choices_codes_list[i], corr_ans_codes_list)) {
        correct_ans_chunk = paste(correct_ans_chunk, '<varequal respident="response1">',ans_code,'</varequal>')
      }
      else {
        correct_ans_chunk = paste(correct_ans_chunk, '<not>
                  <varequal respident="response1">',ans_code,'</varequal>
                </not>')
      }
    }
    question_xml_chunk = paste(question_xml_chunk, '<item ident="',ident,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>multiple_answers_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>',points,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry>',select_all_ans_choices_codes,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>g3402a0510e1a8ec02312a3128ffbd635</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question,'&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>
          <response_lid ident="response1" rcardinality="Multiple">
            <render_choice>
              ',select_all_repeat_code,'
            </render_choice>
          </response_lid>
        </presentation>
        <resprocessing>
          <outcomes>
            <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
          </outcomes>
          <respcondition continue="No">
            <conditionvar>
              <and>
                ',correct_ans_chunk,'
              </and>
            </conditionvar>
            <setvar action="Set" varname="SCORE">100</setvar>
          </respcondition>
        </resprocessing>
      </item>')
  }
}

#questions stop 

#ending part of xml code after questions 
ending_xml_chunk = '    </section>
  </assessment>
</questestinterop>
'

#complete xml code 
xml_chunk = paste(beginning_xml_chunk, question_xml_chunk, ending_xml_chunk) 

#write xml file 
#USER INPUT
write(xml_chunk, file = 'testing_template.xml')