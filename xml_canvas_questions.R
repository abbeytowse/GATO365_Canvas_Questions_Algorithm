#libraries 
library(tidyverse)
library(rlist)
library(readxl)

setwd("C:/Users/towse/R/canvas_quiz/pieces_of_code")    #set directory 

question_bank = read_xlsx('my_mc__text_box_numeric_fake_quiz.xlsx')    #import spreadsheet with questions 

title = 'my 10 mc and numeric questions with text boxes xml chunk'    #name the quiz 
time_limit = 'unlimited'    #set time limit (minutes or 'unlimited') 
max_attempts = 'unlimited'    #set max attempts (integer or 'unlimited)

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
 
   if (question_bank$type_question[i] == 'multiple_choice') {    #if multiple choice
    question_options = question_bank$question_options[i] %>% 
      str_replace_all(';', ',')    #replace ';' with ','
    ans_choices_list = as.list(str_split(question_options, ',')[[1]])    #put into list 
   
    num_ans_choices = length(ans_choices_list)    #get number of answer choices
    corr_ans = question_bank$answer[i]    #get the correct answer 
    corr_ans_index = match(tolower(corr_ans), tolower(ans_choices_list))
    corr_ans_resp = paste('response', corr_ans_index[1]) %>% 
      str_remove_all(' ')    #determine what answer choice option is correct 
    corr_ans_resp_code = paste(corr_ans_index, corr_ans_index, corr_ans_index, corr_ans_index) %>% 
      str_remove_all(' ')    #create code to correspond with correct answer choice

    ans_choices_codes = ''   #create string to store codes 
    ans_choices_codes_list = list()   #create empty list to store codes 
    for (i in 1:num_ans_choices){
      num = toString(i)
      four_digit_code = paste(num, num, num, num) %>% 
        str_remove_all(' ')    #create unique code for each answer choice
      ans_choices_codes = paste(ans_choices_codes, four_digit_code, ',')    #make codes string 
      ans_choices_codes_list = list.append(ans_choices_codes_list, four_digit_code)    #make codes list 
    }
    ans_choices_codes = str_remove_all(ans_choices_codes, ' ')    #remove spaces from string 

    repeat_mc_code = ''   #create string to store the answer choices xml code 
    for (i in 1:num_ans_choices) {
      resp_val = paste('response', i) %>% 
        str_remove_all(' ')    #create response number 
      repeat_mc_code = paste(repeat_mc_code, '<response_lid ident="',resp_val, '" rcardinality="Single">
                <render_choice>
                  <response_label ident="',ans_choices_codes_list[i],'">
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
                  <fieldentry>', ans_choices_codes, '</fieldentry>
                </qtimetadatafield>
                <qtimetadatafield>
                  <fieldlabel>assessment_question_identifierref</fieldlabel>
                  <fieldentry>g2e96198227a3229fb48608ba1634367a</fieldentry>
                </qtimetadatafield>
              </qtimetadata>
            </itemmetadata>
            <presentation>
              <material>
                <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;', question, '&lt;/p&gt;&lt;/div&gt;</mattext>
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
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;', text,'&lt;/p&gt;&lt;/div&gt;</mattext>
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
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question,'&amp;nbsp;&lt;/p&gt;&lt;/div&gt;</mattext>
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
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;',question,'&amp;nbsp;&lt;/p&gt;&lt;/div&gt;</mattext>
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
write(xml_chunk, file = 'my_10_question_mc_and_numeric_quiz_with_text_boxes_xml_chunk.xml')